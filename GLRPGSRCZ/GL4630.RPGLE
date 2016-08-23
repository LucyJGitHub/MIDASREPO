     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Confirmation of Balances')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL4630 - Certificate of Balances                             *
      *                                                               *
      *  Function:  This module will generate Confirmation of Balances*
      *             report to be given to the customer to confirm the *
      *             balances in his account(s).                       *
      *                                                               *
      *  Component of: GL4630 - Confirmation of Balances              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR787886           Date 15Jun11               *
      *  Prev Amend No. AR790145A          Date 04Jul11               *
      *                 AR790145           Date 22Jun11               *
      *                 AR798241           Date 13Jul11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245255             Date 08Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3021            Date 15Jun04               *
      *                 BUG3074            Date 08Jun04               *
      *                 BUG3021            Date 02Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG1987            Date 20Apr04               *
      *                 CGL024  *CREATE    Date 01Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR787886 - Account description is taken from ANAM (defined   *
      *             as 20A) of ACCNTAB, but GL4630P1 uses RANAM which *
      *             has a length of 19A. Recompile over changes in    *
      *             printer file GL4630P1. (Child: AR787887)          *
      *  AR790145A - Client is requesting for the 'Madame' in the of  *
      *              salutation to be changed to 'Madam' as per       *
      *              business practice. Need to change this from      *
      *              'Dear Sir/Madame,' to 'Dear Sir/Madam,'.         *
      *              (Child: AR790146A)                               *
      *  AR790145 - The salutation line 'Dear Sirs,' is printed in    *
      *             the report. Need to change this from 'Dear Sirs,' *
      *             to 'Dear Sir/Madame,'. (Child: AR790146)          *
      *  AR798241 - Customer Name and Address is truncated in Balance *
      *             Confirmation.Recompile due to changes in GL4630P1.*
      *             (Child: AR798242)                                 *
      *  245255 - SetLL on DRCR = nil so that all postings are added/ *
      *           subtracted from a certain date and because of       *
      *           2 o'clock feature, need to use LDBL instead of CLBL.*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3021 - (Reopen) Fix not incorporated correctly causing    *
      *            wrong customer and balance date to be printed.     *
      *  BUG3074 - Webfacing Changes. Separated record format for the *
      *            details and the function keys.                     *
      *  BUG3021 - Incorrect dates and amount formatting in           *
      *            certificate and confirmation of balances           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG1987- Rename message IDs; add F5 processing; include CNUM *
      *           in key to APOSTL4.                                  *
      *  CGL024 - Certificates and Confirmations of Balances.         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
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
     FGLACNTL2  IF   E           K DISK
     FAPOSTL4   IF   E           K DISK
     F                                     PREFIX(AP_)
 
     FGL4630DF  CF   E             WORKSTN
     FGL4630P1  O    E             PRINTER INFDS(SPOOL1)
     FGL4630AU  O    E             PRINTER INFDS(SPOOLU) USROPN
     FCGCONBPD  O    E             DISK    USROPN
 
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
     D SPOOL1          DS
      * P1 printer file information data structure
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  SFPLE                152    153B 0
     D  SFOVR                188    189B 0
     D  SFCUR                367    368B 0
 
     D SPOOLU          DS
      * AU printer file information data structure
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  SFPLEU               152    153B 0
     D  SFOVRU               188    189B 0
     D  SFCURU               367    368B 0
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
 
     D MsgFile         C                   CONST('GBGLUSRMSG')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D ConfTxt         S             69    DIM(38)  CTDATA PERRCD(1)
      * Confirmation text
 
     D AuditLine       S             50    DIM(38)
      * Confirmation text
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data Structure for Bank Details Access Program
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * Data Structure for Customer Details Access Program
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for Currency Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Module File Details
 
     D##UDCR         E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference
      *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Short Data Structure for Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long Data Structure for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D FldOk           S              1
     D MsgF            S             10
     D MsgId           S             10
     D BalanceDate     S              5  0
     D OpenBalance     S             15  0
     D TotalPosting    S             15  0
 
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT22          S             22
     D ZOUT25          S             25
 
     D MaxRptLine      S              3  0
     D CurRptLine      S              3  0
     D FirstPage       S              1A
     D AcctRead        S              3  0
     D RecPrinted      S              2  0
     D I               S              2  0
     D StrPos          S              2  0
     D BalDatC         S              7A
     D BaseDecPlace    S              1  0
 
     D KBRCA           S                   LIKE(BRCA)
     D KCNUM           S                   LIKE(CNUM)
     D KCYCD           S                   LIKE(CCY)
     D KACOD           S                   LIKE(ACOD)
     D KACSQ           S                   LIKE(ACSQ)
     D KPSTD           S                   LIKE(AP_PSTD)
     D KDRCR           S                   LIKE(AP_DRCR)
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
 
      ** User Input
     C                   Exsr      SrUsrInput
 
      ** Generate report only if inputs are valid
     C                   If        FldOk = 'Y'
     C                   Move      'N'           ViaCM             1
 
      ** If Correspondence Manager is ON, output to driver file
      ** if certificate is to be generated via CM.
     C                   If        BGN1ST = 'Y'
     C                   MoveL     SCNUM         ##CUST
     C                   Movel     'GL'          DRMODI
     C                   MoveL     'GL_BALSTMT'  DRPTYP
     C                   MoveL     'CONF  '      DRPSTP
     C                   MoveL     'N'           DRATRM
     C                   Call      'CG9010'
     C                   Parm      *Blank        ##RTCD            7
     C                   Parm      '*GEN'        ##MODE           10
     C                   Parm      '*YES'        ##CMT             3
     C                   Parm                    ##CUST            6
     C                   Parm                    ##UDCR
     C                   Parm                    ##ITMA            8
      *
      **  Blank return code implies generate correspondence.
      **  CGD1270 => no error, but suppress output for this transaction.
      *
     C                   If        ##RTCD = *BLANK
     C                   Move      'Y'           ViaCM
     C                   Else
     C                   If        ##RTCD <> 'CGD1270'
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'CG9010'
     C                   Eval      DBKEY  =  ##RTCD
     C                   Eval      DBASE  =  5
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   If        ViaCM = 'Y'
     C                   Exsr      SrWriteCONB
     C                   Else
     C                   Exsr      SrGenReport
     C                   Endif
     C                   Endif
 
      ** Terminate program
     C                   Eval      *INLR = *On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUsrInput - Ask the user to input the customer number & etc. *
      *                                                               *
      *****************************************************************
     C     SrUsrInput    Begsr
 
      ** Loop until F3 is taken or input fiels are valid
     C                   Eval      FldOk = 'N'
     C                   DoW       *INKC = *Off AND
     C                             FldOk = 'N'
 
      ** display pgm messages
     C                   Write     #MSGCTL
 
      ** display footer                                                                      BUG3074
     C                   Write     GL4630F1                                                  BUG3074
      ** display main screen
     C                   Exfmt     GL4630F0
 
      ** clear pgm messages
     C                   Call      'ZA0250'
 
      ** Check user action
     C                   Select
     C                   When      *INKC = *On
     C                   Eval      ReturnCode = 'F3'
      *                                                                                      BUG1987
      ** F5 is pressed                                                                       BUG1987
      *                                                                                      BUG1987
     C                   When      *INKE = *On                                               BUG1987
     C                   Exsr      SrRefresh                                                 BUG1987
                                                                                             BUG1987
     C                   Other
     C                   Exsr      SrValidInput
     C                   EndSl
 
     C                   EndDo
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidInput - Validate user input                            *
      *                                                               *
      *****************************************************************
     C     SrValidInput  Begsr
 
      ** Input fields are ok
     C                   Eval      FldOk = 'Y'
 
      ** Initialise error indicators
     C                   MoveA     '000000000'   *IN(20)
 
      ** Customer Number is mandatory and must be
      ** a valid a valid record in Customer file
     C                   If        SCNUM = *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN20 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0004   '  MsgId                                       BUG1987
     C                   Parm      'CGL0017   '  MsgId                                       BUG1987
     C                   Else
     C                   Eval      @CNUM = SCNUM
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blank        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    @CNUM            10
     C                   Parm      *Blank        @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
     C                   If        @RTCD <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN20 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'GLM0013   '  MsgId
     C                   Else
     C                   Eval      SCNUM = BBCUST
     C                   Endif
     C                   Endif
 
      ** Customer must have at least one valid account
     C                   If        SCNUM <> *Blank AND
     C                             *IN20 =  *Off
     C                   Move      SCNUM         KCNUM
     C                   Move      *Blank        KBRCA
     C                   Move      *Zero         KACOD
     C                   Move      *Blank        KCYCD
     C                   Move      *Zero         KACSQ
     C     KACNTL2       SetLL     GLACNTL2
     C                   Read      GLACNTL2
     C                   If        CNUM <> KCNUM
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN20 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'GLM0013   '  MsgId
     C                   Endif
     C                   Endif
 
      ** Balance Date must be a valid date < system rundate
     C                   Eval      BalanceDate = *Zero
     C                   If        SBALD = *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN21 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0008   '  MsgId
     C                   Else
     C                   CallB     'ZDATE1'
     C                   Parm      SBALD         DateOut           6
     C                   Parm                    DateIn            5 0
     C                   Parm      AGDFF         DateFmt           1
     C                   Parm      *Blank        ErrorInd          1
     C                   If        ErrorInd <> 'N'
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN21 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0009   '  MsgId
     C                   Else
     C                   Eval      BalanceDate = DateIn
     C                   If        DateIn >= AGRDNB
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN21 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0010   '  MsgId
     C                   Endif
     C                   Endif
     C                   Endif
 
      ** Confirmation to be Sent To (us) must be 'N' OR 'Y'
     C                   If        SS2US <> *Blank AND
     C                             SS2US <> 'N'    AND
     C                             SS2US <> 'Y'
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN22 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0014   '  MsgId
     C                   Endif
 
      ** Confirmation to be Sent To (Auditor) must be 'N' OR 'Y'
     C                   If        SS2AU <> *Blank AND
     C                             SS2AU <> 'N'    AND
     C                             SS2AU <> 'Y'
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN23 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0014   '  MsgId
     C                   Endif
 
      ** To US or Our Auditor must be 'Y'
     C                   If        *IN22 = *Off AND
     C                             *IN23 = *Off
     C                   If        SS2US <> 'Y' AND
     C                             SS2AU <> 'Y'
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN22 = *On
     C                   Eval      *IN23 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0015   '  MsgId
     C                   Endif
     C                   If        SS2US = 'Y' AND
     C                             SS2AU = 'Y'
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN22 = *On
     C                   Eval      *IN23 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0016   '  MsgId
     C                   Endif
     C                   Endif
 
      ** Auditor's Line allowed only if 'Our Auditor' is 'Y'
     C                   If        SS2AU <> 'Y'
     C                   If        SBAU1 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN24 = *On
     C                   Endif
     C                   If        SBAU2 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN25 = *On
     C                   Endif
     C                   If        SBAU3 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN26 = *On
     C                   Endif
     C                   If        SBAU4 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN27 = *On
     C                   Endif
     C                   If        SFXNO <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN28 = *On
     C                   Endif
     C                   If        *IN24 = *On OR
     C                             *IN25 = *On OR
     C                             *IN26 = *On OR
     C                             *IN27 = *On OR
     C                             *IN28 = *On
     C                   Eval      *IN23 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0011   '  MsgId                                       BUG1987
     C                   Parm      'CGL0019   '  MsgId                                       BUG1987
     C                   Endif
     C                   Endif
 
      ** Auditor's Line 2 allowed only if Auditor's Line 1 is entered
     C                   If        SBAU1 =  *Blank AND
     C                             SBAU2 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN24 = *On
     C                   Eval      *IN25 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C**********         Parm      'CGL0014   '  MsgId                                       BUG1987
     C                   Parm      'CGL0011   '  MsgId                                       BUG1987
     C                   Endif
 
      ** Auditor's Line 3 allowed only if Auditor's Line 2 is entered
     C                   If        SBAU2 =  *Blank AND
     C                             SBAU3 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN25 = *On
     C                   Eval      *IN26 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0012   '  MsgId
     C                   Endif
 
      ** Auditor's Line 4 allowed only if Auditor's Line 3 is entered
     C                   If        SBAU3 =  *Blank AND
     C                             SBAU4 <> *Blank
     C                   Eval      FldOk = 'N'
     C                   Eval      *IN26 = *On
     C                   Eval      *IN27 = *On
     C                   Call      'ZA0340'
     C                   Parm      MsgFile       MsgF
     C                   Parm      'CGL0013   '  MsgId
     C                   Endif
 
     C                   MoveA     *Blank        AuditLine(1)
     C                   If        FldOk = 'Y' AND
     C                             SS2AU = 'Y'
     C                   Eval      AuditLine(33) = SBAU1
     C                   Eval      AuditLine(34) = SBAU2
     C                   Eval      AuditLine(35) = SBAU3
     C                   Eval      AuditLine(36) = SBAU4
     C                   Eval      AuditLine(37) = SFXNO
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWriteCONB - Output to trigger file                          *
      *                                                               *
      *****************************************************************
     C     SrWriteCONB   Begsr
 
     C                   If        NOT %OPEN(CGCONBPD)
     C                   Open      CGCONBPD
     C                   Endif
 
     C************       Move      SCNUM         CGCUST                                      BUG3021
     C                   Move      SCNUM         CGCUST                                      BUG3021
     C                   Z-Add     BalanceDate   CGBALD                                      BUG3021
     C************       Move      SBALD         CGBALD                                      BUG3021
     C                   Move      SS2US         CGSTUS
     C                   Move      SS2AU         CGSTAU
     C                   Move      SBAU1         CGBAU1
     C                   Move      SBAU2         CGBAU2
     C                   Move      SBAU3         CGBAU3
     C                   Move      SBAU4         CGBAU4
     C                   Move      SFXNO         CGAFAX
     C                   Write     CGCONBD0
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGenReport - Generate Certificate of Balances report.        *
      *                                                               *
      *****************************************************************
     C     SrGenReport   Begsr
 
      ** RCF processing for GL4630P1
     C                   Exsr      SrEnrolP1
 
     C                   Move      SCNUM         KCNUM
     C                   Move      *Blank        KBRCA
     C                   Move      *Blank        KCYCD
     C                   Z-Add     *Zero         KACOD
     C                   Z-Add     *Zero         KACSQ
     C                   Z-Add     *Zero         AcctRead
 
      ** Read the first account of this customer
     C     KACNTL2       SetLL     GLACNTL2
     C                   Read      GLACNTL2
 
      ** Output report header
     C                   If        NOT %EOF(GLACNTL2)
     C                   Exsr      SrOutHead
     C                   Endif
 
      ** Process all accounts of the customer requested
     C                   DoW       NOT %EOF(GLACNTL2) AND
     C                             CNUM = KCNUM
      ** Number of accounts read
     C                   Add       1             AcctRead
 
      ** Opening Balance = Today's Cleared Balance
     C                   Eval      OpenBalance = CLBL
     C                   Eval      OpenBalance = LDBL                                         245255
 
      ** Total all postings after the Balance Date
     C                   Eval      TotalPosting = *Zero
     C                   Exsr      SrTotalPost
      ** Get CCY details
     C                   Eval      @CYCD = CCY
     C                   Exsr      SrCcyDtls
 
      ** Setup printer file fields
     C                   Eval      RNUM  = %CHAR(AcctRead) + '.'
     C**********         Eval      RACOD = %CHAR(ACOD)                                       BUG1987
     C                   Move      ACOD          RACOD                                       BUG1987
     C                   Eval      RCYCD = CCY
     C                   Eval      RANAM = ANAM
     C                   EvalR     RSEQN = %CHAR(ACSQ)
     C                   Eval      StrPos = %SCAN(' ':RSEQN)
     C                   If        StrPos <> 0
     C                   Eval      RSEQN = %REPLACE('0':RSEQN:StrPos:1)
     C                   Endif
      ** Format Amount
     C                   Eval      ZFLD15 = OpenBalance - TotalPosting
     C                   CallB     'ZFRPED'
     C                   Parm                    ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm      'A'           ZECODE
     C                   Parm      *Blank        ZOUT22
     C                   Parm      *Blank        ZOUT25
     C                   Move      ZOUT22        RBALA
     C                   Move      ZOUT22        RBALB
 
      ** Convert Balance to Base Ccy
     C                   If        CCY <> BJCYCD
     C                   CallB     'ZCONVZ1'
     C                   Parm      ZFLD15        InputAmnt        15 0
     C                   Parm      A6SPRT        ExchRate         13 8
     C                   Parm      A6MDIN        MultDivInd        1
     C                   Parm      CCY           FrCurrency        3
     C                   Parm      BJCYCD        ToCurrency        3
     C                   Parm      A6NBDP        FrDecPlace        1 0
     C                   Parm      BaseDecPlace  ToDecPlace        1 0
     C                   Parm                    OutputAmt        15 0
 
     C                   Move      *Blank        RBALB
     C                   CallB     'ZFRPED'
     C                   Parm      OutputAmt     ZFLD15
     C                   Parm      BaseDecPlace  ZDECS
     C                   Parm      'A'           ZECODE
     C                   Parm      *Blank        ZOUT22
     C                   Parm      *Blank        ZOUT25
     C                   Move      ZOUT22        RBALB
     C                   Endif
 
      ** Check for overflow line, output heading if required
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C                   If        ((MaxRptLine-CurRptLine) < 4)
     C                   Write     HEADP1
     C                   Write     SUBH2
     C                   Endif
 
      ** Output detail line
     C                   Write     DETAIL
 
     C                   Read      GLACNTL2
     C                   EndDo
 
      ** Check for overflow line, output heading if required
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C                   If        ((MaxRptLine-CurRptLine) < 2)
     C                   Write     HEADP1
     C                   Write     SUBH2
     C                   Endif
 
      ** Output '-------------'
     C                   Eval      RTEXT = ConfTxt(38)
     C                   Write     SUBH1
 
      ** Output report trailer
     C                   Exsr      SrOutTrail
 
     C                   Endsr
      *****************************************************************
      *                                                               *
      * SrOutHead - Output report heading                             *
      *                                                               *
      *****************************************************************
     C     SrOutHead     Begsr
 
      ** Output Customer Name and Address
     C                   Eval      RCNA1 = BBCNA1
     C                   Eval      RCNA2 = BBCNA2
     C                   Eval      RCNA3 = BBCNA3
     C                   Eval      RCNA4 = BBCNA4
     C                   Eval      RCNUM = SCNUM
     C                   Eval      *IN50 = *On
     C                   Write     HEADP1
     C                   Eval      *IN50 = *Off
 
      ** Format Balance Date as DDMMMYY
     C                   Eval      BalDate = *Blank
     C                   If        BalanceDate <> *Zero
     C                   CallB     'ZDATE2'
     C                   Parm                    BalanceDate
     C                   Parm      AGDFF         DateFmt
     C                   Parm      *Blank        ZDATE             6
     C                   Parm      *Blank        ZADATE            7
     C                   MoveL     ZADATE        BalDate           7
     C                   Endif
 
      ** Output 'We wish to ...'
     C                   Eval      RTEXT = *Blanks
     C                   Eval      RTEXT = ConfTxt(1)
     C                   Write     SUBH1
 
      ** Output 'following accounts...'
     C                   Eval      RTEXT = *Blanks
     C                   Eval      RTEXT = ConfTxt(2)
     C                   Write     SUBH1
 
      ** Output 'following accounts...'
     C                   Eval      RTEXT = *Blanks
     C                   Eval      RTEXT = ConfTxt(3)
     C                   Eval      RTEXT = %REPLACE(BalDate:RTEXT: +
     C                                     %SCAN('ddmmmyy':RTEXT)) + ':'
     C                   Write     SUBH1
 
      ** Output column heading
     C                   Write     SUBH2
 
     C                   Endsr
      *****************************************************************
      *                                                               *
      * SrOutTrail   - Output report trailer                          *
      *                                                               *
      *****************************************************************
     C     SrOutTrail    Begsr
 
      ** Output 'Please sign....'  up to 'Manager'
     C                   For       I = 4 to 15
 
      ** Check for overflow line, output heading if required
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C                   If        ((MaxRptLine-CurRptLine) < 2)
     C                   Write     HEADP1
     C                   Write     SUBH2
     C                   Endif
     C                   Eval      RTEXT = ConfTxt(I)
     C                   Write     SUBH1
 
     C                   EndFor
 
      ** Output 'We confirm.....'
      **   SKIP to next page if remaining printer lines is NOT sufficient
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C                   If        ((MaxRptLine-CurRptLine) < 17)
     C                   Eval      *IN51 = *On
     C                   Write     HEADP1
     C                   Endif
 
     C                   For       I = 16 to 25
     C                   Eval      RTEXT = ConfTxt(I)
     C                   Eval      StrPos = %SCAN('ddmmmyy':RTEXT)
     C                   If        StrPos <> 0
     C                   Eval      RTEXT = %REPLACE(BalDate:RTEXT: +
     C                                     StrPos:7)
     C                   Endif
     C                   Write     SUBH1
     C                   EndFor
 
     C                   If        SS2US = 'Y'
     C                   For       I = 26 to 31
     C                   Eval      RTEXT = ConfTxt(I)
     C                   Write     SUBH1
     C                   EndFor
     C                   Else
     C                   For       I = 32 to 38
     C                   Eval      RTEXT = %TRIM(ConfTxt(I)) + ' ' +
     C                                     %TRIM(AuditLine(I))
     C
     C                   Write     SUBH1
     C                   EndFor
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTotalPost - Total all postings after the Balance Date       *
      *                                                               *
      *****************************************************************
     C     SrTotalPost   Begsr
 
     C                   Eval      KBRCA = BRCA
     C                   Eval      KCYCD = CCY
     C                   Eval      KACOD = ACOD
     C                   Eval      KACSQ = ACSQ
     C                   Eval      KPSTD = BalanceDate + 1
     C                   Eval      KDRCR = *Zero
     C*****KAPOST        SetGT     APOSTL4                                                    245255
     C     KAPOST        SetLL     APOSTL4                                                    245255
     C                   Read      APOSTL4
     C                   DoW       NOT %EOF(APOSTL4) AND
     C                             AP_BRCA = KBRCA   AND
     C                             AP_CNUM = KCNUM   AND                                     BUG1987
     C                             AP_CCY  = KCYCD   AND
     C                             AP_ACOD = KACOD   AND
     C                             AP_ACSQ = KACSQ
 
      ** Accumulate Posting Amount
     C                   If        AP_DRCR = 1
     C                   Eval      TotalPosting = TotalPosting - AP_PSTA
     C                   Else
     C                   Eval      TotalPosting = TotalPosting + AP_PSTA
     C                   Endif
 
     C                   Read      APOSTL4
     C                   EndDo
 
     C                   Endsr
      *****************************************************************
      *                                                               *
      * SrEnrolP1 -  Enroll report file                               *
      *                                                               *
      *****************************************************************
     C     SrEnrolP1     BegSr
 
     C                   Z-Add     SFNUM         ZSNUM
     C                   Call      'ZSFILE'
     C                   Parm                    ReptSeq
     C                   Parm      *BLANKS       Entity            3
     C                   Parm                    SFILE
     C                   Parm                    ZSNUM             6 0
     C                   Parm                    ZSERR             1
     C                   If        ZSERR = 'Y'
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  'GL4630P1'
     C                   Eval      DBPGM  =  'GL4630'
     C                   Eval      DBASE  =  1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCcyDtls - Access Currency Details                           *
      *                                                               *
      *****************************************************************
     C     SrCcyDtls     BegSr
 
     C                   Call      'AOCURRR0'
     C                   Parm      *Blank        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    @CYCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
     C                   If        @RTCD <> *Blank
     C     *LOCK         In        LDA
     C                   Eval      DBFILE =  'SDCURRPD'
     C                   Eval      DBKEY  =  @CYCD
     C                   Eval      DBPGM  =  'GL4630'
     C                   Eval      DBASE  =  2
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   EndSr
      *****************************************************************
      /EJECT                                                                                 BUG1987
      *****************************************************************                      BUG1987
      *                                                               *                      BUG1987
      * SrRefresh - Refresh Screen                                    *                      BUG1987
      *                                                               *                      BUG1987
      *****************************************************************                      BUG1987
     C     SrRefresh     BegSr                                                               BUG1987
                                                                                             BUG1987
      ** Initialise error indicators                                                         BUG1987
     C                   MoveA     '000000000'   *IN(20)                                     BUG1987
                                                                                             BUG1987
      ** Blank out screen fields                                                             BUG1987
     C                   Move      *BLANKS       SCNUM                                       BUG1987
     C                   Move      *BLANKS       SBALD                                       BUG1987
     C                   Move      *BLANKS       SS2US                                       BUG1987
     C                   Move      *BLANKS       SS2AU                                       BUG1987
     C                   Move      *BLANKS       SBAU1                                       BUG1987
     C                   Move      *BLANKS       SBAU2                                       BUG1987
     C                   Move      *BLANKS       SBAU3                                       BUG1987
     C                   Move      *BLANKS       SBAU4                                       BUG1987
     C                   Move      *BLANKS       SFXNO                                       BUG1987
                                                                                             BUG1987
     C                   EndSr                                                               BUG1987
      *****************************************************************                      BUG1987
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
 
     C     *INZSR        Begsr
 
     C     *Entry        PList
     C                   Parm                    ReturnCode        7
     C                   Parm                    ReptSeq           5
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Report date
     C                   Eval      RMRDT = AGMRDT
 
      ** Local data area
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       @RTCD             7
     C                   Parm      '*FIRST  '    @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNE      *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  3
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Retrieve Base Ccy details
     C                   Eval      @CYCD = BJCYCD
     C                   Exsr      SrCcyDtls
     C                   Eval      BaseDecPlace = A6NBDP
 
      ** Access MIDAS Modules details via access program
     C                   Call      'AOMMODR0'
     C                   Parm      *BLANK        @Rtcd
     C                   Parm      '*FIRST '     @Optn
     C     SDMMOD        Parm      SDMMOD        DSFDY
 
     C     @RTCD         IfNE      *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'SDMMODPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBASE  =  4
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Define key fields to access GLACNTL2
     C     KACNTL2       KList
     C                   KFld                    KCNUM
     C                   KFld                    KBRCA
     C                   KFld                    KACOD
     C                   KFld                    KCYCD
     C                   KFld                    KACSQ
      ** Define key fields to access APOSTL4
     C     KAPOST        KList
     C                   KFld                    KBRCA
     C                   KFld                    KCNUM
     C                   KFld                    KCYCD
     C                   KFld                    KACOD
     C                   KFld                    KACSQ
     C                   KFld                    KPSTD
     C                   KFld                    KDRCR
 
     C                   MoveL     PSProcPgm     ##PGM            10
     C                   MoveL     PSUser        SUSER
     C                   MoveL     AGMRDT        SRUNA
     C                   MoveL     PSJobName     SWSID
 
     C                   Endsr
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
      ** Generate Audit report
     C                   If        NOT %OPEN(GL4630AU)
     C                   OPEN      GL4630AU
     C                   Z-Add     SFNUMU        ZSNUMU
     C                   Call      'ZSFILE'
     C                   Parm                    ReptSeq
     C                   Parm      *BLANKS       Entity            3
     C                   Parm                    SFILEU
     C                   Parm                    ZSNUMU            6 0
     C                   Parm                    ZSERRU            1
     C                   If        ZSERR = 'Y'
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  'GL4630AU'
     C                   Eval      DBPGM  =  'GL4630'
     C                   Eval      DBASE  =  6
     C                   Out       LDA
     C                   Endif
     C                   Endif
 
     C                   Write     HEADAU
     C                   Write     DBERROR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   ENDIF
 
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      ** Change the header from 'Dear Sirs,' to 'Dear Sir/Madame,'                          AR790145
      ** Change the header from 'Dear Sir/Madame,' to Dear Sir/Madam,'                     AR790145A
** TEXT array
       We wish to obtain from you a confirmation of balances in your
following accounts / selected outstanding transactions as under, as
on ddmmmyy:
Please sign on the space provided below and return it to the bank or
to the auditors as indicated here-in-below both by fax and mail.
Please return the attached copies and indicate in full details of the
differences, if any.
 
We wish to add here that this confirmation is not a request for a
settlement. Thank you very much for your cooperation.
 
                                                    Yours faithfully,
 
 
                                                             Manager.
---------------------------------------------------------------------
Dear Sir/Madam,
 
We confirm that, as at the close of business on ddmmmyy the records
of our selected transactions/outstanding balances in the above
indicated accounts with Bank of India, Singapore Branch are correct.
 
Authorised signature and Co. stamp.                   Date.
---------------------------------------------------------------------
Please Fax/Mail to:
Bank
Deposits: 62254407
TradeFin: 62252976
Loans   : 62271275
Forex   : 62256227
---------------------------------------------------------------------
Auditors
Line 1:
Line 2:
Line 3:
Line 4:
Fax   :
---------------------------------------------------------------------
