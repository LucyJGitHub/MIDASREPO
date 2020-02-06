     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Matured Loans History Print')                 *
      *****************************************************************
      *                                                               *
      *  Midas  -  Customer Lending Module                            *
      *                                                               *
      *  LE0901 -  LE HISTORY CARD PRINT                              *
      *                                                               *
      *  Function:  This program prints loans maturing this month on  *
      *             LE0900P1.                                         *
      *                                                               *
      *  Called By: LEC1001 - Midas LE Monthly History Proc. & Rpt.   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE154             Date 07Aug12               *
      *                 260891             Date 17Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247682             Date 21May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 10May06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG7415 *CREATE    Date 14Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  260891 - Wrong projection in LOAC. Add LCD as a key.         *
      *           Recompiled due to changes in LF/HISTR.              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  247682 - Consider date format before passing to ZDATE1       *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG7415 - History Card printing of loans transferred to      *
      *            LE0901. Print matured loans on month-end of        *
      *            maturing month.                                    *
      *                                                               *
      *****************************************************************
     FMATLNHP   IF   E           K DISK
     F                                     RENAME(HISTSHPF:MATLNHPF)
     FHISTR     IF   E           K DISK
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FMLOAN     IF   E           K DISK
     F                                     RENAME(CLOANCLF:MCLONCLF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FLE0900P1  O    F  132        PRINTER INFDS(SPOOL)
     F                                     OFLIND(*INOF)
     F                                     USROPN
      *****************************************************************
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *       02      New Branch Indicator                            *
      *       03      Read MATLNHP Indicator                          *
      *       04      Chain HISTR Indicator                           *
      *       05      History Loan Header                             *
      *       06      Chain CLOANCLF Indicator                        *
      *       07      History Loan Amount Record                      *
      *       08      Chain MCLONCLF Indicator                        *
      *       10      Loan Subtype Change Indicator                   *
      *       14      History Rates Detail                            *
      *       20      End Of Branch Report Output Indicator           *
      *       21      Multibranching Output                           *
      *       22      Premium Loan                                    *
      *       23      Discounted Loan                                 *
      *       24      0 Decimal Place Currency                        *
      *       25      1 Decimal                                       *
      *       26      2 Decimals                                      *
      *       27      3 Decimals                                      *
      *       30      CLE005 is installed                             *
      *       35      Multibranching is YES                           *
      *       40      Month Array LOKUP                               *
      *       46      Output Headings                                 *
      *       48      Value Date > Zero (Header)                      *
      *       49      Maturity Date > Zero                            *
      *       50      Expected Date > Zero                            *
      *       51      Value Date > Zerp (Detail)                      *
      *       52      'ADD' Spread Indicator                          *
      *       53      'SUBTRACT'                                      *
      *       54      'PERCENTAGE'                                    *
      *       55      'AMOUNT' on output line edited for rates - 7 dec*
      *       56      Sorts out Amendment Type                        *
      *       57      Print a detail line by exception                *
      *       58      Principal Amount - Zero                         *
      *       59      Principal Amount - > Zero                       *
      *       60      Interest Amount  - > Zero                       *
      *       61      Witholding Tax Amount - > Zero                  *
      *       62      Principal Amount - > Zero                       *
      *       63      Repayment is Past Due                           *
      *       64      Print extra fields for Maturity Repayment       *
      *       65      Interest Amount - > Zero                        *
      *       66      Witholding Tax  - > Zero                        *
      *       67      Fee Amount - > Zero                             *
      *       68      Principal Amount - > Zero                       *
      *       69      Interest Amount - > Zero                        *
      *       70      Witholding Tax  - > Zero                        *
      *       71      Base Rate - > Zero                              *
      *       72      Base Rate - Zero                                *
      *       73      Spread - > or = Zero                            *
      *       74      Spread - > Zero                                 *
      *       75      ST Accrual Ind is 'Y'                           *
      *       76      ST Accrual Ind is blank                         *
      *       77      Base Rate is > Zero                             *
      *       78      Base Rate is = Zero                             *
      *       79      Spread - > Zero                                 *
      *       80      Spread - > Zero                                 *
      *       83      Interest Capitalisation is used on this loan    *
      *       84      Print the Original Borrower                     *
      *       87      Print Receiving Loan on PF event                *
      *       88      Print Originating loan on PT event              *
      *****************************************************************
      /EJECT
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)            ZFREQ SR ARRAY
     D NARR            S             30    DIM(40) CTDATA PERRCD(1)             NARRATIVES
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D WLNRF           S              6A                                                      CLE148
      *
      ** Data area rundat
      *
     D RUNDT           DS
     D  RUNA                   1      7
     D  WDAY                   1      2  0
     D  WMNT                   3      5
     D  WYER                   6      7  0
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
      ** Loan header
      *
     D                 DS
     D**FCUSH**               32     37  0                                                   CSD027A
     D  FCUSH                 32     37                                                      CSD027A
     D  FTYPH                 38     40  0
     D  FSEQH                 41     42  0
     D  BRCAH                 43     45
     D  ZEROS                 46     57  0
     D**LNRFH***              58     63  0                                                    CLE148
     D  LNRFH                 58     63                                                       CLE148
     D  CCYH                  64     66
     D  PTYPH                 67     68  0
     D  LHED                  32     68
      *
      ** Local data area for database error
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** File information data structure
      *
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      *
      ** File information data structure
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** External DS for bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  TITL         E                     EXTFLD(BJURPT)
      *
      ** External DS for module details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for branch code details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRNM         E                     EXTFLD(A8BRNM)
      *
      ** External DS for currency details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D  CDP          E                     EXTFLD(A6NBDP)
      *
      ** External ds for customer details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  CRNM         E                     EXTFLD(BBCRNM)
     D  CTWN         E                     EXTFLD(BBCRTN)
     D  DFAC         E                     EXTFLD(QQDFAC)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Third DS for access programs, very long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Switchable Features File
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      /EJECT
      *
      ** Rename fields with suffix 'M'
      *
     IMATLNHPF
     I              RECI                        RECIM
     I              RCDT                        RCDTM
     I              BRCA                        BRCAM
     I              CNUM                        CNUMM
     I              LNRF                        LNRFM
     I              VDAT                        VDATM
     I              PRSQ                        PRSQM
     I              LASN                        LASNM
     I              FCUS                        FCUSM
     I              FTYP                        FTYPM
     I              FSEQ                        FSEQM
     I              PTYP                        PTYPM
     I              CCY                         CCYM
     I              AMTP                        AMTPM
     I              PRAM                        PRAMM
     I              INTA                        INTAM
     I              WTXA                        WTXAM
     I              FEAM                        FEAMM
     I              FECD                        FECDM
     I              WOIN                        WOINM
     I              EXVD                        EXVDM
     I              LTYP                        LTYPM
     I              SUTP                        SUTPM
     I              ZZ013                       ZZ01M
     I              LCD                         LCDM
     I              ZZ001                       ZZ00M
     I              COFA                        COFAM
     I              CPAM                        CPAMM
     I              AITC                        AITCM
     I              INTR                        INTRM
     I              AIAP                        AIAPM
     I              IPRD                        IPRDM
     I              MNSG                        MNSGM
     I              GASS                        GASSM
     I              GPRT                        GPRTM
     I              ROLN                        ROLNM
     I              ACDA                        ACDAM
     I              COFR                        COFRM
     I              ACAP                        ACAPM
     I              COFD                        COFDM
     I              REPI                        REPIM
     I              CLAS                        CLASM                                         CLE042
     IHISTSHMF
     I              BRCA                        BRCAH
     I              CNUM                        CNUMH
     I              LNRF                        LNRFH
     I              VDAT                        VDATH
     I              FCUS                        FCUSH
     I              FTYP                        FTYPH
     I              FSEQ                        FSEQH
     I              CCY                         CCYH
     I              PRAM                        PRAMH
     I              BRTE                        BRTEH
     I              LTYP                        LTYPH
     I              SUTP                        SUTPH
     I              CLAS                        CLASH                                         CLE042
     IHISTSHPF
     I              LTYP                        LTYPH
     I              SUTP                        SUTPH
     I              CLAS                        CLASH                                         CLE042
     ICLOANCLF
     I              RECI                        RECIL
     I              LNRF                        LNRFL
     I              RCDT                        RCDTL
     I              MRIN                        MRINL
     I              PTYP                        PTYPL
     I              CNUM                        CNUML
     I              BRCA                        BRCAL
     I              LTYP                        LTYPL
     I              SUTP                        SUTPL
     I              DDAT                        DDATL
     I              VDAT                        VDATL
     I              MDAT                        MDATM
     I              LASQ                        LASQL
     I              FCUS                        FCUSL
     I              FTYP                        FTYPL
     I              FSEQ                        FSEQL
     I              CCY                         CCYL
     I              CPAM                        CPAML
     I              INTC                        INTCL
     I              INTR                        INTRL
     I              BRTT                        BRTTM
     I              BRTE                        BRTEM
     I              RTSP                        RTSPM
     I              MARG                        MARGL
     I              SPIN                        SPINM
     I              CHIN                        CHINL
     I              WTRT                        WTRTL
     I              WTIN                        WTINL
     I              REPT                        REPTL
     I              RAMT                        RAMTL
     I              NRPD                        NRPDL
     I              RFRQ                        RFRQL
     I              RDYN                        RDYNL
     I              FCCY                        FCCYL
     I              LIND                        LINDL
     I              CRSK                        CRSKL
     I              ACOF                        ACOFL
     I              NACD                        NACDL
     I              RELI                        RELIL
     I              AUTO                        AUTOL
     I              PSAM                        PSAML
     I              BCXR                        BCXRL
     I              FCXR                        FCXRL
     I              SDST                        SDSTL
     I              OSDA                        OSDAL
     I              TSTN                        TSTNL
     I              MDST                        MDSTL
     I              OMDA                        OMDAL
     I              TMAN                        TMANL
     I              FACO                        FACOL
     I              RLDT                        RLDTL
     I              NROD                        NRODL
     I              RLFQ                        RLFQL
     I              RLDY                        RLDYL
     I              RDFC                        RDFCL
     I              NBRA                        NBRAL
     I              NRTS                        NRTSL
     I              NSIN                        NSINL
     I              NCAS                        NCASL
     I              AWTP                        AWTPL
     I              WTRD                        WTRDL
     I              WTWD                        WTWDL
     I              IWOD                        IWODL
     I              PWOD                        PWODL
     I              BMDI                        BMDIL
     I              FMDI                        FMDIL
     I              PDIN                        PDINL
     I              LSWC                        LSWCL
     I              LSWS                        LSWSL
     I              OSDB                        OSDBL
     I              OMDB                        OMDBL
     I              ORBR                        ORBRL
     I              PRFC                        PRFCL
     I              FCLB                        FCLBL
     I              MLNR                        MLNRL
     I              BTIN                        BTINL
     I              BLDY                        BLDYL
     I              ICBS                        ICBSL
     I              IPFR                        IPFRL
     I              TOTI                        TOTIL
     I              NIDT                        NIDTL
     I              IBDT                        IBDTL
     I              SLID                        SLIDL
     I              AIPD                        AIPDL
     I              DLRC                        DLRCL
     I              IACD                        IACDL
     I              AITC                        AITCL
     I              TFEP                        TFEPL
     I              AIAP                        AIAPL
     I              IPRD                        IPRDL
     I              IPRM                        IPRML
     I              ICTD                        ICTDL
     I              AIMN                        AIMNL
     I              RBDT                        RBDTL
     I              NOPS                        NOPSL
     I              NCHI                        NCHIL
     I              ZZ001A                      ZZ00L
     I              IFDY                        IFDYL
     I              LONI                        LONIL
     I              CNFI                        CNFIL
     I              ACEI                        ACEIL
     I              TLXI                        TLXIL
     I              CBLI                        CBLIL
     I              ORED                        OREDL
     I              LCD                         LCDL
     I              CHTP                        CHTPL
     I              TNLU                        TNLUL
     I              ADDI                        ADDIL
     I              ORMD                        ORMDL
     I              ORTI                        ORTIL
     I              ZZ023A                      ZZ02L
     I              BOKC                        BOKCL
     I              COCU                        COCUL
     I              RECE                        RECEL
     I              OMDT                        OMDTL
     I              NIPD                        NIPDL
     I              NMDT                        NMDTL
     I              APMI                        APMIL
     I              RSTM                        RSTML
     I              RONS                        RONSL
     I              RIBN                        RIBNL
     I              RIBA                        RIBAL
     I              ROBN                        ROBNL
     I              ROCN                        ROCNL
     I              PSTM                        PSTML
     I              PONS                        PONSL
     I              PIBN                        PIBNL
     I              PIBA                        PIBAL
     I              POBN                        POBNL
     I              POCN                        POCNL
     I              RCRN                        RCRNL
     I              RCRA                        RCRAL
     I              RVNO                        RVNOL
     I              AWBN                        AWBNL
     I              AWBA                        AWBAL
     I              BENN                        BENNL
     I              BENA                        BENAL
     I              DTP1                        DTP1L
     I              DTP2                        DTP2L
     I              DTP3                        DTP3L
     I              DTP4                        DTP4L
     I              DCHG                        DCHGL
     I              BTB1                        BTB1L
     I              BTB2                        BTB2L
     I              BTB3                        BTB3L
     I              BTB4                        BTB4L
     I              BTB5                        BTB5L
     I              BTB6                        BTB6L
     I              CVMR                        CVMRL
     I              PTFR                        PTFRL
     I              HLEX                        HLEXL
     I              FSRP                        FSRPL
     I              FSGN                        FSGNL
     I              FPRC                        FPRCL
     I              TCOF                        TCOFL
     I              ACPD                        ACPDL
     I              ACDA                        ACDAL
     I              ACAJ                        ACAJL
     I              ACAP                        ACAPL
     I              COFD                        COFDL
     I              COFM                        COFML
     I              CFCD                        CFCDL
     I              NFRS                        NFRSL
     I              NFSN                        NFSNL
     I              NFPC                        NFPCL
     I              PDCF                        PDCFL
     I              FCTD                        FCTDL
     I              FWOD                        FWODL
     I              DFTP                        DFTPL
     I              DFST                        DFSTL
     I              MCRA                        MCRAL
     I              FCRA                        FCRAL
     I              PDDI                        PDDIL
     I              PTDI                        PTDIL
     I              GDPR                        GDPRL
     I              GDIN                        GDINL
     I              LNKS                        LNKSL
     I              MNSG                        MNSGL
     I              GASS                        GASSL
     I              GPRT                        GPRTL
     I              TOLN                        TOLNL
     I              LSTS                        LSTSL
     I              IUSR                        IUSRL
     I              AUSR                        AUSRL
     I              XUSR                        XUSRL
     I              RATF                        RATFL
     I              CNCF                        CNCFL
     I              PCRF                        PCRFL
     I              LPFI                        LPFIL
     I              PTFC                        PTFCL
     I              PTFT                        PTFTL
     I              PTFN                        PTFNL
     I              PCOB                        PCOBL
     I              LRLD                        LRLDL
     I              LMCD                        LMCDL
     I              SCCY                        SCCYL
     I              ICCY                        ICCYL
     I              OINR                        OINRL
     I              OIDT                        OIDTL
     I              REPI                        REPIL
     I              CLAS                        CLASL                                         CLE042
     I              DFCL                        DFCLL                                         CLE042
     IMCLONCLF
     I              RECI                        RECIL
     I              LNRF                        LNRFL
     I              RCDT                        RCDTL
     I              MRIN                        MRINL
     I              PTYP                        PTYPL
     I              CNUM                        CNUML
     I              BRCA                        BRCAL
     I              LTYP                        LTYPL
     I              SUTP                        SUTPL
     I              DDAT                        DDATL
     I              VDAT                        VDATL
     I              MDAT                        MDATM
     I              LASQ                        LASQL
     I              FCUS                        FCUSL
     I              FTYP                        FTYPL
     I              FSEQ                        FSEQL
     I              CCY                         CCYL
     I              CPAM                        CPAML
     I              INTC                        INTCL
     I              INTR                        INTRL
     I              BRTT                        BRTTM
     I              BRTE                        BRTEM
     I              RTSP                        RTSPM
     I              MARG                        MARGL
     I              SPIN                        SPINM
     I              CHIN                        CHINL
     I              WTRT                        WTRTL
     I              WTIN                        WTINL
     I              REPT                        REPTL
     I              RAMT                        RAMTL
     I              NRPD                        NRPDL
     I              RFRQ                        RFRQL
     I              RDYN                        RDYNL
     I              FCCY                        FCCYL
     I              LIND                        LINDL
     I              CRSK                        CRSKL
     I              ACOF                        ACOFL
     I              NACD                        NACDL
     I              RELI                        RELIL
     I              AUTO                        AUTOL
     I              PSAM                        PSAML
     I              BCXR                        BCXRL
     I              FCXR                        FCXRL
     I              SDST                        SDSTL
     I              OSDA                        OSDAL
     I              TSTN                        TSTNL
     I              MDST                        MDSTL
     I              OMDA                        OMDAL
     I              TMAN                        TMANL
     I              FACO                        FACOL
     I              RLDT                        RLDTL
     I              NROD                        NRODL
     I              RLFQ                        RLFQL
     I              RLDY                        RLDYL
     I              ZZ001                       ZZ00L
     I              NBRA                        NBRAL
     I              NRTS                        NRTSL
     I              NSIN                        NSINL
     I              NCAS                        NCASL
     I              AWTP                        AWTPL
     I              WTRD                        WTRDL
     I              WTWD                        WTWDL
     I              IWOD                        IWODL
     I              PWOD                        PWODL
     I              BMDI                        BMDIL
     I              FMDI                        FMDIL
     I              PDIN                        PDINL
     I              LSWC                        LSWCL
     I              LSWS                        LSWSL
     I              OSDB                        OSDBL
     I              OMDB                        OMDBL
     I              ORBR                        ORBRL
     I              PRFC                        PRFCL
     I              FCLB                        FCLBL
     I              MLNR                        MLNRL
     I              BTIN                        BTINL
     I              BLDY                        BLDYL
     I              ICBS                        ICBSL
     I              IPFR                        IPFRL
     I              TOTI                        TOTIL
     I              NIDT                        NIDTL
     I              IBDT                        IBDTL
     I              SLID                        SLIDL
     I              AIPD                        AIPDL
     I              DLRC                        DLRCL
     I              IACD                        IACDL
     I              AITC                        AITCL
     I              TFEP                        TFEPL
     I              AIAP                        AIAPL
     I              IPRD                        IPRDL
     I              IPRM                        IPRML
     I              ICTD                        ICTDL
     I              AIMN                        AIMNL
     I              RBDT                        RBDTL
     I              NOPS                        NOPSL
     I              NCHI                        NCHIL
     I              ZZ001A                      ZZ00L
     I              IFDY                        IFDYL
     I              LONI                        LONIL
     I              CNFI                        CNFIL
     I              ACEI                        ACEIL
     I              TLXI                        TLXIL
     I              CBLI                        CBLIL
     I              ORED                        OREDL
     I              LCD                         LCDL
     I              CHTP                        CHTPL
     I              TNLU                        TNLUL
     I              OLNRF                       OLNRL
     I              MLDAT                       MLDAL
     I              ZZ025A                      ZZ25L
     I              BOKC                        BOKCL
     I              COCU                        COCUL
     I              RECE                        RECEL
     I              OMDT                        OMDTL
     I              NIPD                        NIPDL
     I              NMDT                        NMDTL
     I              APMI                        APMIL
     I              RSTM                        RSTML
     I              RONS                        RONSL
     I              RIBN                        RIBNL
     I              RIBA                        RIBAL
     I              ROBN                        ROBNL
     I              ROCN                        ROCNL
     I              PSTM                        PSTML
     I              PONS                        PONSL
     I              PIBN                        PIBNL
     I              PIBA                        PIBAL
     I              POBN                        POBNL
     I              POCN                        POCNL
     I              RCRN                        RCRNL
     I              RCRA                        RCRAL
     I              RVNO                        RVNOL
     I              AWBN                        AWBNL
     I              AWBA                        AWBAL
     I              BENN                        BENNL
     I              BENA                        BENAL
     I              DTP1                        DTP1L
     I              DTP2                        DTP2L
     I              DTP3                        DTP3L
     I              DTP4                        DTP4L
     I              DCHG                        DCHGL
     I              BTB1                        BTB1L
     I              BTB2                        BTB2L
     I              BTB3                        BTB3L
     I              BTB4                        BTB4L
     I              BTB5                        BTB5L
     I              BTB6                        BTB6L
     I              CVMR                        CVMRL
     I              PTFR                        PTFRL
     I              HLEX                        HLEXL
     I              FSRP                        FSRPL
     I              FSGN                        FSGNL
     I              FPRC                        FPRCL
     I              TCOF                        TCOFL
     I              ACPD                        ACPDL
     I              ACDA                        ACDAL
     I              ACAJ                        ACAJL
     I              ACAP                        ACAPL
     I              COFD                        COFDL
     I              COFM                        COFML
     I              CFCD                        CFCDL
     I              NFRS                        NFRSL
     I              NFSN                        NFSNL
     I              NFPC                        NFPCL
     I              PDCF                        PDCFL
     I              FCTD                        FCTDL
     I              FWOD                        FWODL
     I              DFTP                        DFTPL
     I              DFST                        DFSTL
     I              MCRA                        MCRAL
     I              FCRA                        FCRAL
     I              PDDI                        PDDIL
     I              PTDI                        PTDIL
     I              GDPR                        GDPRL
     I              GDIN                        GDINL
     I              LNKS                        LNKSL
     I              MNSG                        MNSGL
     I              GASS                        GASSL
     I              GPRT                        GPRTL
     I              TOLN                        TOLNL
     I              LSTS                        LSTSL
     I              IUSR                        IUSRL
     I              AUSR                        AUSRL
     I              XUSR                        XUSRL
     I              RATF                        RATFL
     I              CNCF                        CNCFL
     I              PCRF                        PCRFL
     I              LPFI                        LPFIL
     I              PTFC                        PTFCL
     I              PTFT                        PTFTL
     I              PTFN                        PTFNL
     I              PCOB                        PCOBL
     I              LRLD                        LRLDL
     I              LMCD                        LMCDL
     I              SCCY                        SCCYL
     I              ICCY                        ICCYL
     I              OINR                        OINRL
     I              OIDT                        OIDTL
     I              REPI                        REPIL
     I              RFDY                        RFDYL
     I              RFRI                        RFRIL
     I              RFRT                        RFRTL
     I              RFAR                        RFARL
     I              CLAS                        CLASL                                         CLE042
     I              DFCL                        DFCLL                                         CLE042
      /EJECT
      *
      ** Initialisation subroutine
      *
     C                   EXSR      SRINIT
      *
     C                   READ      MATLNHPF                               03
      *
     C     *IN03         DOWEQ     *OFF
     C                   MOVE      *OFF          *IN02
     C                   MOVE      *OFF          *IN05
     C                   MOVE      *OFF          *IN07
     C                   MOVE      *OFF          *IN14
      *
     C     LCDM          IFGE      BEGDAT
     C     LCDM          ANDLE     ENDDAT
     C     KEYA          CHAIN     CLOANCLF                           06
      *
     C     *IN06         IFEQ      *ON
     C     KEYA          CHAIN     MCLONCLF                           08
     C                   ENDIF
      *
     C     BRCAM         IFNE      WBRCA
     C                   MOVE      *ON           *IN02
     C                   EXSR      SRNBRC
     C                   MOVE      BRCAM         WBRCA
     C                   MOVE      'Y'           P1WR              1
     C                   ENDIF
      *
     C                   MOVE      BRCAM         @BRCA
     C                   MOVE      CNUMM         @CNUM
     C                   MOVE      LNRFM         @LNRF
     C**********         MOVE      LNRFM         WLNRF             6 0                        CLE148
     C                   MOVE      LNRFM         WLNRF                                        CLE148
     C     CHNHST        SETLL     HISTR
     C     CHNHST        READE     HISTR                                  04
     C                   MOVE      *BLANKS       WHSUTP            2
     C                   MOVE      *BLANKS       WHCLAS            4                          CLE042
      *
     C     LNRFH         DOWEQ     WLNRF
     C     *IN04         ANDEQ     *OFF
      *
     C     AMTP          IFEQ      'ST'
     C                   MOVE      *ON           *IN05
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN24
     C                   MOVE      *OFF          *IN25
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *OFF          *IN27
     C                   MOVE      *OFF          *IN49
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN20
     C     AITCL         ADD       AIAPL         TINT             13 0
     C                   EXSR      MATPRO
     C                   EXSR      CARD
     C                   ENDIF
      *
     C     AMTP          IFEQ      'RE'
     C     AMTP          OREQ      'MR'
     C     AMTP          OREQ      'PI'
     C     AMTP          OREQ      'IN'
     C     AMTP          OREQ      'MI'
     C     AMTP          OREQ      'MA'
     C     AMTP          OREQ      'LS'
     C     AMTP          OREQ      'PT'
     C     AMTP          OREQ      'PF'
     C                   MOVE      *ON           *IN07
     C                   EXSR      CARD
     C                   ENDIF
      *
     C     AMTP          IFEQ      'SC'
     C     AMTP          OREQ      'BC'
     C     AMTP          OREQ      'BR'
     C     AMTP          OREQ      'RO'
     C     AMTP          OREQ      'SA'
     C     AMTP          OREQ      'MC'
     C                   MOVE      *ON           *IN14
     C                   EXSR      CARD
     C                   ENDIF
      *
     C                   MOVE      SUTPH         WHSUTP
     C                   MOVE      CLASH         WHCLAS                                       CLE042
     C                   READ      HISTR                                  04
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   READ      MATLNHPF                               03
     C                   ENDDO
      *
     C     P1WR          IFNE      'Y'
     C                   OPEN      LE0900P1
     C                   Z-ADD     0             PAGE
     C                   MOVE      *ON           *IN21
     C                   MOVE      *ON           *INLR
     C                   MOVE      *OFF          *IN20
     C                   EXCEPT
     C                   ENDIF
      *
     C     *IN03         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      /EJECT
      *****************************************************************
      *  SRINIT - Initialisation subroutine                           *
      *  Called by:  Main Processing                                  *
      *  Calls: AOBANKR0                                              *
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Initialise LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   MOVE      'ALL'         BRNCH             3
     C                   EXSR      ZSYSTM
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'LE0901'      DBPGM
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *IN99
     C                   MOVE      'LE0901'      DBPGM
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   MOVEL     @OPTN         DBOPTN                         * DBERR 15 *
     C                   Z-ADD     15            DBASE                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if CLE005 is switched *ON
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*VERIFY'     WOPTN             7
     C                   PARM      'CLE005'      WSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ELSE
      *
      ** Call to program ended in error
      *
     C     WRTCD         IFNE      '*NRF   '
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *IN99
     C                   MOVE      'LE0901'      DBPGM
     C                   MOVEL     'CLE005'      DBKEY                          ************
     C                   MOVEL     WOPTN         DBOPTN                         * DBERR 07 *
     C                   Z-ADD     007           DBASE                          ************
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CLE005        IFEQ      'Y'
     C                   MOVE      *ON           *IN30
     C                   ENDIF
      *
      ** Access SAR details to check if 'Customer Closing' is
      ** installed.
      *
     C                   MOVE      'N'           CSD007            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM      'CSD007'      WSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     WRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD007
     C                   ELSE
      *
      ** Call to program ended in error
      *
     C     WRTCD         IFNE      '*NRF   '
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'CSD007'      DBKEY
     C                   MOVEL     WOPTN         DBOPTN
     C                   Z-ADD     008           DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if CLE028 is switched *ON
      *
     C                   MOVE      'N'           CLE028            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CLE028'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE028
     C                   ELSE
      *
      ** Call to program ended in error
      *
     C     PRTCD         IFNE      '*NRF   '
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *IN99
     C                   MOVEL     PSARD         DBKEY
     C                   MOVEL     POPTN         DBOPTN
     C                   Z-ADD     009           DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Data area rundat
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      *
     C     MBIN          IFEQ      'Y'
     C                   MOVE      *ON           *IN35
     C                   ENDIF
      *
      ** Obtain five figure day no. of first and last day
      *  of this month
     C                   Z-ADD     1             X                 2 0
     C     WMNT          LOOKUP    ZMNM(X)                                40
     C     *IN40         IFEQ      *ON
     C     BJDFIN        IFEQ      'M'                                                        247682
     C                   MOVEL     X             WOR               4 0
     C                   MOVE      '01'          WOR                                          247682
     C                   ELSE                                                                 247682
     C                   MOVE      X             WOR                                          247682
     C                   MOVEL     '01'          WOR                                          247682
     C                   ENDIF                                                                247682
     C**********         MOVE      WYER          WOR                                          247682
     C                   ENDIF
     C**********         MOVE      WOR           WOR1              6 0                        247682
     C**********         MOVEL     '01'          WOR1                                         247682
     C                   MOVEL     WOR           WOR1              6 0                        247682
     C                   MOVE      WYER          WOR1                                         247682
      *
      ** Convert first of month to day no.
      *
     C                   MOVE      *OFF          *IN98
     C                   MOVE      WOR1          ZDATEI
      *
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     ZDAYNO        BEGDAT            5 0
      *
      ** Convert last of month to day no.
      *
     C**********         MOVEL     ZFMD(X)       WOR1                                         247682
     C     BJDFIN        IFEQ      'D'                                                        247682
     C                   MOVEL     ZFMD(X)       WOR                                          247682
     C                   ELSE                                                                 247682
     C                   MOVE      ZFMD(X)       WOR                                          247682
     C                   ENDIF                                                                247682
      *
      ** If Feb, check if leap year
      *
     C     X             IFEQ      2
     C     ZFMD(X)       ANDEQ     '28'
     C     WYER          DIV       4             WOR2              2 0
     C                   MVR                     WOR3              2 0
     C     WOR3          IFEQ      0
     C**********         MOVEL     '29'          WOR1                                         247682
     C     BJDFIN        IFEQ      'D'                                                        247682
     C                   MOVEL     '29'          WOR                                          247682
     C                   ELSE                                                                 247682
     C                   MOVE      '29'          WOR                                          247682
     C                   ENDIF                                                                247682
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     WOR           WOR1                                         247682
     C                   MOVE      WOR1          ZDATEI
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        ENDDAT            5 0
      *
      ** Reset date format indicator
      *
     C     DATF          IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
      ** Setup work variables
      *
     C                   MOVE      ' '           BLANKS            7
     C                   MOVE      *BLANKS       WBRCA             3
     C                   MOVE      'A'           WRCTP             1
     C     *LIKE         DEFINE    BRCAM         @BRCA
     C     *LIKE         DEFINE    CNUMM         @CNUM
     C     *LIKE         DEFINE    LNRFM         @LNRF
     C     CHNHST        KLIST
     C                   KFLD                    @BRCA
     C                   KFLD                    @CNUM
     C                   KFLD                    @LNRF
     C     KEYA          KLIST
     C                   KFLD                    LNRFM
     C                   KFLD                    WRCTP
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  ZSYSTM - Subroutine to chain the installation control data.  *
      *  Called by: SRINIT                                            *
      *  Calls: Nothing                                               *
      *****************************************************************
     C     ZSYSTM        BEGSR
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *IN99
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVE      'LE0901'      DBPGM
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   MOVEL     @OPTN         DBOPTN            7            * DBERR 01 *
     C                   Z-ADD     1             DBASE                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Check system date format, DDMMYY or MMDDYY.
      *
     C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON
     C                   END
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  *PSSR - Subroutine to handle abnormal error conditions       *
      *  Called by:                                                   *
      *  Calls: Nothing                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   RETURN
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRNBRC - Write branch header subroutine                      *
      *  Called by:  Main Processing                                  *
      *  Calls: AOBANKR0                                              *
      *****************************************************************
      *
      ** Multibranching output test
      *
     C     SRNBRC        BEGSR
      *
     C     P1OP          IFEQ      'Y'
     C                   MOVE      *ON           *IN11
     C                   EXCEPT
     C                   MOVE      *OFF          *IN11
     C                   ENDIF
      *
     C     *IN02         IFEQ      *ON
     C                   MOVE      *OFF          *IN20
     C                   CLOSE     LE0900P1
     C     BRNCH         IFEQ      'ALL'
     C     MBIN          ANDEQ     'Y'
     C     BRNCH         OREQ      BRCAH
     C     MBIN          ANDEQ     'Y'
     C     MBIN          ORNE      'Y'
     C                   MOVE      *ON           *IN21
     C                   MOVE      'Y'           P1OP              1
     C                   OPEN      LE0900P1
     C                   Z-ADD     0             PAGE
      *
      ** Ensure report spool file recorded by RCF
      *
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   OUT       LDA
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ               5
     C                   PARM      BRCAH         SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
     C     *LOCK         IN        LDA
      *
      ** Error during ZSFILE processing, return to calling program
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
     C     MBIN          IFEQ      'Y'
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRCAM         @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVEL     @DSNB         DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   Z-ADD     6             DBASE                          * DBERR 06 *
     C                   MOVEL     @OPTN         DBOPTN            7            ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *OFF          *IN21
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  MATPRO - Matured Loan Header                                 *
      *  Called By: Main Processing                                   *
      *  Calls : ZDATE2                                               *
      *****************************************************************
     C     MATPRO        BEGSR
      *
     C     INTC          IFEQ      'Y'
     C                   MOVE      *ON           *IN83
     C                   ENDIF
      *
     C     *IN05         IFEQ      *ON
      *
      ** Check for parts purch without recourse and enter customer
      ** number accordingly ie OLNO if parts purchased w/o recourse.
      *
     C     PTYPM         IFEQ      64
     C     RCSI          ANDNE     'Y'
     C     PTYPM         OREQ      65
     C     RCSI          ANDNE     'Y'
      *
      ** If CLE005 is *ON, include new Parts Purchased-processing types
      *
     C     CLE005        OREQ      'Y'
     C     PTYPM         ANDEQ     68
     C     RCSI          ANDNE     'Y'
     C     CLE005        OREQ      'Y'
     C     PTYPM         ANDEQ     71
     C     RCSI          ANDNE     'Y'
      *
     C                   MOVEL     OLNO          CLIKEY           10
     C                   ELSE
     C                   MOVEL     CNUMH         CLIKEY           10
     C                   END
     C                   CALL      'AOCUSTR2'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CLIKEY
     C                   PARM      '*CNUM  '     KEYSTS            7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     CSD007        ANDNE     'Y'
     C     @RTCD         ORNE      *BLANKS
     C     @RTCD         ANDEQ     '*NRF   '
     C     BBDTDL        ANDNE     *ZEROS
     C     CSD007        ANDEQ     'Y'
     C     @RTCD         ORNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     CSD007        ANDEQ     'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   MOVE      'SDCUSTPD'    DBFILE                         ************
     C                   Z-ADD     4             DBASE                          * DBERR 04 *
     C                   MOVEL     CLIKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If participations purchase with recourse, print original
      ** borrower
      *
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      71
     C     CLE005        ANDEQ     'Y'
      *
     C     RCSI          IFEQ      'Y'
     C                   MOVE      *ON           *IN84
     C                   MOVEL     OLNO          CLIKEY
     C                   CALL      'AOCUSTR2'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CLIKEY
     C                   PARM      '*CNUM  '     KEYSTS            7
     C     SDCUST        PARM      SDCUST        DSLDY
     C                   MOVEL     CRNM          CRNM2            20
     C                   MOVEL     CTWN          CTWN2            10
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Zeroise card page count
      *
     C     *IN05         IFEQ      *ON
     C                   Z-ADD     0             PAGE2
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SDCURRPD file for decimal places
      *
     C                   MOVEL     CCYH          TKEY              3
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    TKEY                                       A
     C     SDCURR        PARM      SDCURR        DSSDY                                      B
      *
      ** Database error if live record not found
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     5             DBASE                          * DBERR 05 *
     C                   MOVE      TKEY          DBKEY                          ************
     C                   MOVE      @OPTN         DBOPTN            7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine no of decimals 24=0 25=1 26=2 27=3
      *
     C                   MOVE      *OFF          *IN24
     C                   MOVE      *OFF          *IN26
     C                   MOVE      *OFF          *IN27
     C     CDP           IFEQ      1
     C                   MOVE      *ON           *IN25
     C                   ENDIF
      *
     C     CDP           IFLT      1
     C                   MOVE      *ON           *IN24
     C                   ENDIF
      *
     C     CDP           IFEQ      2
     C                   MOVE      *ON           *IN26
     C                   ENDIF
      *
     C     CDP           IFGT      2
     C                   MOVE      *ON           *IN27
     C                   ENDIF
      *
      ** Convert header dates
      *
     C     VDATH         IFGT      0
     C                   MOVE      *ON           *IN48
     C                   ENDIF
      *
     C     *IN48         IFEQ      *ON
     C                   Z-ADD     VDATH         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        VDATE             7
     C                   ELSE
     C                   MOVE      BLANKS        VDATE
     C                   ENDIF
      *
     C     MDATM         IFGT      0
     C                   MOVE      *ON           *IN49
     C                   ENDIF
      *
     C     *IN49         IFEQ      *ON
     C                   Z-ADD     MDATM         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        MATDE             7
     C                   ELSE
     C                   MOVE      BLANKS        MATDE
     C                   ENDIF
      *
      ** Assign spread ind. and calc interest rate spread
      *
     C     SPINM         IFEQ      'A'
     C                   MOVE      *ON           *IN52
     C                   ENDIF
      *
     C     SPINM         IFEQ      'S'
     C                   MOVE      *ON           *IN53
     C                   ENDIF
      *
     C     SPINM         IFEQ      'P'
     C                   MOVE      *ON           *IN54
     C                   ENDIF
      *
     C                   Z-ADD     BRTEM         INTRC            11 7                INT RATE
      *
     C     *IN52         IFEQ      *ON
     C     INTRC         ADD       RTSPM         INTRC
     C                   ENDIF
      *
     C     *IN53         IFEQ      *ON
     C     INTRC         SUB       RTSPM         INTRC
     C                   ENDIF
      *
     C     *IN54         IFEQ      *ON
     C     INTRC         DIV(H)    100           WRK              11 9
     C     WRK           MULT(H)   RTSPM         INTRC
     C                   ENDIF
      *
      ** Output headings
      *
     C                   MOVE      *ON           *IN46
     C                   MOVE      *ON           *IN20
     C                   EXCEPT
     C                   MOVE      *OFF          *IN46
      *
      ** Set off Original Borrower field
      *
     C                   MOVE      *OFF          *IN84
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  CARD - Matured loan amount/rates lines                       *
      *  Called By: Main Processing                                   *
      *  Calls : ZDATE2(2)                                            *
      *****************************************************************
     C     CARD          BEGSR
      *
     C     EXVD          IFGT      0
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
     C     *IN50         IFEQ      *ON
     C                   Z-ADD     EXVD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        EXVDE             7
     C                   ELSE
     C                   MOVE      BLANKS        EXVDE
     C                   ENDIF
      *
     C     VDAT          IFGT      0
     C                   MOVE      *ON           *IN51
     C                   ENDIF
      *
     C     *IN51         IFEQ      *ON
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        VDATD             7
     C                   ELSE
     C                   MOVE      BLANKS        VDATD
     C                   ENDIF
      *
      ** Process according to amendment type
      ** Base Rate Code Change
      *
     C     AMTP          IFEQ      'BC'
     C                   MOVE      NARR(1)       NARRA            30
     C                   Z-ADD     BRTE          PRATE            11 7
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *
      ** Base Rate Change
      *
     C     AMTP          IFEQ      'BR'
     C                   MOVE      NARR(2)       NARRA
     C                   Z-ADD     BRTE          PRATE
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *
      ** Interest Payment or Capitalised
      *
     C     AMTP          IFEQ      'IN'
      *
     C     CLE028        IFEQ      'Y'
     C     PTYP          ANDEQ     80
     C                   MOVE      NARR(40)      NARRA
     C                   ELSE
     C     PRAM          IFEQ      0
     C                   MOVE      *ON           *IN58
     C                   MOVE      NARR(3)       NARRA
     C                   ELSE
     C                   MOVE      *ON           *IN59
     C                   MOVE      NARR(4)       NARRA
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     INTA          PAMT             13 0
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN59
     C                   ENDIF
      *
      ** Maturity - Principal, Interest, Withholding Tax
      *
     C     AMTP          IFEQ      'MA'
      *
     C     *IN23         IFEQ      *OFF
     C                   MOVE      NARR(5)       NARRA
     C                   ELSE
     C                   MOVE      NARR(32)      NARRA
     C                   ENDIF
      *
     C                   Z-ADD     PRAM          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
      *
     C     INTA          IFNE      0
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
     C     *IN60         IFEQ      *ON
      *
      ** If interest capitalised, move in relevant narrative.
      *
     C     *IN83         IFEQ      *ON
     C                   MOVE      NARR(31)      NARRA
     C                   ELSE
     C                   MOVE      NARR(6)       NARRA
     C                   ENDIF
      *
     C                   Z-ADD     INTA          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
      *
     C     WTXA          IFNE      0
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *
     C     *IN61         IFEQ      *ON
     C                   MOVE      NARR(7)       NARRA
     C                   Z-ADD     WTXA          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN61
      *
      ** If interest is capitalised, only output principal portion
      ** to month's history file.
      *
     C     *IN83         IFEQ      *ON
     C     PRAM          SUB       INTA          PRAM
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Manual Interest Adjustment
      ** If Analytical Accounting is present - only report 'MI'
      ** amendments when interest adjustment amount is not Zero
      *
     C     AMTP          IFEQ      'MI'
     C                   MOVE      *ON           *IN56
      *
     C     BGN0ST        IFEQ      'Y'
     C     *IN56         IFEQ      *ON
     C     INTA          ANDEQ     *ZERO
     C                   MOVE      *OFF          *IN56
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN56         IFEQ      *ON
     C                   MOVE      NARR(8)       NARRA
     C                   Z-ADD     INTA          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Manual Repayment - Principal, Interest, Withholding Tax, Fee
      *
     C     AMTP          IFEQ      'MR'
      *
     C     PRAM          IFNE      0
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *
     C     *IN62         IFEQ      *ON
     C                   MOVE      NARR(9)       NARRA
     C                   Z-ADD     PRAM          PAMT
     C                   MOVE      *OFF          *IN62
      *
     C     *IN50         IFEQ      *ON
     C     VDAT          SUB       EXVD          DPDU              3 063
     C                   ELSE
     C                   MOVEL     '   -'        EXVDE
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN57
     C                   MOVE      *ON           *IN64
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *
     C     INTA          IFNE      0
     C                   MOVE      *ON           *IN65
     C                   ENDIF
      *
     C     *IN65         IFEQ      *ON
     C                   MOVE      NARR(10)      NARRA
     C                   Z-ADD     INTA          PAMT
     C                   MOVE      *OFF          *IN65
      *
     C     *IN50         IFEQ      *ON
     C     VDAT          SUB       EXVD          DPDU                 63
     C                   ELSE
     C                   MOVEL     '   -'        EXVDE
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN57
     C                   MOVE      *ON           *IN64
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *
     C     WTXA          IFNE      0
     C                   MOVE      *ON           *IN66
     C                   ENDIF
      *
     C     *IN66         IFEQ      *ON
     C                   MOVE      NARR(11)      NARRA
     C                   Z-ADD     WTXA          PAMT
     C                   MOVE      *OFF          *IN66
      *
     C     *IN50         IFEQ      *ON
     C     VDAT          SUB       EXVD          DPDU                 63
     C                   ELSE
     C                   MOVEL     '   -'        EXVDE
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN57
     C                   MOVE      *ON           *IN64
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *
     C     FEAM          IFNE      0
     C                   MOVE      *ON           *IN67
     C                   ENDIF
      *
     C     *IN67         IFEQ      *ON
     C                   Z-ADD     FEAM          PAMT
     C                   MOVE      NARR(12)      NARRA
     C                   MOVE      FECD          NARRA
     C                   MOVE      *OFF          *IN67
      *
     C     *IN50         IFEQ      *ON
     C     VDAT          SUB       EXVD          DPDU                 63
     C                   ELSE
     C                   MOVEL     '   -'        EXVDE
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN57
     C                   MOVE      *ON           *IN64
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Principal Transfer - OUT
      *
     C     AMTP          IFEQ      'PF'
     C                   MOVE      NARR(37)      NARRA
     C                   Z-ADD     PRAM          PAMT
     C                   MOVE      *ON           *IN57
     C                   MOVE      *ON           *IN87
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN87
     C                   ENDIF
      *
      ** Principal Transfer - IN
      *
     C     AMTP          IFEQ      'PT'
     C                   MOVE      NARR(38)      NARRA
     C                   Z-ADD     PRAM          PAMT
     C                   MOVE      *ON           *IN57
     C                   MOVE      *ON           *IN88
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN88
     C                   ENDIF
      *
      ** Principal Increase
      *
     C     AMTP          IFEQ      'PI'
     C                   MOVE      NARR(13)      NARRA
     C                   Z-ADD     PRAM          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *
      ** Repayment - Principal, Interest, Withholding Tax
      *
     C     AMTP          IFEQ      'RE'
      *
     C     PRAM          IFNE      0
     C                   MOVE      *ON           *IN68
     C                   ENDIF
      *
     C     *IN68         IFEQ      *ON
     C                   MOVE      NARR(14)      NARRA
     C                   Z-ADD     PRAM          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN68
     C                   ENDIF
      *
     C     INTA          IFNE      0
     C                   MOVE      *ON           *IN69
     C                   ENDIF
      *
     C     *IN69         IFEQ      *ON
     C                   MOVE      NARR(15)      NARRA                              REPAY INT
     C                   Z-ADD     INTA          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN69
     C                   ENDIF
      *
     C     WTXA          IFNE      0
     C                   MOVE      *ON           *IN70
     C                   ENDIF
      *
     C     *IN70         IFEQ      *ON
     C                   MOVE      NARR(16)      NARRA
     C                   Z-ADD     WTXA          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN70
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Rollover - Base Rate, Spread-Add,Sub,Percentage
      *
     C     AMTP          IFEQ      'RO'
      *
     C     BRTE          IFEQ      0
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
     C     BRTE          IFGT      0
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
     C     *IN72         IFEQ      *ON
     C     RTSP          IFGT      0
     C                   MOVE      *ON           *IN73
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN71         IFEQ      *ON
     C                   MOVE      NARR(17)      NARRA
     C                   Z-ADD     BRTE          PRATE
     C                   ENDIF
      *
     C     *IN73         IFEQ      *ON
     C                   MOVE      NARR(18)      NARRA
     C                   Z-ADD     RTSP          PRATE
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
      *
     C     *IN71         IFEQ      *ON
     C     *IN73         OREQ      *ON
     C                   EXCEPT
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
      *
     C     *IN71         IFEQ      *ON
     C     RTSP          IFGT      0
     C                   MOVE      *ON           *IN74
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN74         IFEQ      *ON
     C     *IN52         ANDEQ     *ON
     C                   MOVE      NARR(19)      NARRA
     C                   ENDIF
      *
     C     *IN74         IFEQ      *ON
     C     *IN53         ANDEQ     *ON
     C                   MOVE      NARR(20)      NARRA
     C                   ENDIF
      *
     C     *IN74         IFEQ      *ON
     C     *IN54         ANDEQ     *ON
     C                   MOVE      NARR(21)      NARRA
     C                   ENDIF
      *
     C     *IN74         IFEQ      *ON
     C                   Z-ADD     RTSP          PRATE
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN71
     C                   MOVE      *OFF          *IN72
     C                   MOVE      *OFF          *IN73
     C                   MOVE      *OFF          *IN74
     C                   ENDIF
      *
      ** Start/Stop Accruals
      *
     C     AMTP          IFEQ      'SA'
     C     STAI          IFEQ      'Y'
     C                   MOVE      *ON           *IN75
     C                   MOVE      NARR(22)      NARRA
     C                   ENDIF
      *
     C     STAI          IFEQ      ' '
     C                   MOVE      *ON           *IN76
     C                   MOVE      NARR(23)      NARRA
     C                   ENDIF
      *
     C                   Z-ADD     0             PRATE
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN75
     C                   MOVE      *OFF          *IN76
     C                   ENDIF
      *
      **  If Analytical Accounting is present - only report 'SC'
      **  amendments w/ a change to the interest rate/spread (flag = Y)
      *
     C     AMTP          IFEQ      'SC'
     C                   MOVE      *ON           *IN56
      *
     C     BGN0ST        IFEQ      'Y'
     C     *IN56         IFEQ      *ON
     C     IRCF          ANDNE     'Y'
     C                   MOVE      *OFF          *IN56
     C                   ENDIF
     C                   ENDIF
      *
      ** Spread Change
      *
     C     *IN56         IFEQ      *ON
     C                   MOVE      NARR(24)      NARRA
     C                   Z-ADD     RTSP          PRATE
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
     C                   ENDIF
      *
      ** Start - Principal, Base Rate, Rate, Spread-Add,Sub,Percentage **
      *
     C     AMTP          IFEQ      'ST'
     C                   MOVE      VDATE         VDATD
     C     TOTI          IFGT      0
     C                   MOVE      *ON           *IN23
     C                   ENDIF
      *
     C     TOTI          IFLT      0
     C                   MOVE      *ON           *IN22
     C                   ENDIF
      *
     C     *IN22         IFEQ      *OFF
     C     *IN23         ANDEQ     *OFF
     C                   MOVE      NARR(25)      NARRA
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON
     C     *IN23         OREQ      *ON
     C                   MOVE      NARR(33)      NARRA
     C                   ENDIF
      *
     C                   Z-ADD     PRAMH         PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
      *
     C     *IN22         IFEQ      *ON
     C                   MOVE      NARR(34)      NARRA
     C                   Z-SUB     TOTI          PAMT
     C                   ENDIF
      *
     C     *IN23         IFEQ      *ON
     C                   MOVE      NARR(35)      NARRA
     C                   Z-ADD     TOTI          PAMT
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON
     C                   MOVE      *ON           *IN23
     C                   ENDIF
      *
     C     *IN23         IFEQ      *ON
     C                   MOVE      *ON           *IN57
     C                   ENDIF
      *
     C                   EXCEPT
     C                   MOVE      *OFF          *IN22
     C                   MOVE      *OFF          *IN23
     C                   MOVE      *OFF          *IN57
      *
     C     BRTEH         IFGT      0
     C                   MOVE      *ON           *IN77
     C                   ENDIF
      *
     C     BRTEH         IFEQ      0
     C                   MOVE      *ON           *IN78
     C                   ENDIF
      *
     C     *IN77         IFEQ      *ON
     C                   MOVE      NARR(26)      NARRA
     C                   Z-ADD     BRTEH         PRATE
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
      *
     C     *IN78         IFEQ      *ON
     C     RTSP          IFGT      0
     C                   MOVE      *ON           *IN79
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN79         IFEQ      *ON
     C                   MOVE      NARR(27)      NARRA
     C                   Z-ADD     RTSP          PRATE
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
      *
     C     *IN77         IFEQ      *ON
     C     RTSP          IFGT      0
     C                   MOVE      *ON           *IN80
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN80         IFEQ      *ON
     C                   Z-ADD     RTSP          PRATE
     C                   ENDIF
      *
     C     *IN80         IFEQ      *ON
     C     *IN52         ANDEQ     *ON
     C                   MOVE      NARR(28)      NARRA
     C                   ENDIF
      *
     C     *IN80         IFEQ      *ON
     C     *IN53         ANDEQ     *ON
     C                   MOVE      NARR(29)      NARRA
     C                   ENDIF
      *
     C     *IN80         IFEQ      *ON
     C     *IN54         ANDEQ     *ON
     C                   MOVE      NARR(30)      NARRA
     C                   ENDIF
      *
     C     *IN80         IFEQ      *ON
     C                   MOVE      *ON           *IN55
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   ENDIF
      *
      ** If processing type is 'CH', report charges added-on
      *
     C     CLE028        IFEQ      'Y'
     C     AMTP          ANDEQ     'CH'
     C     PTYP          ANDEQ     80
     C                   MOVE      *ON           *IN56
     C                   MOVE      NARR(39)      NARRA
     C                   Z-ADD     CHDU          PAMT
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN77
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *OFF          *IN79
     C                   MOVE      *OFF          *IN80
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   ENDIF
      *
      ** Check for Loan Sub-Type Change and condition output
      ** for report
      *
     C     AMTP          IFEQ      'LS'
     C                   MOVE      *ON           *IN10
     C                   MOVE      NARR(36)      NARRA
     C*******************MOVE      '   TO   '    NAREND            8                          CLE042
     C*******************MOVEL     WHSUTP        NAREND                                       CLE042
     C*******************MOVE      SUTPH         NAREND                                       CLE042
     C                   MOVEL     '       TO'   NAREND           16                          CLE042
     C                   MOVEL     WHSUTP        WKSTCL            6                          CLE042
     C                   MOVE      WHCLAS        WKSTCL                                       CLE042
     C                   MOVEL     WKSTCL        NAREND                                       CLE042
     C                   MOVEL     SUTPH         WKSTCL                                       CLE042
     C                   MOVE      CLASH         WKSTCL                                       CLE042
     C                   MOVE      WKSTCL        NAREND                                       CLE042
     C                   MOVE      NAREND        NARRA
     C                   MOVE      *ON           *IN57
     C                   EXCEPT
     C                   MOVE      *OFF          *IN10
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      *****************************************************************
      /EJECT
     O*****************************************************************
     OLE0900P1  D    OF 21                  2 03
     O                                           13 'REF  LE0900P1'
     O                       TITL                67
     O                                           71 'DATE'
     O                       RUNA                79
     O                                           84 'PAGE'
     O                       PAGE                89
      *
     O          D    OF 21                  1
     O                                           46 'HISTORY CARD'
     O               35                          55 'BRANCH'
     O               35      BRCAH               59
     O               35                          60 '-'
     O               35      BRNM                90
      *
     O          D    OF 21                  2
     O                                           46 '------------'
      *
     O          D    OF 21                  2
     O                                            7 'LOAN NO'
     O                       LNRFH               15
     O                                           26 'PAGE NO'
     O                       PAGE2               33
      *
     O          D    OF 21                  1
     O                                            8 'CUSTOMER'
     O                       CRNM                30
     O               84                          56 'ORIG BORROWER'
     O               84      CRNM2               78
      *
     O          D    OF 21                  1
     O                       CTWN                20
     O              N30      CNUMH               30
     O               30      CLIKEY              30
     O               84      CTWN2               53
     O               84      OLNO                78
      *
     O          D    OF 21               1  1
     O                                           87 'NO. OF'
      *
     O          D    OF 21                  1
     O                                            8 'DUE DATE'
     O                                           24 'EFFECTIVE DATE'
     O                                           42 'NARRATIVE'
     O                                           71 'AMOUNT'
     O                                           86 'DAYS'
      *
     O          D    OF 21                  2
     O                                           88 'PAST DUE'
      *
     O          E    46 21                  2 03
     O                                           13 'REF  LE0900P1'
     O                       TITL                66
     O                                           71 'DATE'
     O                       RUNA                79
     O                                           84 'PAGE'
     O                       PAGE                89
      *
     O          E    46 21                  1
     O                                           46 'HISTORY CARD'
     O               35                          55 'BRANCH'
     O               35      BRCAH               59
     O               35                          60 '-'
     O               35      BRNM                90
      *
     O          E    46 21                  2
     O                                           46 '------------'
      *
     O          E    46 21                  2
     O                                            7 'LOAN NO'
     O                       LNRFH               15
     O                                           26 'PAGE NO'
     O                       PAGE2               33
      *
     O          E    46 21                  1
     O                                            8 'CUSTOMER'
     O                       CRNM                34
     O                                           59 'CMMT/FACILITY NO'
     O                       FTYPH               85
     O                                           86 '/'
     O                       FSEQH               88
      *
     O          E    46 21                  1
     O                       CTWN                24
     O              N30      CNUMH               31
     O               30      CLIKEY              31
     O                                           51 'INT RATE'
     O                       INTRC               88 '  0 .       '
      *
     O          E    46 21 84               1
     O                                           13 'ORIG BORROWER'
     O                       CRNM2               34
      *
     O          E    46 21 84               1
     O                       CTWN2               24
     O                       OLNO                31
      *
     O          E    46 21                  1
     O                                           18 'LOAN TYPE/SUB TYPE'
     O                       LTYPH               27
     O                                           28 '-'
     O                       SUTPH               30
     O                       CLASH               34                                           CLE042
     O                                           57 'BASE RATE CODE'
     O                       BRTTM               88
      *
     O          E    46 21                  1
     O                                           49 'SPREAD'
     O                       RTSPM               87 '  0 .       '
     O               52                          88 '+'
     O               53                          88 '-'
     O               54                          88 '%'
      *
     O          E    46 21                  1
     O                                           11 'ORIG AMOUNT'
     O                  24   PRAMH               40 ' ,   ,   ,   , 0 '
     O                  25   PRAMH               40 '   ,   ,   , 0 . '
     O                  26   PRAMH               40 '  ,   ,   , 0 .  '
     O                  27   PRAMH               40 ' ,   ,   , 0 .   '
      *
     O          E    46 21                  1
     O                                            3 'CCY'
     O                       CCYH                40
     O                                           65 'TOTAL ACCRUED INTEREST'
     O                  24   TINT                88 ' ,   ,   ,   , 0 '
     O                  25   TINT                88 '   ,   ,   , 0 . '
     O                  26   TINT                88 '  ,   ,   , 0 .  '
     O                  27   TINT                88 ' ,   ,   , 0 .   '
      *
     O          E    46 21                  1
     O                                           56 'INTEREST PAID'
     O                  24   IPRDL               88 ' ,   ,   ,   , 0 '
     O                  25   IPRDL               88 '   ,   ,   , 0 . '
     O                  26   IPRDL               88 '  ,   ,   , 0 .  '
     O                  27   IPRDL               88 ' ,   ,   , 0 .   '
      *
     O          E    46 21                  1
     O                                           10 'START DATE'
     O                       VDATE               40
     O                                           63 'INTEREST CAPITALISED'
     O                  24   ICTDL               88 ' ,   ,   ,   , 0 '
     O                  25   ICTDL               88 '   ,   ,   , 0 . '
     O                  26   ICTDL               88 '  ,   ,   , 0 .  '
     O                  27   ICTDL               88 ' ,   ,   , 0 .   '
      *
     O          E    46 21                  1
     O                                           13 'MATURITY DATE'
     O                       MATDE               40
     O                                           63 'INTEREST WRITTEN OFF'
     O                  24   IWODL               88 ' ,   ,   ,   , 0 '
     O                  25   IWODL               88 '   ,   ,   , 0 . '
     O                  26   IWODL               88 '  ,   ,   , 0 .  '
     O                  27   IWODL               88 ' ,   ,   , 0 .   '
      *
     O          E    46 21                  1
     O               35                          15 'FACILITY BRANCH'
     O               35      FCLB                40
      *
     O          E    46 21               1  1
     O                                           87 'NO. OF'
      *
     O          E    46 21                  1
     O                                            8 'DUE DATE'
     O                                           24 'EFFECTIVE DATE'
     O                                           42 'NARRATIVE'
     O                                           71 'AMOUNT'
     O                                           86 'DAYS'
      *
     O          E    46 21                  2
     O                                           88 'PAST DUE'
      *
     O          E    14 57 21               1
     O         OR    07 57 21
     O         OR    05 57 21
     O                  64   EXVDE                7
     O                       VDATD               19
     O                       NARRA               59
     O                     87ROLN                57
     O                     88ROLN                59
     O              N10 24N55PAMT                79 ' ,   ,   ,   , 0 -'
     O              N10 25N55PAMT                79 '   ,   ,   , 0 . -'
     O              N10 26N55PAMT                79 '  ,   ,   , 0 .  -'
     O              N10 27N55PAMT                79 ' ,   ,   , 0 .   -'
     O              N75N76 55PRATE               79 '  0 .       '
     O                  64 63DPDU          Z     85
      *
     O          E    02 11               3
     O               35                          46 '*** END OF REPORT FOR'
     O               35                          54 'BRANCH '
     O               35      BRCAH               57
     O               35                          61 ' ***'
     O          T   N20 21 LR               2 03
     O                                           13 'REF  LE0900P1'
     O                       TITL                66
     O                                           71 'DATE'
     O                       RUNA                79
     O                                           84 'PAGE'
     O                       PAGE                89
      *
     O          T   N20 21 LR               1
     O                                           46 'HISTORY CARD'
      *
     O          T   N20 21 LR               2
     O                                           46 '------------'
     O          T    LR U7 U8            3  2
     O         AND   21
     O                                           37 '*** REFERENCE'
     O                       DBPGM               51
     O                                           75 'DATABASE ERROR ***'
     O          T   N20 21 LR               2
     O              NU7                          46 '*** NO DETAILS'
     O              NU7                          60 'TO REPORT ***'
     O          T    02 21 20            3
     O         OR    LR 21 20
     O               35                          46 '*** END OF REPORT FOR'
     O               35                          54 'BRANCH '
     O               35      BRCAH               57
     O               35                          61 ' ***'
     O              N35                          57 '*** END OF REPORT ***'
      /EJECT
** ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** ZFMD - NUMBER OF DAYS IN THIS MONTH
312831303130313130313031
**   NARR - NARRATIVES
BASE RATE CODE CHANGE
BASE RATE CHANGE
INTEREST PAYMENT
INTEREST CAPITALISED
MATURITY-PRINCIPAL
MATURITY-INTEREST
MATURITY-WITHHOLDING TAX
MANUAL INTEREST ADJUSTMENT
MANUAL REPAYMENT-PRINCIPAL
MANUAL REPAYMENT-INTEREST
MANUAL REPAYMENT-WITHHOLD TAX
MANUAL REPAYMENT-FEE CODE
PRINCIPAL INCREASE
REPAYMENT-PRINCIPAL
REPAYMENT-INTEREST
REPAYMENT-WITHHOLDING TAX
ROLLOVER-BASE RATE
ROLLOVER-RATE
ROLLOVER-SPREAD-ADD
ROLLOVER-SPREAD-SUBTRACT
ROLLOVER-SPREAD-PERCENTAGE
STOP ACCRUALS
START ACCRUALS
SPREAD/RATE CHANGE                 WAS SPREAD CHANGE
START-PRINCIPAL
START-BASE RATE
START-RATE
START-SPREAD-ADD
START-SPREAD-SUBTRACT
START-SPREAD-PERCENTAGE
MATURITY-INTEREST CAPITALISED
MATURITY-FACE VALUE
START-FACE VALUE
START-PREMIUM
START-DISCOUNT
LOAN SUB-TYPE CHANGED
PRINCIPAL TRANSFER TO
PRINCIPAL TRANSFER FROM
CHARGES ADDED-ON
INTEREST ADDED-ON
** CPY@   **      OBJECT COPYRIGHT
(C) COPYRIGHT MKI LIMITED 1982, 1994
