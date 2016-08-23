     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL AWV Extract Program')                         *
/*OVRF*: OVRDBF FILE(XXDKEYSDP) TOFILE(DKEYSDP)                     : *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  DL000298 - Dealing AWV Extract Program                       *
      *                                                               *
      *  Function:  This program that will be created to generate the *
      *             AWV extracts for the dealing                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Component of: DL000298                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24479           Date 22Jun09               *
      *                 BUG23941A          Date 10Jun09               *
      *                 BUG24131           Date 01Jun09               *
      *                 BUG24183           Date 03Jun09               *
      *                 BUG23941           Date 18May09               *
      *                 BUG23939           Date 08May09               *
      *                 CER044  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - Missing in DB-GLAWVDPD values for DDAT ACNO         *
      *  BUG24479 - Dealing Transaction Errors in AWV Report          *
      *  BUG23941A - Dealing and REtail Transac Not captured in report*
      *            re-open dealing transactions >12 months            *
      *  BUG24131 - Various errors in AWV extract                     *
      *  BUG24183 - AWV extract does not capture correct GVC codes in *
      *             extract                                           *
      *  BUG23941 - Dealing and REtail Transac Not captured in report *
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
      *  SRDate - Subroutine for Date conversion                      *
      *  SRCurr - Subroutine to Call AOCCURR0                         *
      *  SRConvert - Convert from one currency to another             *
      *  SRPopulate - Subroutine to populate the extract file         *
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
      ** Midas GL Generated Entries Detail
      *
     FGEDLL0    IF   E           K DISK    PREFIX(G)
      *
      ** Midas DL Deals generated a/c keys detail
      *
     FXXDKEYSDP IF   E             DISK    PREFIX(K)
      *
      ** Midas DL Deals Generated A/C key Details LF
      *
     FSDKEYC    IF   E           K DISK    PREFIX(A)
      *
      ** Midas DL Deals file
      *
     FDEALS     IF   E           K DISK    PREFIX(D)
      *
      ** Midas GL AWV Extract for Dealing
      *
     FGLAWVDL0  UF A E           K DISK    PREFIX(E)
      *
      ** Midas GL AWV Extract Extension for Dealing
      *
     FGLAWXDL0  UF A E           K DISK    PREFIX(EX)
      *
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
      *
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
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
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
      *
      ** External data structures for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
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
     D WTrNo           S              6  0
     D WAkey           S              1A
     D PCurrency       S              3A
      *
      ** Declare parameters for the call of AOCUSTR0
      *
     D PRtCd           S              7A
     D POpTn           S              7A
     D PCNum           S             10A
     D PKySt           S              7A
      *
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZADate          S              7A
     D WMmDdYy         S               D   DATFMT(*DMY)
     D WMonth          S              2  0
     D WPsTd           S               D   DATFMT(*DMY)
     D WVaLd           S               D   DATFMT(*DMY)
     D WMDat           S               D   DATFMT(*DMY)                                     BUG23941
     D TsDat           S               D   DATFMT(*DMY)                                    BUG23941A
     D***WMth**          S              2  0                                               BUG23941A
     D WDate           S              5  0
      *                                                                                     BUG23941
     D DDAT@           S                   LIKE(EDDAT)                                      BUG23941
     D MDAT@           S                   LIKE(EMDAT)                                      BUG23941
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
      ** Define KList for the population of Reversal indicator
      *
     C     KRevIn        KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KCNUM
     C                   KFLD                    KBRCA
     C                   KFLD                    KECCY
     C                   KFLD                    KAKEY
      *
      ** Check the input string
      *
     C                   IF        PSVal1 = 'Y'
      *
     C     *LOVAL        SETLL     GEDLL0
     C                   READ      GEDLL0
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WDate = GPSTD
     C                   EXSR      SRDate
     C                   MOVE      WMmDdYy       WPsTd
     C                   EVAL      WDate = GVALD
     C                   EXSR      SRDate
     C                   MOVE      WMmDdYy       WVaLd
      *
      ** Get original maturity date                                                         BUG23941
      *                                                                                     BUG23941
     C                   EXSR      SRGetMtDte                                               BUG23941
      ** Move code inside subroutine                                                        BUG23941
      *                                                                                     BUG23941
     C**********         EVAL      WMth = %DIFF(WPstd:WVaLd:*MONTHS)                        BUG23941
      *
     C                   EXSR      SRConvert
      *
     C                   EVAL      WDec = 10**WNbdp
     C                   EVAL      PAmunt = POutAmount / WDec
      *
     C                   IF        (PAmunt > WMinAmt) AND
     C                             (WMDat > TsDat)                                         BUG23941A
     C**********                   (WMth > 12)                                             BUG23941A
      *
     C                   EXSR      SRPopulate
     C                   ENDIF
      *
     C                   READ      GEDLL0
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *                                                                                     BUG23941
      *****************************************************************                     BUG23941
      /EJECT                                                                                BUG23941
      *****************************************************************                     BUG23941
      *                                                               *                     BUG23941
      *  SRGetMtDte - Subroutine to get original maturity date        *                     BUG23941
      *                                                               *                     BUG23941
      *  Called By: MAIN Processing                                   *                     BUG23941
      *                                                               *                     BUG23941
      *  Calls: None                                                  *                     BUG23941
      *                                                               *                     BUG23941
      *****************************************************************                     BUG23941
      *                                                                                     BUG23941
     C     SRGetMtDte    BEGSR                                                              BUG23941
      *                                                                                     BUG23941
     C                   EVAL      DDAT@ = 0                                                BUG23941
     C                   EVAL      MDAT@ = 0                                                BUG23941
     C                   CLEAR                   WMDat                                      BUG23941
     C                   CLEAR                   TsDat                                     BUG23941A
     C**********         EVAL      WMth  = 0                                      BUG23941 BUG23941A
      *                                                                                     BUG23941
     C                   IF        GDLREF <> *blanks                                        BUG23941
     C                   EVAL      WTrNo = %DEC(%SUBST(GDLREF:2:6): 6: 0)                   BUG23941
      ** Populate Deal start date and Deal maturity date                                    BUG23941
      *                                                                                     BUG23941
     C     WTrNo         CHAIN     DEALS                                                    BUG23941
      *                                                                                     BUG23941
     C                   IF        %FOUND                                                   BUG23941
     C                             AND DMDAT <> 0                                           BUG23941
     C**********         EVAL      DDAT@ = DFSOSDT                                  BUG23941  CER059
     C                   EVAL      DDAT@ = DISDT                                              CER059
     C                   EVAL      MDAT@ = DMDAT                                            BUG23941
     C                   EVAL      WDate = DMDAT                                            BUG23941
     C                   EXSR      SRDate                                                   BUG23941
     C                   MOVE      WMmDdYy       WMDat                                      BUG23941
      *                                                                                     BUG23941
     C                   EVAL      TsDat = WPstd + %YEARS(1)                               BUG23941A
     C**********         EVAL      WMth = %ABS(%DIFF(WPstd:WMDat:*MONTHS))        BUG23941 BUG23941A
     C                   ENDIF                                                              BUG23941
      *                                                                                     BUG23941
     C                   ENDIF                                                              BUG23941
      *                                                                                     BUG23941
     C                   ENDSR                                                              BUG23941
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopulate - Subroutine to populate the extract file         *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPopulate    BEGSR
      *
     C     1             SETLL     XXDKEYSDP
     C                   READ      XXDKEYSDP
     C                   DOW       NOT %EOF
     C                   EVAL      DDLNO = KDLNO
      *                                                                                    BUG23941A
      ** skip record if ot same deal number from main input file                           BUG23941A
     C                   IF        WTrNo = DDLNO                                           BUG23941A
     C                             and %SUBST(KAKEY:1:10) = %SUBST(GACKEY:7:10)             BUG24479
      *
     C     DDLNO         CHAIN     DEALS
      *
     C                   IF        %FOUND
      *
      ** input file may use either customer number / internal customer number              BUG23941A
     C                   IF        GCNUM = DCNUM                                           BUG23941A
     C                   MOVEL     GCNUM         PCNum
     C                   ELSE                                                              BUG23941A
     C                   MOVEL     DCNUM         PCNum                                     BUG23941A
     C                   ENDIF                                                             BUG23941A
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POpTn
     C                   PARM                    PCNum
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Populate Customer Number
      *
     C                   IF        PRtCd = *BLANKS                                         BUG23941A
     C**********         EVAL      ECNUM = %DEC(%TRIM(PCNum):6:0)                          BUG23941A
     C                   MOVEL     PCNum         ECNUM                               BUG23941 CER059
      *                                                                                    BUG23941A
     C**********         IF        PRtCd = *BLANKS  AND                                    BUG23941A
     C**********                   DCNUM = GCNUM                                           BUG23941A
     C**********         EVAL      ECNUM = GCNUM                                           BUG23941A
      *
      ** Populate Currency code(ISO)
      *
     C                   EVAL      ECCY = GCCY
      *
      ** Populate Deal number/Account
      *
     C                   EVAL      ETRNO = %SUBST(GDLREF:2:6)
     C                   MOVEL     ETRNO         WTrNo
     C                   IF        WTrNo = KDLNO AND GPSTA = KEAMT                          BUG24131
      *
      ** Populate Type
      *
      ** deal type subtype is mixed up                                                     BUG23941A
     C**********         EVAL      ETYPE = GOTST                                           BUG23941A
     C                   EVAL      ETYPE = GOTTP                                           BUG23941A
      *
      ** Populate Sub-Type
      *
     C**********         EVAL      ESTYP = GOTTP                                           BUG23941A
     C                   EVAL      ESTYP = GOTST                                           BUG23941A
      *
      ** Populate Posting date
      *
     C                   EVAL      EPDAT = GPSTD
      *
      ** Populate Deal start date and Deal maturity date
      *
     C*****WTrNo         CHAIN     DEALS                                                    BUG23941
      *
     C                   EVAL      EDDAT = DDAT@                                            BUG23941
     C                   EVAL      EMDAT = MDAT@                                            BUG23941
     C**********         IF        %FOUND                                                   BUG23941
     C**********         EVAL      EDDAT = DFSOSDT                                          BUG23941
     C**********         EVAL      EMDAT = DMDAT                                            BUG23941
     C**********         ENDIF                                                              BUG23941
      *
      ** Populate Posting amount in transaction/account CCY
      *
     C                   EVAL      EPAMT = GPSTA
      *
      ** Populate Type of Posting
      *
     C                   IF        ETYPE = %SUBST(KAKEY:1:2)
      *
     C                   EVAL      WAkey = %SUBST(KAKEY:10:1)
      *
     C                   IF        WAkey = 'A'
     C                   EVAL      EPTYP = 'P'
     C                   ELSEIF    WAkey = 'I'
     C                   EVAL      EPTYP = 'I'
     C                   ELSE
     C                   EVAL      EPTYP = *BLANKS
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      EPTYP = *BLANKS
     C                   ENDIF
      *
      ** Populate GVC code
      *
     C                   MOVE      GTRAT         WTrTp
      *
     C                   CALL      'AONTTIR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    POpTn
     C                   PARM      WTrTp         PTrtp
     C                   PARM      '*GVC'        PNwrk
     C     SDNTTI        PARM      SDNTTI        DSFDY
      *
     C                   IF        (PRtCd = '*NRF') OR (GTRAT = *ZEROS)
     C                   EVAL      EGVCC = PSVal3
     C                   ELSE
     C                   EVAL      EGVCC = '*GVC'
     C                   ENDIF
      *                                                                                     BUG24183
      ** Populate GVC code when details are found                                           BUG24183
      *                                                                                     BUG24183
     C                   IF        PRtcd = *Blanks                                          BUG24183
     C                   EVAL      EGVCC = NINTTI                                           BUG24183
     C                   ENDIF                                                              BUG24183
      *
      ** Populate Retail transaction type
      *
     C                   EVAL      ERTYP = *BLANKS
      *
      ** Populate Debit Credit Indicator
      *
     C                   MOVEL     GDRCR         EDCIN
      *
      ** Populate Resident Flag
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POpTn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        BBCOLC = BJCNCD
     C                   EVAL      ERFLG = 'Y'
     C                   ELSE
     C                   EVAL      ERFLG = 'N'
     C                   ENDIF
      *                                                                                     BUG24131
     C                   IF        ERFLG = 'Y' AND (WAkey = 'A' OR WAkey = 'I')             BUG24131
      *
      ** Populate Bank/Non-Bank indicator
      *
     C                   EVAL      EBNBI = BBBNBI
      *
      ** Populate Country of location (ISO)
      *
     C                   EVAL      ECOLC = BBCOLC
      *
      ** Populate Local institution code
      *
     C                   EVAL      ELINC = BBLINC
      *                                                                                       CER059
      ** Populate Account Code                                                                CER059
      *                                                                                       CER059
     C                   MOVEL     GACOD         EACNO                                        CER059
      *
      ** Populate Reversal indicator
      *
     C     KRevIn        CHAIN     DKEYD0
     C                   IF        %FOUND
     C                   MOVEL     KREVI         EREVI
     C                   ENDIF
     C*****ETRNO         CHAIN     GLAWVDL0                                                 BUG24131
     C**********         IF        %FOUND                                                   BUG24131
     C**********         ELSE                                                               BUG24131
     C                   WRITE     GLAWVED0
     C**********         ENDIF                                                              BUG24131
      *
      ** Populate extension table fields
      *
     C**********         EVAL      EXCNUM = GCNUM                                          BUG23941A
     C                   EVAL      EXCNUM = ECNUM                                          BUG23941A
     C                   EVAL      EXCCY = GCCY                                            BUG23941A
     C                   EVAL      EXTRNO = ETRNO
     C                   EVAL      EXTTYP = GOTST
     C                   EVAL      EXBRCA = GBRCA
     C**********         MOVEL     GACNO         EXACNO                                     BUG23939
     C                   MOVEL     GACOD         EXACNO                                     BUG23939
     C                   EVAL      EXACSQ = GACSQ
     C                   EVAL      EXPNAR = GPNAR
     C                   EVAL      EXPSRC = 'DL'
     C*****EXTRNO        CHAIN     GLAWXDL0                                                 BUG24131
     C**********         IF        %FOUND                                                   BUG24131
     C**********         ELSE                                                               BUG24131
     C                   WRITE     GLAWVXD0
     C**********         ENDIF                                                              BUG24131
      *
     C                   ENDIF                                                              BUG24131
     C                   ENDIF                                                              BUG24131
      *                                                                                     BUG24131
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                             BUG23941A
     C                   READ      XXDKEYSDP
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDate - Subroutine for Date conversion                      *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDate        BEGSR
      *
     C                   EVAL      ZDayNo = WDate
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    ZADate
     C                   MOVEL     ZDate         WMmDdYy
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
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
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
     C                   IF        PRtCd <> *BLANKS  AND
     C                             PRtCd <> '*NRF   '
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'DL000298'
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
     C                   EXSR      SrCurr
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
     C                   ENDSR
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
     C                   EXSR      SrCurr
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
