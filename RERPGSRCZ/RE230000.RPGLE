     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                     BUG27288
/*STD *  RPGBASEBNC                                                   *                     BUG27288
/*EXI *  TEXT('Midas RE retail account balance extract - I/C')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE230000 - Midas RE retail account balance extract - IC      *
      *                                                               *
      *  Function:  This program will extract retail account balance  *
      *                                                               *
      *                                                               *
      *  Called By: SCTRIGGER - Midas SC file trigger control program *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD039463           Date 11Aug16               *
      *                 CRE095             Date 25Apr14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG28110A          Date 08Sep10               *
      *                 BUG27978           Date 09Aug10               *
      *                 BUG27967           Date 04Aug10               *
      *                 BUG27942           Date 29Jul10               *
      *                 BUG27878           Date 06Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27583           Date 30Apr10               *
      *                 BUG27288           Date 07Apr10               *
      *                 BUG27229A          Date 17Mar10               *
      *                 BUG27229           Date 17Mar10               *
      *                 CAP202  *CREATE    Date 09Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039463 - Issue Facilities to be linked to Retail account   *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876 - ABC - Forward Days 1 should = DNWD-1, not just   *
      *              RUND (Child: AR1095877) (Recompile)              *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG28110A - Updated ledger balance was not reflected         *
      *  BUG27978 - Switch on of CAP202 failed                        *
      *  BUG27967 - Inserted Blocked Collateral not shown in          *
      *             PABE Details                                      *
      *  BUG27942 - Current Cleared Balance is updated online (IC)    *
      *             after a transaction (Account transfer) is done    *
      *  BUG27878 - Projected Available Balance Enquiry               *
      *  BUG27583 - Unauthorized Facility                             *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE                                      *
      *  BUG27229A - RPG Compilation Issues - Redeliver the programs  *
      *              with reference to F1AVA0                         *
      *  BUG27229 - RPG Compilation Issues - Redeliver the programs   *
      *             without reference to F1AVA0                       *
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
      * *PSSR    - Error processing                                   *
      * *INZSR   - Initialise                                         *
      * SrMAIN   - Program Main routine                               *
      * SrACCNT  - Process records triggered from ACCNTAB             *
      * SrSDCUR  - Process records triggered from SDCURRPD            *
      * SrSDCUS  - Process records triggered from SDCUSTPD            *
      * SrSDBRC  - Process records triggered from SDBRCHPD            *
      **SrMEMOS**-*Process*records*triggered*from*MEMOS****************                     BUG27942
      * SrFCLTY  - Process records triggered from FCLTYFM or FCLTYFN  *
      * SrFACILT - Call Access program object AOFCLTR0                *
      * SrMVFLDS - Move ACCNTAB field to output file field            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ***Retail*Account*Balance*Extract*-*Denormalized*****************                     BUG27288
      ***Update*LF*for*ACCNTAB*and*SDBRCHPD*triggers*******************                     BUG27288

     F***RERABEL0  UF A E           K DISK    INFSR(*PSSR)                                  BUG27288
      ***Update*LF*for*SDCURRPD*trigger********************************                     BUG27288

     F***RERABEL1  UF A E           K DISK    INFSR(*PSSR)                                  BUG27288
     F**********                              RENAME(RERABED0:RERABED1)                     BUG27288
      ***Update*LF*for*FCLTYFM*or*FCLTYFN*trigger**********************                     BUG27288

     F***RERABEL2  UF A E           K DISK    INFSR(*PSSR)                                  BUG27288
     F**********                              RENAME(RERABED0:RERABED2)                     BUG27288
      ***Update*LF*for*SDCUSTPD*trigger********************************                     BUG27288

     F***RERABEL3  UF A E           K DISK    INFSR(*PSSR)                                  BUG27288
     F**********                              RENAME(RERABED0:RERABED3)                     BUG27288
      ***Global*Customers*X-Reference*Retrieval*index******************                     BUG27288

     F***GPCUSTXL1 IF   E           K DISK    INFSR(*PSSR)                                  BUG27288

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.

      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program Status Data Structure

      ** +------------------------------------------------------------+
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

     D Z_ACCNT       E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(W_)
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
     D Z_GLACN       E DS                  EXTNAME(GLACNTQD)
     D
                                                                                            BUG27288
     D GPRABE        E DS                  EXTNAME(GPRABEPD)                                BUG27288

     D P@IMGDS         DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  PMBRNAME              21     30
      * Trigger event
     D  PTRGEVENT             31     31
      * Offset to the before image of the record
     D  PBOFF                 49     52B 0
      * Length of the before image of the record
     D  PBLEN                 53     56B 0
      * Offset to the after image of the record
     D  PAOFF                 65     68B 0
      * Length of the after image of the record
     D  PALEN                 69     72B 0
     D  PEntryData           117  10117A

     D P@LENDS         DS
     D  PLENG                  1      4B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Key fields

     D KBRCD           S              3A
     D KCNUM           S              6A
     D KCCY            S              3A
     D KACOD           S             10S 0
     D KACSQ           S              2S 0
     D KACNO           S             10S 0
     D KFCCU           S              6A
     D KFACT           S              3S 0
     D KFCNO           S              2S 0

      ** Work fields

     D W_@RUN          S              1
     D W_OffSet        S              5  0
     D W_AIMG          S           4000A
     D W_HHIT          S              1A
     D W_BAVBL         S             15S 0

      ** Paramater fields

     D W@RTCD          S              7A
     D W@SARD          S              6A
     D W@ERMS          S             50A

     D I@OPTN          S              7A
     D I@BRCD          S              3A
     D I@CNUM          S              6A
     D I@CNM10         S             10A
     D I@CCY           S              3A
     D I@ACOD          S             10S 0
     D I@ACSQ          S              2S 0
     D I@FCTY          S              3  0
     D I@FCNO          S              2  0
     D I@RCDT          S              1A
     D I@STAT          S              7A
     D I@VALD          S              5s 0
     D I@BAVBL         S             15S 0
     D I@FULLCHECK     S              1A

     D O@ZONE          S             10A
     D O@SHTC          S              4A
     D O@RDNB          S              5  0
     D O@DNWD          S              5  0
     D O@BCCY          S              3A
     D O@NJOB          S              1  0
                                                                                            BUG27288
     D I#RtnCode       S              7A                                                    BUG27288
     D I#Option        S              7A                                                    BUG27288
     D I#SubRtn        S             10A                                                    BUG27288
     D I#BRCA          S              3A                                                    BUG27288
     D I#CNUM          S              6A                                                    BUG27288
     D I#CCY           S              3A                                                    BUG27288
     D I#ACOD          S             10S 0                                                  BUG27288
     D I#ACSQ          S              2S 0                                                  BUG27288
     D I#FACT          S              3S 0                                                  BUG27288
     D I#FCNO          S              2S 0                                                  BUG27288
     D I#COMMIT        S              1A                                                    BUG27288
     D I#Delete        S              1A                                                    BUG27288
     D I#RecordImage   S          32000A                                                    BUG27288
     D I#GPCustDet     S              1A                                                    BUG27288
     D O#RecordImage   S                   LIKE(GPRABE)                                     BUG27288
     D commitDef       S              1A

      ** Switchable feature

     D CLE025          S              1A   INZ('N')

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read in Installation Data

     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT

      ** Set Date Format Indicator *IN98  on if date format is MMDDYY

     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF

     C                   EXSR      SrMain

     C                   EVAL      *INLR = *ON
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMain - Program Main routine                                 *
      *                                                               *
      * Called by: Main control processing                            *
      *                                                               *
      * Calls: SrACCNT, SrSDCUR, SrSDCUS, SrSDBRC, SrMEMOS,           *
      *        SrFCLTY and SrGLACN                                    *
      *                                                               *
      *****************************************************************

     C     SrMain        BEGSR

     C                   EVAL      W_OffSet = PAOFF + 1
     C                   EVAL      W_AIMG = %SUBST(P@IMGDS :W_OffSet :PALEN)

     C                   SELECT
     C                   WHEN      PFLNAME = 'ACCNTAB'
     C                   EXSR      SrACCNT
     C                   WHEN      PFLNAME = 'SDCURRPD'
     C                   EXSR      SrSDCUR
     C                   WHEN      PFLNAME = 'SDCUSTPD'
     C                   EXSR      SrSDCUS
     C                   WHEN      PFLNAME = 'SDBRCHPD'
     C                   EXSR      SrSDBRC
     C**********         WHEN      PFLNAME = 'MEMOS'                                        BUG27942
     C**********         EXSR      SrMEMOS                                                  BUG27942
     C                   WHEN      PFLNAME = 'FCLTYFM'
     C**********         IF        CLE025 = 'Y'                                             BUG27978
     C                   EXSR      SrFCLTY
     C**********         ENDIF                                                              BUG27978
     C                   WHEN      PFLNAME = 'GLACNTQD'
     C                   EXSR      SrGLACN
     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrACCNT - Process records triggered from ACCNTAB              *
      *                                                               *
      * Called by: SrMAIN                                             *
      *                                                               *
      * Calls: SrMVFLDS, SrFACILT, AOCUSTR1, AOBRCHR0 and AOCURRR0    *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SrACCNT       BEGSR

     C                   CLEAR                   Z_ACCNT
     C                   MOVEL     W_AIMG        Z_ACCNT

     C                   IF        W_ATYP = 'R'
     C**********         EVAL      KBRCD = W_BRCA                                           BUG27288
     C**********         EVAL      KCNUM = W_CNUM                                           BUG27288
     C**********         EVAL      KCCY  = W_CCY                                            BUG27288
     C**********         EVAL      KACOD = W_ACOD                                           BUG27288
     C**********         EVAL      KACSQ = W_ACSQ                                           BUG27288
     C**********         EVAL      KACNO = W_ACNO                                           BUG27288
      **********                                                                            BUG27288
     C*****RERABKey      CHAIN     RERABED0                                                 BUG27288
     C**********         IF        %FOUND(RERABEL0)                                         BUG27288
                                                                                            BUG27288
      ** Check if record exists in GPRABEPD                                                 BUG27288
                                                                                            BUG27288
     C                   EXSR      SrClrParm                                                BUG27288
     C                   EVAL      I#BRCA = W_BRCA                                          BUG27288
     C                   EVAL      I#CNUM = W_CNUM                                          BUG27288
     C                   EVAL      I#CCY  = W_CCY                                           BUG27288
     C                   EVAL      I#ACOD = W_ACOD                                          BUG27288
     C                   EVAL      I#ACSQ = W_ACSQ                                          BUG27288
     C                   EVAL      I#SubRtn = 'SrACCNT'                                     BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
                                                                                            BUG27288
     C                   IF        I#RtnCode = *BLANKS                                      BUG27288
     C                   EVAL      GPRABE = O#RecordImage                                   BUG27288
      *
      ** Update the record
      *
      ** Move ACCNTAB fields to output fields

     C                   EXSR      SrMVFLDS
     C                   EVAL      ABLDBL = W_LDBL                                         BUG28110A
     C                   EVAL      ABCLBL = W_CLBL                                         BUG28110A

     C                   IF        ABFCNO = 0
     C**********         EVAL      ABFAAMT = 0                                              BUG27978
     C                   EVAL      ABFAMT = 0                                               BUG27978
     C                   ELSE

     C                   IF        CLE025 = 'Y'                                             MD039463
     C                   EVAL      I@CNUM = W_FCCU
     C                   ELSE                                                               MD039463
     C                   EVAL      I@CNUM = W_CNUM                                          MD039463
     C                   ENDIF                                                              MD039463
     C                   EVAL      I@FCTY = W_FACT
     C                   EVAL      I@FCNO = W_FCNO
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
     C**********         UPDATE    RERABED0                                                 BUG27288
     C                   EXSR      SRUpdate                                                 BUG27288

     C                   ELSE
      *
      ** Add new record
      *
     C                   EVAL      ABZONE = O@ZONE
     C                   EVAL      ABBRCD = W_BRCA
     C                   EVAL      ABCNUM = W_CNUM

      ***Global*Customer***********************************************                     BUG27288

     C**********         EVAL      KCNUM = W_CNUM                                           BUG27288
     C**********         EVAL      KBRCD = W_BRCA                                           BUG27288

     C*****GCUSKey       CHAIN     GPCUSTXL1                                                BUG27288

     C**********         IF        %FOUND                                                   BUG27288
     C**********         EVAL      ABGCNM  = CUGCUS                                         BUG27288
     C**********         ELSE                                                               BUG27288
     C**********         EVAL      ABGCNM  = *BLANKS                                        BUG27288
     C**********         ENDIF                                                              BUG27288

      ** Customer

     C                   EVALR     I@CNM10 = W_CNUM
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       W@RTCD
     C                   PARM      '*KEY   '     I@OPTN
     C                   PARM                    I@CNM10
     C                   PARM      *BLANKS       I@STAT
     C     Z_SDCUS       PARM      *BLANKS       DSLDY

     C                   IF        W@RTCD <> *BLANKS
     C                   EVAL      DBKEY  = I@CNM10
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ABCNM1 = W_BBCNA1
     C                   EVAL      ABCNM2 = W_BBCNA2
     C                   EVAL      ABCNM3 = W_BBCNA3
     C                   EVAL      ABCNM4 = W_BBCNA4
     C                   EVAL      ABCRNM = W_BBCRNM                                        BUG27878
     C                   EVAL      ABACOC = W_BBACOC                                        BUG27878
     C                   ENDIF

      ** Branch
     C**********         CALL      'AOBRCHR0'                                               BUG27288
     C                   CALL      'AOBRCHR1'                                               BUG27288
     C                   PARM      *BLANKS       W@RTCD
     C                   PARM      '*KEY   '     I@OPTN
     C                   PARM      W_BRCA        I@BRCD
     C     Z_SDBRC       PARM      *BLANKS       DSSDY

     C                   IF        W@RTCD <> *BLANKS
     C                   EVAL      DBKEY  = I@BRCD
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ABBRNM = W1A8BRNM
     C                   ENDIF

     C                   EVAL      ABACNO = W_ACNO
     C                   EVAL      ABACOD = W_ACOD
     C                   EVAL      ABACSQ = W_ACSQ
     C                   EVAL      ABCCY  = W_CCY

      ** Currency description

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       W@RTCD
     C                   PARM      '*KEY   '     I@OPTN
     C                   PARM      W_CCY         I@CCY
     C     Z_SDCUR       PARM      *BLANKS       DSSDY

     C                   IF        W@RTCD <> *BLANKS
     C                   EVAL      DBKEY  = I@CCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      ABCCYN = W_A6CYNM
     C                   ENDIF

      ** Move ACCNTAB fields to output fields

     C                   EXSR      SrMVFLDS
     C                   EVAL      ABLDBL = W_LDBL
     C                   EVAL      ABCLBL = W_CLBL

     C                   IF        ABFCNO = 0
     C**********         EVAL      ABFAAMT = 0                                              BUG27978
     C                   EVAL      ABFAMT = 0                                               BUG27978
     C                   ELSE

     C                   IF        CLE025 = 'Y'                                             MD039463
     C                   EVAL      I@CNUM = W_FCCU
     C                   ELSE                                                               MD039463
     C                   EVAL      I@CNUM = W_CNUM                                          MD039463
     C                   ENDIF                                                              MD039463
     C                   EVAL      I@FCTY  = W_FACT
     C                   EVAL      I@FCNO  = W_FCNO
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

     C                   EVAL      ABDACC = W_DACC
     C                   EVAL      ABDACO = W_DACO
      *
      ** Set Today's Available Balance to zeroes
      *
     C                   EVAL      ABABAL = *ZERO
                                                                                            BUG27878
      ** Set available balances to zero                                                     BUG27878
                                                                                            BUG27878
     C                   EVAL      ABABA2 = *ZERO                                           BUG27878
     C                   EVAL      ABABA3 = *ZERO                                           BUG27878
     C                   EVAL      ABABA4 = *ZERO                                           BUG27878
     C                   EVAL      ABABA5 = *ZERO                                           BUG27878
     C                   EVAL      ABABA6 = *ZERO                                           BUG27878
     C                   EVAL      ABABA7 = *ZERO                                           BUG27878
     C                   EVAL      ABABA8 = *ZERO                                           BUG27878
     C                   EVAL      ABABA9 = *ZERO                                           BUG27878

      ** Set Global Customer Details Indicator                                              BUG27288
                                                                                            BUG27288
     C                   EVAL      I#GPCustDet = 'Y'                                        BUG27288
     C**********         WRITE     RERABED0                                                 BUG27288
     C                   EXSR      SRUpdate                                                 BUG27288
     C                   ENDIF

     C                   ENDIF


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDCUR   Process records triggered from SDCURRPD             *
      *                                                               *
      * Called by: SrMAIN                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************

     C     SrSDCUR       BEGSR

     C                   CLEAR                   Z_SDCUR
     C                   MOVEL     W_AIMG        Z_SDCUR

     C*****W_A6CYCD      SETLL     RERABED1                                                 BUG27288
     C*****W_A6CYCD      READE     RERABED1                                                 BUG27288
     C**********         DOW       NOT %EOF(RERABEL1)                                       BUG27288
                                                                                            BUG27288
      ** Process all affected records in GPRABEPD                                           BUG27288
                                                                                            BUG27288
     C                   EXSR      SrClrParm                                                BUG27288
     C                   EVAL      I#CCY = W_A6CYCD                                         BUG27288
     C                   EVAL      I#Option = '*FIRST '                                     BUG27288
     C                   EVAL      I#SubRtn = 'SrSDCUR'                                     BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   EVAL      I#Option = '*NEXT  '                                     BUG27288
                                                                                            BUG27288
     C                   DOW       I#RtnCode = *BLANKS                                      BUG27288
     C                   EVAL      GPRABE = O#RecordImage                                   BUG27288
                                                                                            BUG27288
     C                   IF        ABCCYN <> W_A6CYNM
     C                   EVAL      ABCCYN = W_A6CYNM
     C**********         UPDATE    RERABED1                                                 BUG27288
     C                   EXSR      SRUpdate                                                 BUG27288
     C                   ENDIF
     C*****W_A6CYCD      READE     RERABED1                                                 BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDCUS   Process records triggered from SDCUSTPD             *
      *                                                               *
      * Called by: SrMAIN                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************

     C     SrSDCUS       BEGSR

     C                   CLEAR                   Z_SDCUS
     C                   MOVEL     W_AIMG        Z_SDCUS

     C*****W_BBCUST      SETLL     RERABED3                                                 BUG27288
     C*****W_BBCUST      READE     RERABED3                                                 BUG27288
     C**********         DOW       NOT %EOF(RERABEL3)                                       BUG27288
                                                                                            BUG27288
      ** Process all affected records in GPRABEPD                                           BUG27288
                                                                                            BUG27288
     C                   EXSR      SrClrParm                                                BUG27288
     C                   EVAL      I#CNUM = W_BBCUST                                        BUG27288
     C                   EVAL      I#Option = '*FIRST '                                     BUG27288
     C                   EVAL      I#SubRtn = 'SrSDCUS'                                     BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   EVAL      I#Option = '*NEXT  '                                     BUG27288
                                                                                            BUG27288
     C                   DOW       I#RtnCode = *BLANKS                                      BUG27288
     C                   EVAL      GPRABE = O#RecordImage                                   BUG27288
                                                                                            BUG27288
     C                   IF        ABCNM1 <> W_BBCNA1
     C                             OR ABCNM2 <> W_BBCNA2
     C                             OR ABCNM3 <> W_BBCNA3
     C                             OR ABCNM4 <> W_BBCNA4
     C                             OR ABCRNM <> W_BBCRNM                                    BUG27878
     C                             OR ABACOC <> W_BBACOC                                    BUG27878
     C                   EVAL      ABCNM1 = W_BBCNA1
     C                   EVAL      ABCNM2 = W_BBCNA2
     C                   EVAL      ABCNM3 = W_BBCNA3
     C                   EVAL      ABCNM4 = W_BBCNA4
     C                   EVAL      ABCRNM = W_BBCRNM                                        BUG27878
     C                   EVAL      ABACOC = W_BBACOC                                        BUG27878
     C**********         UPDATE    RERABED3                                                 BUG27288
     C                   EXSR      SRUpdate                                                 BUG27288
     C                   ENDIF
     C*****W_BBCUST      READE     RERABED3                                                 BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDBRC   Process records triggered from SDBRCHPD             *
      *                                                               *
      * Called by: SrMAIN                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************

     C     SrSDBRC       BEGSR

     C                   CLEAR                   Z_SDBRC
     C                   MOVEL     W_AIMG        Z_SDBRC

     C*****W1A8BRCD      SETLL     RERABED0                                                 BUG27288
     C*****W1A8BRCD      READE     RERABED0                                                 BUG27288
     C**********         DOW       NOT %EOF(RERABEL0)                                       BUG27288
                                                                                            BUG27288
      ** Process all affected records in GPRABEPD                                           BUG27288
                                                                                            BUG27288
     C                   EXSR      SrClrParm                                                BUG27288
     C                   EVAL      I#BRCA = W1A8BRCD                                        BUG27288
     C                   EVAL      I#Option = '*FIRST '                                     BUG27288
     C                   EVAL      I#SubRtn = 'SrSDBRC'                                     BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   EVAL      I#Option = '*NEXT  '                                     BUG27288
                                                                                            BUG27288
     C                   DOW       I#RtnCode = *BLANKS                                      BUG27288
     C                   EVAL      GPRABE = O#RecordImage                                   BUG27288
                                                                                            BUG27288
     C                   IF        ABBRNM <> W1A8BRNM
     C                   EVAL      ABBRNM = W1A8BRNM
     C**********         UPDATE    RERABED0                                                 BUG27288
     C                   EXSR      SRUpdate                                                 BUG27288
     C                   ENDIF
     C*****W1A8BRCD      READE     RERABED0                                                 BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                     BUG27942
      **SrMEMOS***Process*records*triggered*from*MEMOS*****************                     BUG27942
      *****************************************************************                     BUG27942
      **Called*by:*SrMAIN**********************************************                     BUG27942
      *****************************************************************                     BUG27942
      **Calls:*NONE****************************************************                     BUG27942
      *****************************************************************                     BUG27942
      *****************************************************************
      *****************************************************************                     BUG27942
     C*****SrMEMOS       BEGSR                                                              BUG27942
      *****************************************************************                     BUG27942
     C**********         CLEAR                   Z_MEMOS                                    BUG27942
     C**********         MOVEL     W_AIMG        Z_MEMOS                                    BUG27942
      *****************************************************************                     BUG27942
     C**********         EVAL      KBRCD = W2BRCA                                  BUG27288 BUG27942
     C**********         EVAL      KCNUM = W2CNUM                                  BUG27288 BUG27942
     C**********         EVAL      KCCY  = W2CCY                                   BUG27288 BUG27942
     C**********         EVAL      KACOD = W2ACOD                                  BUG27288 BUG27942
     C**********         EVAL      KACSQ = W2ACSQ                                  BUG27288 BUG27942
     C**********         EVAL      KACNO = W2ACNO                                  BUG27288 BUG27942
      *****************************************************************            BUG27288 BUG27942
     C*****RERABKey      CHAIN     RERABEL0                                        BUG27288 BUG27942
     C**********         IF        %FOUND(RERABEL0)                                BUG27288 BUG27942
      *****************************************************************            BUG27288 BUG27942
      ***Check*if*record*exists*in*GPRABEPD****************************            BUG27288 BUG27942
      *****************************************************************            BUG27288 BUG27942
     C**********         EXSR      SrClrParm                                       BUG27288 BUG27942
     C**********         EVAL      I#BRCA = W2BRCA                                 BUG27288 BUG27942
     C**********         EVAL      I#CNUM = W2CNUM                                 BUG27288 BUG27942
     C**********         EVAL      I#CCY  = W2CCY                                  BUG27288 BUG27942
     C**********         EVAL      I#ACOD = W2ACOD                                 BUG27288 BUG27942
     C**********         EVAL      I#ACSQ = W2ACSQ                                 BUG27288 BUG27942
     C**********         EVAL      I#SubRtn = 'SrMEMOS'                            BUG27288 BUG27942
     C**********         EXSR      SrGPRABE                                        BUG27288 BUG27942
      *****************************************************************            BUG27288 BUG27942
     C**********         IF        I#RtnCode = *BLANKS                             BUG27288 BUG27942
     C**********         EVAL      GPRABE = O#RecordImage                          BUG27288 BUG27942
      *****************************************************************                     BUG27942
     C**********         EVAL      ABLDBL = W2LDBLN                                         BUG27942
     C**********         EVAL      ABCLBL = W2CLBLN                                         BUG27942
      *****************************************************************                     BUG27942
     C**********         UPDATE    RERABED0                                        BUG27288 BUG27942
     C**********         EXSR      SRUpdate                                        BUG27288 BUG27942
      *****************************************************************                     BUG27942
     C**********         ENDIF                                                              BUG27942
      *****************************************************************                     BUG27942
     C**********         ENDSR                                                              BUG27942
      *****************************************************************                     BUG27942
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFCLTY   Process records triggered from FCLTYFM              *
      *                                                               *
      * Called by: SrMAIN                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************

     C     SrFCLTY       BEGSR

     C                   CLEAR                   Z_FCLTM
     C                   MOVEL     W_AIMG        Z_FCLTM
                                                                                            BUG27978
      ** Get drawn amount details                                                           BUG27978
                                                                                            BUG27978
     C                   EVAL      I@CNUM = W3CNUM                                          BUG27978
     C                   EVAL      I@FCTY = W3FACT                                          BUG27978
     C                   EVAL      I@FCNO = W3FCNO                                          BUG27978
     C                   EXSR      SrFACILT                                                 BUG27978
                                                                                            BUG27978
      ** Restore facility details (A) from image                                            BUG27978
                                                                                            BUG27978
     C                   CLEAR                   Z_FCLTM                                    BUG27978
     C                   MOVEL     W_AIMG        Z_FCLTM                                    BUG27978
                                                                                            BUG27978
     C**********         EVAL      KFCCU = W3CNUM                                           BUG27288
     C**********         EVAL      KFACT = W3FACT                                           BUG27288
     C**********         EVAL      KFCNO = W3FCNO                                           BUG27288
      **********                                                                            BUG27288
     C*****RERA2Key      SETLL     RERABED2                                                 BUG27288
     C*****RERA2Key      READE     RERABED2                                                 BUG27288
     C**********         DOW       NOT %EOF(RERABEL2)                                       BUG27288
                                                                                            BUG27288
      ** Process all affected records in GPRABEPD                                           BUG27288
                                                                                            BUG27288
     C                   EXSR      SrClrParm                                                BUG27288
     C                   EVAL      I#CNUM = W3CNUM                                          BUG27288
     C                   EVAL      I#FACT = W3FACT                                          BUG27288
     C                   EVAL      I#FCNO = W3FCNO                                          BUG27288
     C                   EVAL      I#SubRtn = 'SrFCLTY'                                     BUG27288
     C                   EVAL      I#Option = '*FIRST '                                     BUG27583
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   EVAL      I#Option = '*NEXT  '                                     BUG27288
                                                                                            BUG27288
     C                   DOW       I#RtnCode = *BLANKS                                      BUG27288
     C                   EVAL      GPRABE = O#RecordImage                                   BUG27288
      *
     C**********         EVAL      ABFAAMT = W3FAMT                                         BUG27978
     C                   EVAL      ABFAMT  = W3FAMT                                         BUG27288
     C                   IF        CLE025 = 'Y'                                             BUG27978
     C                   EVAL      ABOAM1  = OAM1                                           BUG27978
     C                   EVAL      ABFAAMT = ABFAMT - ABOAM1                                BUG27978
     C                   ENDIF                                                              BUG27978
      *
     C**********         UPDATE    RERABED2                                                 BUG27288
     C                   EXSR      SRUpdate                                                 BUG27288

     C*****RERA2Key      READE     RERABED2                                                 BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGLACN - Process records triggered from GLACNTQD             *
      *                                                               *
      * Called by: SrMain                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************
     C     SrGLACN       BEGSR

     C                   CLEAR                   Z_GLACN
     C                   MOVEL     W_AIMG        Z_GLACN

     C**********         EVAL      KBRCD = F1BRCA                                           BUG27288
     C**********         EVAL      KCNUM = F1CNUM                                           BUG27288
     C**********         EVAL      KCCY  = F1CCY                                            BUG27288
     C**********         EVAL      KACOD = F1ACOD                                           BUG27288
     C**********         EVAL      KACSQ = F1ACSQ                                           BUG27288
      **********                                                                            BUG27288
     C*****RERABKey      CHAIN     RERABED0                                                 BUG27288
     C**********         IF        %FOUND(RERABEL0)                                         BUG27288
      *
     C**********         EVAL      ABABAL = F1AVA0                                BUG27229A BUG27288
     C**********         UPDATE    RERABED0                                                 BUG27288
                                                                                            BUG27288
      ** Check if record exists in GPRABEPD                                                 BUG27288
                                                                                            BUG27288
     C                   EXSR      SrClrParm                                                BUG27288
     C                   EVAL      I#BRCA = F1BRCA                                          BUG27288
     C                   EVAL      I#CNUM = F1CNUM                                          BUG27288
     C                   EVAL      I#CCY  = F1CCY                                           BUG27288
     C                   EVAL      I#ACOD = F1ACOD                                          BUG27288
     C                   EVAL      I#ACSQ = F1ACSQ                                          BUG27288
     C                   EVAL      I#SubRtn = 'SrGLACN'                                     BUG27288
     C                   EXSR      SrGPRABE                                                 BUG27288
                                                                                            BUG27288
     C                   IF        I#RtnCode = *BLANKS                                      BUG27288
      *                                                                                     BUG27288
     C                   EVAL      GPRABE = O#RecordImage                                   BUG27288
     C                   EVAL      ABABAL   = F1AVA1                                        BUG27288
     C                   EVAL      ABABA2   = F1AVA2                                        BUG27878
     C                   EVAL      ABABA3   = F1AVA3                                        BUG27878
     C                   EVAL      ABABA4   = F1AVA4                                        BUG27878
     C                   EVAL      ABABA5   = F1AVA5                                        BUG27878
     C                   EVAL      ABABA6   = F1AVA6                                        BUG27878
     C                   EVAL      ABABA7   = F1AVA7                                        BUG27878
     C                   EVAL      ABABA8   = F1AVA8                                        BUG27878
     C                   EVAL      ABABA9   = F1AVA9                                        BUG27878
     C                   EVAL      ABTOLR   = F1TOLR                                        BUG27878
     C                   EVAL      ABIABC   = F1IABC                                        BUG27878
     C                   EXSR      SRUpdate                                                 BUG27288
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFACILT - Call Access program object AOFCLTR0                *
      *                                                               *
      * Called by: SrACCNT, SrFCLTY                                   *
      *                                                               *
      * Calls: AOFCLTR0                                               *
      *                                                               *
      *****************************************************************

     C     SrFACILT      BEGSR

     C                   CALL      'AOFCLTR0'
     C                   PARM      *BLANKS       W@RTCD
     C                   PARM      '*KEY   '     I@OPTN
     C                   PARM                    I@CNUM
     C                   PARM                    I@FCTY
     C                   PARM                    I@FCNO
     C                   PARM      *BLANKS       I@RCDT
     C                   PARM      *BLANKS       I@STAT
     C     Z_FCLTN       PARM      *BLANKS       P@FMT
     C     Z_FCLTM       PARM      *BLANKS       Q@FMT

     C                   IF        W@RTCD <> *BLANKS
     C                   EVAL      DBKEY  = I@CNUM
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMVFLDS - Move ACCNTAB field to output file field            *
      *                                                               *
      * Called by: SrACCNT                                            *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************

     C     SrMVFLDS      BEGSR

     C                   EVAL      ABACDN = W_ANAM
     C                   TESTB     '2'           W_RETB                   99
     C   99              EVAL      ABBLCD = 'Y'
     C  N99              EVAL      ABBLCD = 'N'                                             BUG27288
     C                   TESTB     '3'           W_RETB                   99
     C   99              EVAL      ABBLCC = 'Y'
     C  N99              EVAL      ABBLCC = 'N'                                             BUG27288
     C                   TESTB     '0'           W_RETB                   99
     C   99              EVAL      ABRFRD = 'Y'
     C  N99              EVAL      ABRFRD = 'N'                                             BUG27288
     C                   TESTB     '1'           W_RETB                   99
     C   99              EVAL      ABRFRC = 'Y'
     C  N99              EVAL      ABRFRC = 'N'                                             BUG27288

     C                   EVAL      ABIBAN = W_IBAN
     C                   EVAL      ABODLN = W_ODLN
     C                   EVAL      ABODED = W_ODED
     C                   EVAL      ABLMVD = W_LMVD
     C                   EVAL      ABMINB = W_MINB
     C                   IF        CLE025 = 'Y'                                             MD039463
     C                   EVAL      ABFCCU = W_FCCU
     C                   ELSE                                                               MD039463
     C                   EVAL      ABFCCU = W_CNUM                                          MD039463
     C                   ENDIF                                                              MD039463
     C                   EVAL      ABFACT = W_FACT
     C                   EVAL      ABFCNO = W_FCNO
     C                   EVAL      ABHELD = W_HELD                                          BUG27288
     C                   EVAL      ABBCOA = W_BCOA                                          BUG27967

     C                   ENDSR

      *****************************************************************                     BUG27288
      /EJECT                                                                                BUG27288
      *****************************************************************                     BUG27288
      *                                                               *                     BUG27288
      * SrUpdate - Update global file by calling GP230000             *                     BUG27288
      *                                                               *                     BUG27288
      * Called by: SrACCNT                                            *                     BUG27288
      *                                                               *                     BUG27288
      * Calls: GP230000                                               *                     BUG27288
      *                                                               *                     BUG27288
      *****************************************************************                     BUG27288
                                                                                            BUG27288
     C     SrUpdate      BEGSR                                                              BUG27288
                                                                                            BUG27288
      ** Update/Write to record                                                             BUG27288
                                                                                            BUG27288
     C                   EVAL      I#RecordImage = GPRABE                                   BUG27288
                                                                                            BUG27288
     C                   CALL      'GP230000'                                               BUG27288
     C                   PARM      *BLANK        W@RTCD                                     BUG27288
     C                   PARM      *BLANK        W@ERMS                                     BUG27288
                                                                                            BUG27288
     C                   PARM                    I#COMMIT                                   BUG27288
     C                   PARM                    I#Delete                                   BUG27288
     C                   PARM                    I#GPCustDet                                BUG27288
     C                   PARM                    I#RecordImage                              BUG27288
                                                                                            BUG27288
      * Error                                                                               BUG27288
                                                                                            BUG27288
     C     W@RTCD        IFEQ      '*ERROR'                                                 BUG27288
     C                   EVAL      DBKEY  = I#RecordImage                                   BUG27288
     C                   EVAL      DBFILE = 'GPRABEPD'                                      BUG27288
     C                   EVAL      DBASE  = 007                                             BUG27288
     C                   EXSR      *PSSR                                                    BUG27288
     C                   ENDIF                                                              BUG27288
                                                                                            BUG27288
     C                   ENDSR                                                              BUG27288
                                                                                            BUG27288
      *****************************************************************                     BUG27288
      /EJECT                                                                                BUG27288
      *****************************************************************                     BUG27288
      *                                                               *                     BUG27288
      * SrGPRABE - Access Retail Acct Balance Extract file            *                     BUG27288
      *            (GPRABEPD)                                         *                     BUG27288
      *                                                               *                     BUG27288
      * Called by: SrACCNT                                            *                     BUG27288
      *                                                               *                     BUG27288
      * Calls: GPAORABER0                                             *                     BUG27288
      *                                                               *                     BUG27288
      *****************************************************************                     BUG27288
                                                                                            BUG27288
     C     SrGPRABE      BEGSR                                                              BUG27288
                                                                                            BUG27288
     C                   CALL      'GPAORABER0'                                             BUG27288
     C                   PARM      *BLANK        I#RtnCode                                  BUG27288
     C                   PARM                    I#Option                                   BUG27288
     C                   PARM                    I#SubRtn                                   BUG27288
     C                   PARM                    I#BRCA                                     BUG27288
     C                   PARM                    I#CNUM                                     BUG27288
     C                   PARM                    I#CCY                                      BUG27288
     C                   PARM                    I#ACOD                                     BUG27288
     C                   PARM                    I#ACSQ                                     BUG27288
     C                   PARM                    I#FACT                                     BUG27288
     C                   PARM                    I#FCNO                                     BUG27288
     C                   PARM      *BLANK        O#RecordImage                              BUG27288
                                                                                            BUG27288
     C                   IF        I#RtnCode = '*ERROR'                                     BUG27288
     C                   EVAL      DBMOD  = 'GPAORABER0'                                    BUG27288
     C                   EVAL      DBKEY  = I#SubRtn                                        BUG27288
     C                   EVAL      DBFILE = 'GPRABEPD'                                      BUG27288
     C                   EVAL      DBASE  = 999                                             BUG27288
     C                   EXSR      *PSSR                                                    BUG27288
     C                   ENDIF                                                              BUG27288
                                                                                            BUG27288
     C                   ENDSR                                                              BUG27288
                                                                                            BUG27288
      *****************************************************************                     BUG27288
      /EJECT                                                                                BUG27288
      *****************************************************************                     BUG27288
      *                                                               *                     BUG27288
      * SrClrParm- Clear parameters used by GPAORABER0                *                     BUG27288
      *                                                               *                     BUG27288
      * Called by: SrACCNT                                            *                     BUG27288
      *                                                               *                     BUG27288
      *****************************************************************                     BUG27288
                                                                                            BUG27288
     C     SrClrParm     BEGSR                                                              BUG27288
                                                                                            BUG27288
     C                   CLEAR                   GPRABE                                     BUG27288
     C                   EVAL      I#BRCA = *BLANKS                                         BUG27288
     C                   EVAL      I#CNUM = *BLANKS                                         BUG27288
     C                   EVAL      I#CCY  = *BLANKS                                         BUG27288
     C                   EVAL      I#ACOD = *ZERO                                           BUG27288
     C                   EVAL      I#ACSQ = *ZERO                                           BUG27288
     C                   EVAL      I#FACT = *ZERO                                           BUG27288
     C                   EVAL      I#FCNO = *ZERO                                           BUG27288
                                                                                            BUG27288
     C                   ENDSR                                                              BUG27288
                                                                                            BUG27288
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

     C     *ENTRY        PLIST
     C                   PARM                    P@IMGDS
     C                   PARM                    P@LENDS

     C     LEFCAKey      KLIST
     C                   KFLD                    KBRCD
     C                   KFLD                    KFCCU
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO

     C     RERA2Key      KLIST
     C                   KFLD                    KFCCU
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO

     C     RERABKey      KLIST
     C                   KFLD                    KBRCD
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ

     C     HELDKey       KLIST
     C                   KFLD                    KACNO
     C                   KFLD                    KACSQ

     C     GCUSKey       KLIST
     C                   KFLD                    KBRCD
     C                   KFLD                    KCNUM

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       W@RTCD
     C                   PARM      '*VERIFY'     I@OPTN
     C                   PARM      'CLE025'      W@SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        W@RTCD <> *BLANKS
     C                              AND W@RTCD <> '*NRF'                                    BUG27978
     C                   EVAL      DBKEY = 'CLE025'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 005
     C                   EXSR      *PSSR
     C**********         ELSE                                                               BUG27978
     C                   ENDIF                                                              BUG27978
                                                                                            BUG27978
     C                   IF        W@RTCD = *BLANKS                                         BUG27978
     C                   EVAL      CLE025 = 'Y'
     C                   ENDIF

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    W@RTCD
     C                   PARM      '*FIRST  '    I@OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        W@RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 006
     C                   EXSR      *PSSR
     C                   ENDIF

      ** /COPY of GOGETZONE cannot work with RPGLE bound PGM

     C                   CALL      'GOGETZONE'

     C                   PARM      *BLANK        W@RTCD
     C                   PARM      *BLANK        W@ERMS
      * INPUTS
     C                   PARM      'N'           I@FULLCHECK
      * OUTPUTS
     C                   PARM                    O@ZONE
     C                   PARM                    O@SHTC
     C                   PARM                    O@RDNB
     C                   PARM                    O@DNWD
     C                   PARM                    O@BCCY
     C                   PARM                    O@NJOB

      * Error detected  (*PSSR will end the program)

     C     W@RTCD        IFEQ      '*ERROR'
     C                   EVAL      W@ERMS = 'ERROR IN GOGETZONE'
     C                   EXSR      *PSSR
     C                   END

      ** Check if commitment definition is running                                          BUG27288
                                                                                            BUG27288
     C                   CALL      'GPCOPN4COM'                                             BUG27288
     C                   PARM      *BLANK        commitDef                                  BUG27288
                                                                                            BUG27288
     C                   IF        commitDef = '1'                                          BUG27288
     C                   EVAL      I#COMMIT = 'Y'                                           BUG27288
     C                   ELSE                                                               BUG27288
     C                   EVAL      I#COMMIT = 'N'                                           BUG27288
     C                   ENDIF                                                              BUG27288
                                                                                            BUG27288
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

     C     *PSSR         BEGSR

     C                   IF        W_@RUN = *BLANK
     C                   EVAL      W_@RUN = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
