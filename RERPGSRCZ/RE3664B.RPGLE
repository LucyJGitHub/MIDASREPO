     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE AWV Extract Program')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  RE3664B - Retail Interest AWV Extract Program                *
      *                                                               *
      *  Function:  This program that will be created to generate the *
      *             AWV extracts for the Retail Interest              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Component of: RE3664B                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. MD021155           Date 09Jul13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24437           Date 26Jun09               *
      *                 BUG24334           Date 19Jun09               *
      *                 BUG24131A          Date 01Jun09               *
      *                 BUG24183           Date 03Jun09               *
      *                 BUG23939           Date 08May09               *
      *                 CER044  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021155 - COB Restructure Phase 1 Remnants                  *
      *           - Not changed at all - RE COB Optimisation Phase 1  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24437 - Interest Payments via MAPY not captured           *
      *           in AWV report and various errors                    *
      *  BUG24334 - Retail interest accounts are posted twice in AWV  *
      *             extract report                                    *
      *  BUG24131A - Various errors in AWV extract                    *
      *  BUG24183 - AWV extract does not capture correct GVC codes in *
      *             extract                                           *
      *  BUG23939 - Account codes are not correctly captured in report*
      *  CER044 - German Features LF035-00 AWV Reporting              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 - Database Error Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPopulate - Subroutine to populate the extract file         *
      *  SRCurr - Subroutine to Call AOCCURR0                         *
      *  SRConvert - Convert from one currency to another             *
      *  *INZSR - Initialisation Subroutine                           *
      *  *PSSR - Error processing                                     *
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
      *
      ** Midas GL Gen. Entries Int. Cap. Detail
      *
     FGEICPD    IF   E             DISK    PREFIX(G)
      *
      ***Midas*GL*AWV*Extract*for*Retail                                                    BUG24334
      *
     F***GLAWVRPD  UF A E             DISK    PREFIX(E)                                     BUG24334
      *
      ** Midas GL AWV Extract Extension for Retail
      *
     FGLAWXRPD  UF A E             DISK    PREFIX(EX)
      *
      ** Midas GL AWV Extract for Retail                                                    BUG24334
      *                                                                                     BUG24334
     FGLAWVRL0  UF A E           K DISK    PREFIX(E)                                        BUG24334
      *                                                                                     BUG24334
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)                                     MD021155
      ** Currency File for Full Cache Loading                                               MD021155
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Declare constants for the call of 'AOSVALR0'
      *
     D WVal01          C                   'AWVReporting'
     D WVal02          C                   'AWVminAmnt'
     D WVal03          C                   'AWVGVCDefault'
     D WVal04          C                   'RptgCcy'
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for Access Programs, Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, Long Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Externally described DS for Customer details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Network Transaction Identifierre Data Structure
      *
     D SDNTTI        E DS                  EXTNAME(SDNTTIPD)
     D                                     OCCURS(ARSNTTI)                                  MD021155
     D WSDNTTI         S                   INZ LIKE(SDNTTI)                                 MD021155
                                                                                            MD021155
      ** +--------------------------------------+                                           MD021155
      ** ¦ Cache Work Variables and Storage     ¦                                           MD021155
      ** ¦ ================================     ¦                                           MD021155
      ** +--------------------------------------+                                           MD021155
                                                                                            MD021155
     D ULimit          S             10I 0 INZ                                              MD021155
     D FoundInCache    S              1N   INZ                                              MD021155
     D ArrSzCcy        C                   CONST(250)                                       MD021155
     D SrcCcy          S                   INZ LIKE(A6CYCD)                                 MD021155
                                                                                            MD021155
      ** Currency Cache (key and detail storage)                                            MD021155
                                                                                            MD021155
     D KeyCcy          S                   INZ LIKE(SrcCcy)                                 MD021155
     D                                     DIM(ArrSzCcy) ASCEND                             MD021155
                                                                                            MD021155
     D DSCcy         E DS                  INZ EXTNAME(SDCURRL1:*INPUT)                     MD021155
     D                                     DIM(ArrSzCcy) QUALIFIED                          MD021155
                                                                                            MD021155
      ** Cache index                                                                        MD021155
                                                                                            MD021155
     D CcyIdx          DS                  INZ QUALIFIED                                    MD021155
     D  Last                               LIKE(ULimit)                                     MD021155
     D  Current                            LIKE(ULimit) INZ(1)                              MD021155
     D  Prev                               LIKE(ULimit) INZ(1)                              MD021155
      *                                                                                     MD021155
     D ARSNTTI         C                   CONST(100)                                       MD021155
     D TRUE            C                   CONST(*ON)                                       MD021155
     D FALSE           C                   CONST(*OFF)                                      MD021155
      *
      ** External data structures for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *                                                                                     MD021155
      ** LRU and full cache arrays                                                          MD021155
      *                                                                                     MD021155
     D CNTTI           S              2A   DIM(ARSNTTI) INZ                                 MD021155
     D LRUA            S             13S 0 DIM(ARSNTTI) INZ                                 MD021155
     D LRUS            S             13S 0 DIM(ARSNTTI) INZ                                 MD021155
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Variable declaration
      *
     D WTrTp           S              5A
     D PTrtp           S              5A
     D PNwRk           S              6A
     D PCurrency       S              3A
      *
      ** Declare parameters for the call of 'AOCUSTR0'
      *
     D PRtCd           S              7A
     D POpTn           S              7A
     D PCNum           S             10A
     D PKySt           S              7A
     D WAkey           S              1A
      *
      ** Declare parameter for currency conversion
      *
     D WCcy            S              3A
     D WCUrr           S              3A
     D WDec            S              4  0
     D WMinAmt         S             16  3
     D WAmt            S             16  3
     D WCur            S              3A
     D PAmunt          S             16  3
     D WNbdp           S              1P 0
      *
      ** Parameter Variables for the call of 'AOSVALR0'
      *
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
      ** Declare parameter for calling 'ZCCYCN'
      *
     D PAmount         S             15P 0
     D POutAmount      S             15P 0
     D PFrXRate        S             13P 8
     D PToXRate        S             13P 8
     D POutXRat        S             13P 8
     D PFrCurrency     S              3A
     D PToCurrency     S              3A
     D PFrMDIn         S              1A
     D PToMDIn         S              1A
     D POutMDIn        S              1A
     D PFrDecPlace     S              1P 0
     D PToDecPlace     S              1P 0
      *                                                                                     BUG24334
      ** Declare keylist variables for GLAWVRL0                                             BUG24334
      *                                                                                     BUG24334
     D DTRNO           S                   LIKE(ETRNO)                                      BUG24334
     D DPDAT           S                   LIKE(EPDAT)                                      BUG24334
     D DPAMT           S                   LIKE(EPAMT)                                      BUG24334
     D DRTYP           S                   LIKE(ERTYP)                                      BUG24334
     D DDCIN           S                   LIKE(EDCIN)                                      BUG24334
      *                                                                                     MD021155
      ** Declare temporary variable for change of customer                                  MD021155
      *                                                                                     MD021155
     D TCNUM           S             10A                                                    MD021155
      *                                                                                     MD021155
     D LRUKEY          S             13  0                                                  MD021155
     D IDXTRLNT        S              4  0                                                  MD021155
      *                                                                                     MD021155
     D RECSEQ          S                   LIKE(LRUKEY)                                     MD021155
     D IDXPRVNT        S                   LIKE(IDXTRLNT)                                   MD021155
     D IDXCURNT        S                   LIKE(IDXTRLNT)                                   MD021155
     D KEYTMPNT        S                   LIKE(WTRTP)                                      MD021155
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Check the input string
      *
     C                   IF        PSVal1 = 'Y'
      *
     C     1             SETLL     GEICPD
     C                   READ      GEICPD
     C                   DOW       NOT %EOF
      *
      ** Account type should be retail to proceed                                          BUG24131A
      *                                                                                    BUG24131A
     C                   IF        GATYP = 'R'                                             BUG24131A
      *                                                                                    BUG24131A
     C                   EXSR      SRConvert
      *
     C                   EVAL      WDec = 10**WNbdp
     C                   EVAL      PAmunt = POutAmount / WDec
      *
     C                   IF        (PAmunt > WMinAmt)
     C                   EXSR      SRPopulate
     C                   ENDIF
      *
     C                   ENDIF                                                             BUG24131A
      *                                                                                    BUG24131A
     C                   READ      GEICPD
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopulate -Subroutine to populate the extract file          *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPopulate    BEGSR
      *
      ** Populate Customer Number
      *
     C                   IF        GCNUM <> TCNUM                                           MD021155
     C                   EVAL      TCNUM = GCNUM                                            MD021155
     C                   MOVEL     GCNUM         PCNum
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCNum
     C                   PARM                    PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ELSE                                                               MD021155
     C                   EVAL      PRTCD = *BLANKS                                          MD021155
     C                   ENDIF                                                              MD021155
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      ECNUM = GCNUM
      *
      ** Populate Currency Code
      *
     C                   EVAL      ECCY = GCCY
      *
      ** Populate Deal number/Account
      *
     C                   MOVE      GACNO         ETRNO
      *
      ** Populate Type
      *
     C                   EVAL      ETYPE = *BLANKS
      *
      ** Populate Sub-Type
      *
     C                   EVAL      ESTYP = *BLANKS
      *
      ** Populate Posting Date
      *
     C                   EVAL      EPDAT = GPSTD
      *
      ** Populate Deal Start date
      *
     C                   EVAL      EDDAT = *ZEROS
      *
      ** Populate Deal Maturity date
      *
     C                   EVAL      EMDAT = *ZEROS
      *
      ** Populate Posting Amount
      *
     C                   EVAL      EPAMT = GPSTA
      *
      ** Populate Type of Posting
      *
     C                   EVAL      EPTYP = 'I'
      *                                                                                     BUG24437
      ** Populate Account code                                                              BUG24437
     C                   MOVEL     GACOD         EACNO                                      BUG24437
      *
      ** Populate GVC code using 'AONTTIR0'
      *
     C                   MOVE      GTRAT         WTrTp
     C                   EVAL      RECSEQ = RECSEQ + 1                                      MD021155
     C                   EVAL      KEYTMPNT = WTRTP                                         MD021155
     C                   EXSR      CHKCACHE                                                 MD021155
      *                                                                                     MD021155
     C                   IF        FoundInCache                                             MD021155
     C                   EVAL      %OCCUR(SDNTTI) = IDXCURNT                                MD021155
     C                   ELSE                                                               MD021155
      *                                                                                     MD021155
     C                   IF        IDXTRLNT <> ARSNTTI                                      MD021155
     C                   EVAL      IDXCURNT = IDXTRLNT + 1                                  MD021155
     C                   ELSE                                                               MD021155
     C                   EVAL      LRUS = LRUA                                              MD021155
     C                   SORTA     LRUS                                                     MD021155
     C                   EVAL      LRUKEY = LRUS(1)                                         MD021155
     C                   EVAL      IDXCURNT = %LOOKUP( LRUKEY : LRUA :                      MD021155
     C                                               1 : IDXTRLNT )                         MD021155
     C                   ENDIF                                                              MD021155
 
     C                   CALL      'AONTTIR0'
     C                   PARM                    PRtCd
     C                   PARM                    POptn
     C                   PARM      WTrTp         PTrtp
     C                   PARM      '*GVC'        PNwrk
     C*****SDNTTI        PARM      SDNTTI        DSFDY                                      MD021155
     C     WSDNTTI       PARM      WSDNTTI       DSFDY                                      MD021155
      *
     C                   IF        (PRtcd = '*NRF') OR (GTRAT = *ZEROS)
     C                   EVAL      EGVCC = PSVal3
     C                   ELSE
     C                   EVAL      EGVCC = '*GVC'
     C                   ENDIF
      *                                                                                     BUG24183
      ** Populate GVC code when details are found                                           BUG24183
      *                                                                                     BUG24183
     C                   IF        PRtcd = *Blanks                                          BUG24183
     C                   EVAL      %OCCUR(SDNTTI) = IDXCURNT                                MD021155
     C                   EVAL      SDNTTI = WSDNTTI                                         MD021155
     C                   EVAL      EGVCC = NINTTI                                           BUG24183
     C                   EXSR      ADDKEY                                                   MD021155
     C                   ENDIF                                                              BUG24183
      *                                                                                     MD021155
     C                   ENDIF                                                              MD021155
      *
      ** Populate Retail transaction type
      *
     C                   EVAL      ERTYP = WTrTp
      *
      ** Populate Debit/credit indicator
      *
     C                   MOVEL     GDRCR         EDCIN
      *
      ** Populate Resident flag
      *
     C**********         CALL      'AOBANKR0'                                               MD021155
     C**********         PARM      *BLANKS       PRtCd                                      MD021155
     C**********         PARM      '*FIRST '     POpTn                                      MD021155
     C*****SDBANK        PARM      SDBANK        DSFDY                                      MD021155
      *
     C                   IF        BBCOLC = BJCNCD
     C                   EVAL      ERFLG = 'Y'
     C                   ELSE
     C                   EVAL      ERFLG = 'N'
     C                   ENDIF
      *                                                                                    BUG24131A
     C                   IF        ERFLG = 'Y'                                             BUG24131A
      *
      ** Populate Bank/Non-Bank indicator
      *
     C                   EVAL      EBNBI = BBBNBI
      *
      ** Populate Country of location(ISO)
      *
     C                   EVAL      ECOLC = BBCOLC
      *
      ** Populate Local institution code
      *
     C                   EVAL      ELINC = BBLINC
      *
      ** Populate Reversal indicator
      *
     C                   MOVEL     GCQRI         EREVI
      *
      ** Write the Extract file
      *
     C                   EVAL      DTRNO = ETRNO                                            BUG24334
     C                   EVAL      DPDAT = EPDAT                                            BUG24334
     C                   EVAL      DPAMT = EPAMT                                            BUG24334
     C                   EVAL      DRTYP = ERTYP                                            BUG24334
     C                   EVAL      DDCIN = EDCIN                                            BUG24334
     C     AWVRKY        CHAIN     GLAWVRL0                                                 BUG24334
     C                   IF        NOT(%FOUND)                                              BUG24334
     C                   WRITE     GLAWVED0
      *
      ** Populate extension table fields
      *
     C                   EVAL      EXCNUM = GCNUM
     C                   EVAL      EXTRNO = ETRNO
     C                   EVAL      EXTTYP = 'RE'
     C                   EVAL      EXBRCA = GBRCA
     C**********         MOVEL     GACNO         EXACNO                                     BUG23939
     C                   MOVEL     GACOD         EXACNO                                     BUG23939
     C                   EVAL      EXACSQ = GACSQ
     C                   EVAL      EXPNAR = GPNAR
     C                   EVAL      EXPSRC = 'RE'
      *
      ** Write the Extract Extension file
      *
     C                   WRITE     GLAWVXD0
     C                   ENDIF                                                              BUG24334
      *                                                                                    BUG24131A
     C                   ENDIF                                                             BUG24131A
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *                                                                                     BUG24334
      ** Define keylist for AWV Extract Retail                                              BUG24334
      *                                                                                     BUG24334
     C     AWVRKY        KLIST                                                              BUG24334
     C                   KFLD                    DTRNO                                      BUG24334
     C                   KFLD                    DPDAT                                      BUG24334
     C                   KFLD                    DPAMT                                      BUG24334
     C                   KFLD                    DRTYP                                      BUG24334
     C                   KFLD                    DDCIN                                      BUG24334
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      WVal01        PSValK1
     C                   PARM                    PSVal1
     C                   PARM      WVal02        PSValK2
     C                   PARM                    PSVal2
     C                   PARM      WVal03        PSValK3
     C                   PARM                    PSVal3
     C                   PARM      WVal04        PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRtcd <> *BLANKS  AND
     C                             PRtcd <> '*NRF   '
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE3664B'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = %TRIM(PSValK1)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save currency specifics first (Exchange Rate, M/D Indicator
      ** and decimal places)
      *
     C                   MOVEL     PSVal4        PToCurrency
     C                   EVAL      PCurrency = PToCurrency
      *
      ** Load Currency Cache                                                                MD021155
      *                                                                                     MD021155
     C                   EVAL      ULimit = 0                                               MD021155
      *                                                                                     MD021155
     C     *LOVAL        SETLL     SDCURRL1                                                 MD021155
     C                   READ      @A6REA3       DSCcy(1)                                   MD021155
     C                   DOW       NOT %EOF(SDCURRL1) AND                                   MD021155
     C                             ULimit < ArrSzCcy                                        MD021155
     C                   EVAL      ULimit = ULimit + 1                                      MD021155
     C                   EVAL      KeyCcy( ULimit ) =                                       MD021155
     C                                DSCcy( ULimit ).A6CYCD                                MD021155
      *                                                                                     MD021155
     C                   READ      @A6REA3       DSCcy(ULimit)                              MD021155
     C                   ENDDO                                                              MD021155
      *                                                                                     MD021155
     C                   EVAL      CcyIdx.Last = ULimit                                     MD021155
      *                                                                                     MD021155
     C                   EVAL      SrcCcy = PCURRENCY                                       MD021155
     C                   EXSR      CHKCCR                                                   MD021155
      *                                                                                     MD021155
     C                   IF        NOT FoundInCache                                         MD021155
     C                   EXSR      SrCurr
     C                   ENDIF                                                              MD021155
      *
     C                   EVAL      PToXRate = A6SPRT
     C                   EVAL      PToMDIn = A6MDIN
     C                   EVAL      PToDecPlace = A6NBDP
     C                   EVAL      WNbdp = PToDecPlace
      *
      ** Editing the Minimum amount value
      *
     C                   EVAL      WMinAmt = %DEC(PSVal2:16:3)
      *
     C                   CALL      'AOBANKR0'                                               MD021155
     C                   PARM      *BLANKS       PRtCd                                      MD021155
     C                   PARM      '*FIRST '     POpTn                                      MD021155
     C     SDBANK        PARM      SDBANK        DSFDY                                      MD021155
      *                                                                                     MD021155
     C                   IF        PRTCD <> *BLANK                                          MD021155
     C     *LOCK         IN        LDA                                                      MD021155
     C                   EVAL      DBFILE = 'SDBANKPD'                                      MD021155
     C                   EVAL      DBKEY = '*FIRST'                                         MD021155
     C                   EVAL      DBASE = 021                                              MD021155
     C                   OUT       LDA                                                      MD021155
     C                   EXSR      *PSSR                                                    MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   EVAL      LRUKEY = 0                                               MD021155
     C                   EVAL      IDXTRLNT = 0                                             MD021155
     C                   EVAL      KEYTMPNT = *BLANKS                                       MD021155
     C                   EVAL      IDXPRVNT = IDXTRLNT                                      MD021155
      *                                                                                     MD021155
     C                   ENDSR
      *****************************************************************                     MD021155
      /EJECT                                                                                MD021155
      *****************************************************************                     MD021155
      *                                                               *                     MD021155
      *  CHKCACHE - Check key if existing in cache array              *                     MD021155
      *                                                               *                     MD021155
      *****************************************************************                     MD021155
     C     CHKCACHE      BEGSR                                                              MD021155
      *                                                                                     MD021155
      ** Reinitialize work fields                                                           MD021155
      *                                                                                     MD021155
     C                   EVAL      FoundInCache = FALSE                                     MD021155
      *                                                                                     MD021155
      ** Only cache non-BLANK key fields and only check                                     MD021155
      ** if cache has been loaded                                                           MD021155
      *                                                                                     MD021155
     C                   IF        WTRTP <> *BLANKS                                         MD021155
     C                             AND IDXTRLNT <> 0                                        MD021155
      *                                                                                     MD021155
      ** Save previous index position to current index position                             MD021155
      *                                                                                     MD021155
     C                   EVAL      IDXCURNT = IDXPRVNT                                      MD021155
      *                                                                                     MD021155
      ** If the temporary key value being checked is the same                               MD021155
      ** with the value pointed by current index, use the                                   MD021155
      ** current detail rather than doing a LOOKUP                                          MD021155
      *                                                                                     MD021155
     C                   IF        KEYTMPNT = CNTTI(IDXCURNT)                               MD021155
      *                                                                                     MD021155
     C                   EVAL      FoundInCache = TRUE                                      MD021155
      *                                                                                     MD021155
     C                   ELSE                                                               MD021155
      *                                                                                     MD021155
     C                   EVAL      IDXCURNT = %LOOKUP( KEYTMPNT :                           MD021155
     C                                               CNTTI :                                MD021155
     C                                               1 : IDXTRLNT )                         MD021155
      *                                                                                     MD021155
      ** If returned value of current index from LOOKUP                                     MD021155
      ** is found in cache (not equal to 0)                                                 MD021155
      *                                                                                     MD021155
     C                   IF        IDXCURNT <> 0                                            MD021155
     C                   EVAL      FoundInCache = True                                      MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
      ** Save the last accessed detail to previous index                                    MD021155
      ** Set the indicator to show the data was found                                       MD021155
      *                                                                                     MD021155
     C                   IF        FoundInCache                                             MD021155
     C                   EVAL      LRUA(IDXCURNT) = RECSEQ                                  MD021155
     C                   EVAL      IDXPRVNT = IDXCURNT                                      MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   ENDSR                                                              MD021155
      *****************************************************************                     MD021155
      /EJECT                                                                                MD021155
      *****************************************************************                     MD021155
      *                                                               *                     MD021155
      *  ADDKEY - Add key details to cache array                      *                     MD021155
      *                                                               *                     MD021155
      *****************************************************************                     MD021155
     C     ADDKEY        BEGSR                                                              MD021155
      *                                                                                     MD021155
      ** If there is still room in the array then add the details                           MD021155
      *                                                                                     MD021155
     C                   IF        IDXTRLNT < ARSNTTI                                       MD021155
     C                   EVAL      IDXTRLNT = IDXTRLNT + 1                                  MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
      ** Store only the Key value in Cache                                                  MD021155
      ** Store the record counter in LRU cache pointed by current index                     MD021155
      *                                                                                     MD021155
     C                   EVAL      CNTTI(IDXCURNT) = WTRTP                                  MD021155
     C                   EVAL      LRUA(IDXCURNT) = RECSEQ                                  MD021155
      *                                                                                     MD021155
      ** Set last accessed detail to IDXPRV so that CHKCACHE checks this                    MD021155
      ** latest detail first                                                                MD021155
      *                                                                                     MD021155
     C                   EVAL      IDXPRVNT = IDXCURNT                                      MD021155
      *                                                                                     MD021155
     C                   ENDSR                                                              MD021155
      *****************************************************************                     MD021155
      /EJECT                                                                                MD021155
      *****************************************************************                     MD021155
      *                                                               *                     MD021155
      *  CHKCCR - Check if key exists in currency cache               *                     MD021155
      *                                                               *                     MD021155
      *****************************************************************                     MD021155
     C     CHKCCR        BEGSR                                                              MD021155
                                                                                            MD021155
      ** Only search cache if Search Key is not blank (not zero if numeric)                 MD021155
      ** and cache not empty                                                                MD021155
                                                                                            MD021155
     C                   EVAL      FoundInCache = FALSE                                     MD021155
      *                                                                                     MD021155
     C                   IF        SrcCcy = *BLANKS OR                                      MD021155
     C                             CcyIdx.Last = 0                                          MD021155
     C                   LEAVESR                                                            MD021155
     C                   ENDIF                                                              MD021155
                                                                                            MD021155
      ** Perform search if key is not the recent search                                     MD021155
      ** otherwise, just resend the details from previous cache                             MD021155
                                                                                            MD021155
     C                   IF        SrcCcy = KeyCcy( CcyIdx.Prev )                           MD021155
     C                   EVAL      FoundInCache = TRUE                                      MD021155
     C                   EVAL      CcyIdx.Current = CcyIdx.Prev                             MD021155
     C                   ELSE                                                               MD021155
      *                                                                                     MD021155
     C                   EVAL      CcyIdx.Current =                                         MD021155
     C                                   %LOOKUP( SrcCcy                                    MD021155
     C                                          : KeyCcy                                    MD021155
     C                                          : 1                                         MD021155
     C                                          : CcyIdx.Last )                             MD021155
                                                                                            MD021155
     C                   IF        CcyIdx.Current <> 0                                      MD021155
     C                   EVAL      FoundInCache = True                                      MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   IF        FoundInCache                                             MD021155
     C                   EVAL      SDCURR = DSCcy( CcyIdx.Current )                         MD021155
     C                   EVAL      CcyIdx.Prev = CcyIdx.Current                             MD021155
     C                   ENDIF                                                              MD021155
      *                                                                                     MD021155
     C                   ENDSR                                                              MD021155
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCurr - Subroutine to Call AOCCURR0                         *
      *                                                               *
      *  Called by: SRConvert                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCurr        BEGSR
      *
      ** Retrieve Currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POpTn
     C                   PARM      PCurrency     WCUrr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY =  WCcy
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Convert from one currency to another              *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRConvert     BEGSR
      *
     C                   IF        GCCY <> PToCurrency
      *
      ** If target currency is not the base currency, do cross
      ** currency conevrt
      *
     C                   EVAL      PCurrency = GCCY
     C                   EVAL      PFrCurrency = PCurrency
      *
     C                   EVAL      SrcCcy = PCURRENCY                                       MD021155
     C                   EXSR      CHKCCR                                                   MD021155
     C                   IF        NOT FoundInCache                                         MD021155
     C                   EXSR      SrCurr
     C                   ENDIF                                                              MD021155
      *
     C                   EVAL      PFrXRate = A6SPRT
     C                   EVAL      PFrMDIn = A6MDIN
     C                   EVAL      PFrDecPlace = A6NBDP
      *
     C                   CALL      'ZCCYCN'
     C                   PARM      GPSTA         PAmount
     C                   PARM                    PFrCurrency
     C                   PARM                    PToCurrency
     C                   PARM                    PFrXRate
     C                   PARM                    PToXRate
     C                   PARM                    PFrMDIn
     C                   PARM                    PToMDIn
     C                   PARM                    PFrDecPlace
     C                   PARM                    PToDecPlace
     C                   PARM                    POutAmount
     C                   PARM                    POutXRat
     C                   PARM                    POutMDIn
      *
     C                   ELSE
      *
     C                   EVAL      POutAmount = GPSTA
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: None                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
