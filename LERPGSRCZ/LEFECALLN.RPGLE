     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Calculate fees for loans')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFECALLN -  Calculate Fees Based on Loans                   *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE154             Date 06Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR750553           Date 29Apr11               *
      *                 CLE073  *CREATE    Date 28Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR750553 - Wrong total accrued to date for calc 98           *
      *             (Child:AR750554)                                  *
      *  CLE073 - Calculated Loan Based Fees                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCLOAN     IF   E           K DISK    INCLUDE(CLOANCLF: CLOANCKF)
     F                                     INFSR(*PSSR)
     FLEHISTLA  IF   E           K DISK    INFSR(*PSSR)
     FLEHISTLB  IF   E           K DISK    INFSR(*PSSR)
     FSDCURRPD  IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Power Array
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
 
      ** Calc Bases
     D TABCAL          S              1  0 DIM(6) CTDATA PERRCD(6)
     D TABCBS          S              5  0 DIM(6) ALT(TABCAL)
 
      ** Fee Amounts
     D FAM             S             13  0 DIM(5) ASCEND
 
      ** Fee Percentage
     D FPC             S              6  3 DIM(5) ASCEND
 
      ** All Ccys
     D CURR            S              3    DIM(150)
 
      ** Spot Rates/Ccy
     D CSPT            S             13  8 DIM(150)
 
      ** M/D Indicator/Ccy
     D MTDV            S              1    DIM(150)
 
      ** Dec Places/Ccy
     D CCDP            S              1  0 DIM(150)
 
      ** Sort Seq.No/Ccy
     D CCNO            S              2  0 DIM(150)
 
      ** Fee amounts data structure
     D  @FEAMA         DS
     D  FEAMT1                 1     11  0
     D  FEAMT2                12     22  0
     D  FEAMT3                23     33  0
     D  FEAMT4                34     44  0
     D  FEAMT5                45     55  0
 
      ** Fee Amounts
     D  FEAM                   1     55  0
     D                                     DIM(5) ASCEND
 
      ** Fee rates data structure
     D  @FRTA          DS
     D  FEFRT1                 1      7  5
     D  FEFRT2                 8     14  5
     D  FEFRT3                15     21  5
     D  FEFRT4                22     28  5
     D  FEFRT5                29     35  5
 
      ** Fee Rates
     D  FRT                    1     35  5
     D                                     DIM(5) ASCEND
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** | =====================================  |
      ** +----------------------------------------+
 
     ICLOANCLF
      ** Rename fields
     I              RECI                        RECIL
     I              FTYP                        FTYPL
     I              FSEQ                        FSEQL
     I              CCY                         CCYL
     I              LNRF                        LNRFL
     I              PTYP                        PTYPL
     I              RCDT                        RCDTL
     I              MRIN                        MRINL
     I              CNUM                        CNUML
     I              BRCA                        BRCAL
     I              LTYP                        LTYPL
     I              SUTP                        SUTPL
     I              DDAT                        DDATL
     I              VDAT                        VDATL
     I              MDAT                        MDATL
     I              LASQ                        LASQL
     I              FCUS                        FCUSL
     I              CPAM                        CPAML
     I              INTC                        INTCL
     I              INTR                        INTRL
     I              BRTT                        BRTTL
     I              BRTE                        BRTEL
     I              RTSP                        RTSPL
     I              MARG                        MARGL
     I              SPIN                        SPINL
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
     I              OLNO                        OLNOL
     I              RCSI                        RCSIL
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
     I              FSYLDC                      LSYLDC
     I              FSFYLD                      LSFYLD
     I              FSURPL                      LSURPL
     I              FSPLAM                      LSPLAM
     I              FSPLDT                      LSPLDT
     I              FSYUPL                      LSYUPL
     ICLOANCKF
      ** Rename fields
     I              RECI                        RECIK
     I              LNRF                        LNRFK
     I              RCDT                        RCDTK
     I              MRIN                        MRINK
     I              NAR1                        NAR1K
     I              NAR2                        NAR2K
     I              NAR3                        NAR3K
     I              NAR4                        NAR4K
     I              OPAM                        OPAMK
     I              FRBC                        FRBCK
     I              YPLN                        YPLNK
     I              YFLN                        YFLNK
     I              YWLN                        YWLNK
     I              ABLN                        ABLNK
     I              YPLC                        YPLCK
     I              YFLC                        YFLCK
     I              YWLC                        YWLCK
     I              ABLC                        ABLCK
     I              WWLN                        WWLNK
     I              IWLN                        IWLNK
     I              PWLN                        PWLNK
     I              RDST                        RDSTK
     I              SPI1                        SPI1K
     I              SPI2                        SPI2K
     I              SPI3                        SPI3K
     I              YILN                        YILNK
     I              ORVD                        ORVDK
     I              THRN                        THRNK
     I              NPRAM                       NPRAMK
     I              NDAM                        NDAMK
     I              RLBR                        RLBRK
     I              ORED                        OREDK
     I              LCD                         LCDK
     I              CHTP                        CHTPK
     I              TNLU                        TNLUK
     I              RRST                        RRSTK
     I              RRON                        RRONK
     I              RRIB                        RRIBK
     I              RRBA                        RRBAK
     I              RROB                        RROBK
     I              RROC                        RROCK
     I              NCCY                        NCCYK
     I              NCPA                        NCPAK
     I              NFCE                        NFCEK
     I              NFMD                        NFMDK
     I              NLRA                        NLRAK
     I              RSTS                        RSTSK
     I              RIUS                        RIUSK
     I              RAUS                        RAUSK
     I              RXUS                        RXUSK
     I              RPCR                        RPCRK
     I              RLSB                        RLSBK
     I              RPST                        RPSTK
     I              RPON                        RPONK
     I              RPIB                        RPIBK
     I              RPBA                        RPBAK
     I              RPOB                        RPOBK
     I              RPOC                        RPOCK
     I              RRCR                        RRCRK
     I              RRCA                        RRCAK
     I              RRVN                        RRVNK
     I              RAWB                        RAWBK
     I              RAWA                        RAWAK
     I              RBEN                        RBENK
     I              RBNA                        RBNAK
     I              RDP1                        RDP1K
     I              RDP2                        RDP2K
     I              RDP3                        RDP3K
     I              RDP4                        RDP4K
     I              RDCH                        RDCHK
     I              RBB1                        RBB1K
     I              RBB2                        RBB2K
     I              RBB3                        RBB3K
     I              RBB4                        RBB4K
     I              RBB5                        RBB5K
     I              RBB6                        RBB6K
     I              RCVM                        RCVMK
     I              NBCE                        NBCEK
     I              NBMD                        NBMDK
     I              RRSC                        RRSCK
     I              RPSC                        RPSCK
     I              RICY                        RICYK
     I              ECIN                        ECINK
     I              RPSM                        RPSMK
     I              RPOS                        RPOSK
     I              RPTS                        RPTSK
     I              RPSB                        RPSBK
     I              RFAO                        RFAOK
     I              FSFYLB                      KSFYLB
 
     IHISTSHPF
      ** Rename fields
     I              RECI                        RECIP
     I              RCDT                        RCDTP
     I              BRCA                        BRCAP
     I              CNUM                        CNUMP
     I              LNRF                        LNRFP
     I              VDAT                        VDATP
     I              PRSQ                        PRSQP
     I              LASN                        LASNP
     I              CCY                         CCYP
     I              AMTP                        AMTPP
     I              PRAM                        PRAMP
     I              LCD                         LCDP
     I              CPAM                        CPAMP
 
     IHISTSHMF
      ** Rename fields
     I              RECI                        RECIM
     I              RCDT                        RCDTM
     I              BRCA                        BRCAM
     I              CNUM                        CNUMM
     I              LNRF                        LNRFM
     I              VDAT                        VDATM
     I              PRSQ                        PRSQM
     I              LASN                        LASNM
     I              CCY                         CCYM
     I              AMTP                        AMTPM
     I              PRAM                        PRAMM
     I              LCD                         LCDM
     I              CPAM                        CPAMM
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Z-ADD     0             WAMT             13 0
     C                   Z-ADD     0             WTOT
 
      ** Set up Start and End dates
 
     C                   Z-ADD     FELPDT        STDATE            5 0    46
     C   46              Z-ADD     FEPSTD        STDATE
     C                   Z-ADD     BJRDNB        ENDATE            5 0
     C     FEPEND        IFLE      BJRDNB
     C                   Z-ADD     FEPEND        ENDATE
     C                   ENDIF
 
     C     BJRDNB        IFNE      FEPEND
     C     BJRDNB        ANDNE     FELPDT
     C                   IF        CLE005 = 'Y'                                             AR750553
     C                   Z-ADD     FEPSTD        STDATE                                     AR750553
     C                   ELSE                                                               AR750553
     C                   Z-ADD     FELADT        STDATE
     C                   ENDIF                                                              AR750553
     C     STDATE        IFEQ      0
     C                   Z-ADD     FEPSTD        STDATE
     C                   ENDIF
     C                   ENDIF
 
      ** Obtain number of days to use.
 
     C                   Z-ADD     STDATE        ZZBEG
     C                   Z-ADD     ENDATE        ZZEND
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      ZINTDY
     C     FECALC        IFEQ      6
     C                   Z-ADD     INT6DY        WDAYS             5 0
     C                   ELSE
     C                   Z-ADD     ZZINDY        WDAYS
     C                   ENDIF
 
     C                   MOVE      S#LOAN        @@LOAN
     C     KLOAN         CHAIN     CLOAN                              96
     C     *IN96         IFEQ      *ON
     C                   Z-ADD     0             CPAML
     C                   ENDIF
     C                   MOVE      'B'           WCLRT
     C     KLOAN         CHAIN     CLOAN                              96
     C     *IN96         IFEQ      *ON
     C                   Z-ADD     0             OPAMK
     C                   ENDIF
     C     KEYPHS        CHAIN     LEHISTLB                           96
     C     *IN96         IFEQ      *OFF
     C                   Z-ADD     PRAMM         OPAMK
     C                   ENDIF
 
      ** Initialise work fee field.
 
     C                   Z-ADD     0             W#FEE            13 0
 
     C                   SELECT
 
      ** Calculation type '97'
 
     C     FECALT        WHENEQ    '97'
     C                   EXSR      CALT97
     C                   EXSR      LONACC
     C                   Z-ADD     WTOT          W#FEE
 
      ** Calculation type '98'
 
     C     FECALT        WHENEQ    '98'
     C                   Z-ADD     OPAMK         WAMT
     C                   EXSR      LONACC
     C                   Z-ADD     WTOT          W#FEE
 
      ** Calculation type '99'
 
     C     FECALT        WHENEQ    '99'
     C                   Z-ADD     FELPDT        ZZBEG             5 0    46
     C   46              Z-ADD     FEPSTD        ZZBEG
     C     FENPYD        IFNE      0
     C                   Z-ADD     FENPYD        ZZEND
     C                   ELSE
     C                   Z-ADD     FEPEND        ZZEND
     C                   ENDIF
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      ZINTDY
     C     FECALC        IFEQ      6
     C                   Z-ADD     INT6DY        WDAYS9            5 0
     C                   ELSE
     C                   Z-ADD     ZZINDY        WDAYS9
     C                   ENDIF
     C                   Z-ADD     FEFAMT        WAMT
     C                   EXSR      LONACC
     C                   Z-ADD     WTOT          W#FEE
     C                   ENDSL
 
      ** Forward valued fees should have zero total accrued amount
 
     C     FEPSTD        IFGT      BJRDNB
     C                   Z-ADD     0             W#FEE
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      /EJECT
      *****************************************************************
      /TITLE SR/LONACC
      *****************************************************************
      *
      *  LONACC - Subroutine to calculate new loan calc. type accruals
      *
      *  This sr is based on sr/ACCRUE - in case of any change to
      *  sr/ACCRUE (or in case of upgrade) verify whether new changes
      *  are to be applied to sr/LONACC as well.
      *
      *  CALLED FROM: LONAMT
      *
      *  CALLS: ZXRATE, ZCONV, LSTRAT, AOCURRR0
      *
      *****************************************************************
 
     C     LONACC        BEGSR
 
     C                   Z-ADD     0             WTOT
 
      ** Convert from loan to fee currency if required.
      ** If exchange rate field on fees master file is blank, obtain
      ** x-ccy exchange rate for these two currencies from SD files,
      ** otherwise use exchange rate on fees master file.
 
     C     CCYL          IFNE      FEFCCY
     C                   Z-ADD     WAMT          CAMT             13 0
     C     FEERAT        IFEQ      0
     C                   MOVE      CCYL          INCCY             3
     C                   MOVE      FEFCCY        OUTCCY            3
     C                   Z-ADD     1             X
     C     INCCY         LOOKUP    CURR(X)                                52
     C     *IN52         IFEQ      '1'
     C                   MOVE      MTDV(X)       ZMDI1             1
     C                   Z-ADD     CSPT(X)       ZRATE1           13 8
     C                   Z-ADD     CCDP(X)       ZNBDP1            1 0
     C                   ENDIF
 
     C                   Z-ADD     1             X
     C     OUTCCY        LOOKUP    CURR(X)                                53
     C     *IN53         IFEQ      '1'
     C                   MOVE      MTDV(X)       ZMDI2             1
     C                   Z-ADD     CSPT(X)       ZRATE2           13 8
     C                   Z-ADD     CCDP(X)       ZNBDP2            1 0
     C                   ENDIF
 
      ** Obtain cross exchange rate & cross multiply/divide indicator.
 
     C                   EXSR      ZXRATE
 
      ** Set up input fields for conversion subroutine.
 
     C                   Z-ADD     ZRATEX        ZEXCH            13 8
     C                   MOVE      ZMDIX         ZMD               1
     C                   Z-ADD     CAMT          ZAMTCI           15 0
     C                   MOVE      INCCY         ZCCYI             3
     C                   MOVE      OUTCCY        ZCCYO             3
     C                   Z-ADD     ZNBDP1        ZCDPI             1 0
     C                   Z-ADD     ZNBDP2        ZCDPO             1 0
 
     C                   EXSR      ZCONV
 
     C                   Z-ADD     ZAMTCO        CAMT
 
      ** Exchange rate not blank
 
     C                   ELSE
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCYL          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   Z-ADD     A6NBDP        ZNBDP1            1 0
 
      ** Set up currency decimal place power position.
 
     C     A6NBDP        ADD       4             FD                1 0
 
      ** Fee currency decimal places + 1.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FEFCCY        @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     A6NBDP        ADD       4             P                 1 0
 
     C                   Z-ADD     P             TD                1 0
 
      ** Adjust incoming amount for from CCY decimal places.
 
     C     CAMT          DIV       POWER(FD)     WRK153           15 3
 
      ** Exchange rate conversion.
 
     C     FEMDIN        IFEQ      'M'
     C                   MULT      FEERAT        WRK153
     C                   ELSE
     C                   DIV(H)    FEERAT        WRK153
     C                   ENDIF
 
      ** Adjust calculated amount for to currency decimal places.
 
     C     WRK153        MULT      POWER(TD)     CAMT
 
     C                   ENDIF
     C                   Z-ADD     CAMT          WAMT
     C                   ENDIF
 
      ** Look up factor for division corresponding to calc. basis
 
     C                   MOVE      '0'           *IN54
     C     FECALC        LOOKUP    TABCAL        TABCBS                   54
     C                   MOVE      TABCBS        WCBS              5 0
 
     C     FECALT        IFEQ      '97'
     C     FECALT        OREQ      '98'
     C     WAMT          MULT      FRT(1)        WTOT
     C                   ELSE
     C                   Z-ADD     WAMT          WTOT
     C                   ENDIF
     C     FECALT        IFNE      '97'
     C                   MULT      WDAYS         WTOT
     C                   ENDIF
     C     WTOT          IFNE      0
     C     FECALT        IFNE      '99'
     C                   DIV(H)    WCBS          WTOT
     C                   ELSE
     C                   DIV(H)    WDAYS9        WTOT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CALT97
      *****************************************************************
      *
      *  CALT97 - Subroutine for calculation 97 amount calculations
      *
      *  CALLED FROM: LONAMT
      *
      *  CALLS:
      *
      *****************************************************************
 
     C     CALT97        BEGSR
 
      ** Initialise work fields
 
     C                   Z-ADD     0             WAMT             13 0
     C                   Z-ADD     0             AAMT             13 0
     C                   Z-ADD     STDATE        KVDAT
 
      ** Get amount from loan history file
 
     C                   Z-ADD     OPAMK         AAMT
 
     C                   Z-ADD     999           WLASN
     C     KEYHST        SETGT     LEHISTLA
     C     KEYPHS        READPE    LEHISTLA                               97
 
     C     *IN97         IFEQ      *OFF
     C                   Z-ADD     CPAMP         AAMT
     C                   ELSE
     C                   Z-ADD     001           WLASN
     C     KEYHST        SETLL     LEHISTLA                               97
     C                   ENDIF
 
      ** Read file until date read is greater than date of end of
      ** this accrual period.
      ** NDAYS is the number of days in this accrual.
 
     C                   MOVE      '0'           *IN97
     C     *IN97         DOWEQ     '0'                                          B* DO
     C     KEYPHS        READE     LEHISTLA                               97
 
     C     *IN97         IFEQ      '1'
     C     VDATP         ORGT      ENDATE
     C                   Z-ADD     ENDATE        VDATP
     C                   MOVE      '1'           *IN97
     C                   ENDIF
 
     C                   Z-ADD     STDATE        ZZBEG
     C     VDATP         IFGT      STDATE
     C                   Z-ADD     VDATP         ZZEND
     C                   ELSE
     C                   Z-ADD     STDATE        ZZEND
     C                   END
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      ZINTDY
     C     FECALC        IFEQ      6
     C                   Z-ADD     INT6DY        NDAYS
     C                   ELSE
     C                   Z-ADD     ZZINDY        NDAYS             5 0
     C                   ENDIF
 
     C     NDAYS         IFGT      0
     C                   MULT      NDAYS         AAMT
     C                   ADD       AAMT          WAMT
     C                   END
     C     VDATP         IFGT      STDATE
     C                   Z-ADD     VDATP         STDATE
     C                   END
 
      ** Reset amount to accrue - comes from next record on amounts
      ** file.
 
     C     *IN97         IFNE      '1'
     C                   Z-ADD     CPAMP         AAMT
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FIND LAST RATE
      *****************************************************************
     C     LSTRAT        BEGSR
     C                   Z-ADD     5             Y                 2 0
     C     Y             DOWGT     0
     C     FEAM(Y)       IFEQ      0
     C     FRT(Y)        ANDNE     0
     C                   Z-ADD     Y             X
     C                   Z-ADD     0             Y
     C                   END
     C                   SUB       1             Y
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZINTDY        BEGSR
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeOut       10
     C                   PARM                    ZZINDY            5 0
     C                   PARM                    ZZBEG             5 0
     C                   PARM                    ZZEND             5 0
     C                   PARM                    ZZCALC            1
     C                   PARM                    INT6DY           15 7
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZXRATE        BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM      *ZEROS        ZRATEX           13 8
     C                   PARM      *BLANKS       ZMDIX             1
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZCONV         BEGSR
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Loan
 
     C                   PARM                    S#LOAN            6
 
      ** Fee details
      ** -----------
      ** Fee Branch Code
      ** Fee Customer Number
      ** Fee Amount
      ** Fee Next Pay Date
      ** Last Payment Date
      ** Last Accrual Date
      ** Period Start Date
      ** Period End Date
      ** Fee Calculation type
      ** Calculation basis
      ** Percent Indicator
      ** Fee currency
      ** Exchange rate
      ** Multiply/Divide indicator
      ** Fee amounts x 5
      ** Fee rates x 5
 
     C                   PARM                    FEBRCA            3
     C                   PARM                    FECNUM            6
     C                   PARM                    FEFAMT           13 0
     C                   PARM                    FENPYD            5 0
     C                   PARM                    FELPDT            5 0
     C                   PARM                    FELADT            5 0
     C                   PARM                    FEPSTD            5 0
     C                   PARM                    FEPEND            5 0
     C                   PARM                    FECALT            2
     C                   PARM                    FECALC            1 0
     C                   PARM                    FEPIND            1
     C                   PARM                    FEFCCY            3
     C                   PARM                    FEERAT           13 8
     C                   PARM                    FEMDIN            1
     C                   PARM                    @FEAMA
     C                   PARM                    @FRTA
     C                   PARM                    CLE005            1                        AR750553
 
      ** OUTPUTS
      ** Fee amount
 
     C                   PARM                    W#FEE            13 0
 
      ** Access Bank Detailes
      ** ~~~~~~~~~~~~~~~~~~~~
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set up currency arrays
 
     C                   Z-ADD     0             X                 3 0
     C                   READ      SDCURRPD                               17
 
     C     *IN17         DOWEQ     '0'
 
     C     X             IFLE      150
     C     X             ADD       1             X
     C                   MOVE      A6CYCD        CURR(X)
     C                   Z-ADD     A6SPRT        CSPT(X)
     C                   MOVEL     A6MDIN        MTDV(X)
     C                   Z-ADD     A6NBDP        CCDP(X)
     C                   Z-ADD     A6SSNB        CCNO(X)
     C                   ENDIF
 
     C                   READ      SDCURRPD                               17
 
     C                   ENDDO
 
     C                   Z-ADD     0             WOPCT             6 3
     C                   Z-ADD     0             WOAMT            13 0
     C                   Z-ADD     0             WFPC              6 3
     C                   Z-ADD     0             WFAM             13 0
     C                   Z-ADD     0             WTOT             13 0
     C                   Z-ADD     0             WRK63             6 3
     C                   Z-ADD     0             WRK15            15 0
     C                   Z-ADD     0             WRK153           15 3
     C                   Z-ADD     0             WRK155           15 5
 
      ** Key lists
      ** KLIST for file CLOAN
 
     C     KLOAN         KLIST
     C**********         KFLD                    @@LOAN            6 0                        CLE148
     C                   KFLD                    @@LOAN            6                          CLE148
     C                   KFLD                    WCLRT             1
     C                   MOVE      'A'           WCLRT
     C                   Z-ADD     999           WLASN
 
      ** Key to access HISTSHP
 
     C     KEYHST        KLIST
     C                   KFLD                    FEBRCA
     C                   KFLD                    FECNUM
     C                   KFLD                    @@LOAN
     C                   KFLD                    KVDAT             5 0
     C                   KFLD                    WLASN             3 0
 
      ** Partial Key to process HISTSHP
 
     C     KEYPHS        KLIST
     C                   KFLD                    FEBRCA
     C                   KFLD                    FECNUM
     C                   KFLD                    @@LOAN
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2011
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**   TABCAL/TABCBS - CALCULATION BASES.
136500236000336000436500536000636600
