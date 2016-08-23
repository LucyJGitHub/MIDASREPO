     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Datapatch utility program - CLOANCL')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00063 -  Datapatch utility to correct NOPS field of       *
      *              mature/live loans within PF/CLOANCL.  Called by  *
      *              CL program SMUC00026.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 MDFIX              Date 23Apr02               *
      *                 201762 *CREATE     Date 11Dec01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  BG26993- Delivery of upgrade programs to core.               *
      *         - Renamed program SC20176201.                         *
      *  MDFIX  - Print processing type of Part Sold loan.            *
      *         - Do not include Risk Parts sold (processing type 72) *
      *           in COUNT to update NOPS, unless original loan has   *
      *           processing type 70 or 71.                           *
      *         - Include Internal Parts. Purchased (PTYP = 64, 65,   *
      *           68 or 71) which have a mirror loan number. New LF   *
      *           S201762M, keyed on MLNR.                            *
      *  201762 - NOPS field of the original loan is not properly     *
      *           updated upon maturity of the attached parts sold    *
      *           loan.                                               *
      *****************************************************************
     FSMU002PD  UF   E             DISK
     FSMU002L0  IF   E           K DISK
     F                                     RENAME(CLOANCLF:XCLOANCF)
     FSMU002L1  IF   E           K DISK
     F                                     RENAME(CLOANCLF:YCLOANCF)
     FSMU00063P1O    E             PRINTER
      /TITLE FUNCTION OF INDICATORS
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  01  - UPDATE mode                                            *
      *  02  - No details to report                                   *
      *  03  - EOF in CLOANCL                                         *
      *  04  - Loan not found in S201762L file.                       *
      *  05  - Error in updating record in CLOANCL (not found)        *
      *  06  - LR ind for S201762L using READE command.               *
      *  07  - Print word 'NONE' instead of LNRF2 in S201762P.        *
      *  09  - Print updated NOPS.                                    *
      *  10  - Loan not found in S201762M file
      *  U7  - Database Error                                         *
      *  U8  - Database Error                                         *
      *                                                               *
      *****************************************************************
      *
      ** Local data area for database error details
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBOPTN               184    191
      *
      ** Bank details and rundate
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  RUND         E                     EXTFLD(BJMRDT)
     D  REPT         E                     EXTFLD(BJURPT)
      *
      ** Data structure for access program
     D DSFDY         E DS                  EXTNAME(DSFDY)
      /SPACE 3
      /TITLE SUBROUTINE INDEX
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  PROCD  - Detail Processing (CLOANCL)                         *
      *  PRINT  - Print page headings and detail lines                *
      *  UPDTE  - Update CLOANCL with correct NOPS value              *
      *  *PSSR  - Database Error Subroutine                           *
      *                                                               *
      *****************************************************************
     ICLOANCLF
     I              REPT                        REPT1
      *
      ** Rename all SMU002L0 fields to prevent any problem when
      ** updating PF/CLOANCL.
      *
     IXCLOANCF
     I              RECI                        RECI2
     I              LNRF                        LNRF2
     I              RCDT                        RCDT2
     I              MRIN                        MRIN2
     I              PTYP                        PTYP2
     I              CNUM                        CNUM2
     I              BRCA                        BRCA2
     I              LTYP                        LTYP2
     I              SUTP                        SUTP2
     I              DDAT                        DDAT2
     I              VDAT                        VDAT2
     I              MDAT                        MDAT2
     I              LASQ                        LASQ2
     I              FCUS                        FCUS2
     I              FTYP                        FTYP2
     I              FSEQ                        FSEQ2
     I              CCY                         CCY2
     I              CPAM                        CPAM2
     I              INTC                        INTC2
     I              INTR                        INTR2
     I              BRTT                        BRTT2
     I              BRTE                        BRTE2
     I              RTSP                        RTSP2
     I              MARG                        MARG2
     I              SPIN                        SPIN2
     I              CHIN                        CHIN2
     I              WTRT                        WTRT2
     I              WTIN                        WTIN2
     I              REPT                        REPT2
     I              RAMT                        RAMT2
     I              NRPD                        NRPD2
     I              RFRQ                        RFRQ2
     I              RDYN                        RDYN2
     I              FCCY                        FCCY2
     I              LIND                        LIND2
     I              CRSK                        CRSK2
     I              ACOF                        ACOF2
     I              NACD                        NACD2
     I              RELI                        RELI2
     I              AUTO                        AUTO2
     I              PSAM                        PSAM2
     I              BCXR                        BCXR2
     I              FCXR                        FCXR2
     I              SDST                        SDST2
     I              OSDA                        OSDA2
     I              TSTN                        TSTN2
     I              MDST                        MDST2
     I              OMDA                        OMDA2
     I              TMAN                        TMAN2
     I              FACO                        FACO2
     I              RLDT                        RLDT2
     I              NROD                        NROD2
     I              RLFQ                        RLFQ2
     I              RLDY                        RLDY2
     I              RDFC                        RDFC2
     I              NBRA                        NBRA2
     I              NRTS                        NRTS2
     I              NSIN                        NSIN2
     I              NCAS                        NCAS2
     I              AWTP                        AWTP2
     I              WTRD                        WTRD2
     I              WTWD                        WTWD2
     I              IWOD                        IWOD2
     I              PWOD                        PWOD2
     I              BMDI                        BMDI2
     I              FMDI                        FMDI2
     I              PDIN                        PDIN2
     I              LSWC                        LSWC2
     I              LSWS                        LSWS2
     I              OSDB                        OSDB2
     I              OMDB                        OMDB2
     I              ORBR                        ORBR2
     I              PRFC                        PRFC2
     I              FCLB                        FCLB2
     I              MLNR                        MLNR2
     I              BTIN                        BTIN2
     I              BLDY                        BLDY2
     I              OLNO                        OLNO2
     I              RCSI                        RCSI2
     I              ICBS                        ICBS2
     I              IPFR                        IPFR2
     I              TOTI                        TOTI2
     I              NIDT                        NIDT2
     I              IBDT                        IBDT2
     I              SLID                        SLID2
     I              AIPD                        AIPD2
     I              DLRC                        DLRC2
     I              IACD                        IACD2
     I              AITC                        AITC2
     I              TFEP                        TFEP2
     I              AIAP                        AIAP2
     I              IPRD                        IPRD2
     I              IPRM                        IPRM2
     I              ICTD                        ICTD2
     I              AIMN                        AIMN2
     I              RBDT                        RBDT2
     I              NOPS                        NOPS2
     I              NCHI                        NCHI2
     I              IFDY                        IFDY2
     I              LONI                        LONI2
     I              CNFI                        CNFI2
     I              ACEI                        ACEI2
     I              TLXI                        TLXI2
     I              CBLI                        CBLI2
     I              ORED                        ORED2
     I              LCD                         LCD2
     I              CHTP                        CHTP2
     I              TNLU                        TNLU2
     I              ADDI                        ADDI2
     I              ORMD                        ORMD2
     I              ORTI                        ORTI2
     I              BOKC                        BOKC2
     I              COCU                        COCU2
     I              RECE                        RECE2
     I              OMDT                        OMDT2
     I              NIPD                        NIPD2
     I              NMDT                        NMDT2
     I              APMI                        APMI2
     I              RSTM                        RSTM2
     I              RONS                        RONS2
     I              RIBN                        RIBN2
     I              RIBA                        RIBA2
     I              ROBN                        ROBN2
     I              ROCN                        ROCN2
     I              PSTM                        PSTM2
     I              PONS                        PONS2
     I              PIBN                        PIBN2
     I              PIBA                        PIBA2
     I              POBN                        POBN2
     I              POCN                        POCN2
     I              RCRN                        RCRN2
     I              RCRA                        RCRA2
     I              RVNO                        RVNO2
     I              AWBN                        AWBN2
     I              AWBA                        AWBA2
     I              BENN                        BENN2
     I              BENA                        BENA2
     I              DTP1                        DTP12
     I              DTP2                        DTP22
     I              DTP3                        DTP32
     I              DTP4                        DTP42
     I              DCHG                        DCHG2
     I              BTB1                        BTB12
     I              BTB2                        BTB22
     I              BTB3                        BTB32
     I              BTB4                        BTB42
     I              BTB5                        BTB52
     I              BTB6                        BTB62
     I              CVMR                        CVMR2
     I              PTFR                        PTFR2
     I              HLEX                        HLEX2
     I              FSRP                        FSRP2
     I              FSGN                        FSGN2
     I              FPRC                        FPRC2
     I              TCOF                        TCOF2
     I              ACPD                        ACPD2
     I              ACDA                        ACDA2
     I              ACAJ                        ACAJ2
     I              ACAP                        ACAP2
     I              COFD                        COFD2
     I              COFM                        COFM2
     I              CFCD                        CFCD2
     I              NFRS                        NFRS2
     I              NFSN                        NFSN2
     I              NFPC                        NFPC2
     I              PDCF                        PDCF2
     I              FCTD                        FCTD2
     I              FWOD                        FWOD2
     I              DFTP                        DFTP2
     I              DFST                        DFST2
     I              MCRA                        MCRA2
     I              FCRA                        FCRA2
     I              PDDI                        PDDI2
     I              PTDI                        PTDI2
     I              GDPR                        GDPR2
     I              GDIN                        GDIN2
     I              LNKS                        LNKS2
     I              MNSG                        MNSG2
     I              GASS                        GASS2
     I              GPRT                        GPRT2
     I              TOLN                        TOLN2
     I              LSTS                        LSTS2
     I              IUSR                        IUSR2
     I              AUSR                        AUSR2
     I              XUSR                        XUSR2
     I              RATF                        RATF2
     I              CNCF                        CNCF2
     I              PCRF                        PCRF2
     I              LPFI                        LPFI2
     I              PTFC                        PTFC2
     I              PTFT                        PTFT2
     I              PTFN                        PTFN2
     I              PCOB                        PCOB2
     I              LRLD                        LRLD2
     I              LMCD                        LMCD2
     I              SCCY                        SCCY2
     I              ICCY                        ICCY2
     I              OINR                        OINR2
     I              OIDT                        OIDT2
     I              REPI                        REPI2
     I              RFDY                        RFDY2
     I              RFRI                        RFRI2
     I              RFRT                        RFRT2
     I              RFAR                        RFAR2
     I              FSYLDC                      YLDC2
     I              FSFYLD                      FYLD2
     I              FSURPL                      URPL2
     I              FSPLAM                      PLAM2
     I              FSPLDT                      PLDT2
     I              FSYUPL                      YUPL2
      *
      ** Rename all SMU002L1 fields to prevent any problem when
      ** updating PF/CLOANCL.
      *
     IYCLOANCF
     I              RECI                        RECIM
     I              LNRF                        LNRFM
     I              RCDT                        RCDTM
     I              MRIN                        MRINM
     I              PTYP                        PTYPM
     I              CNUM                        CNUMM
     I              BRCA                        BRCAM
     I              LTYP                        LTYPM
     I              SUTP                        SUTPM
     I              DDAT                        DDATM
     I              VDAT                        VDATM
     I              MDAT                        MDATM
     I              LASQ                        LASQM
     I              FCUS                        FCUSM
     I              FTYP                        FTYPM
     I              FSEQ                        FSEQM
     I              CCY                         CCYM
     I              CPAM                        CPAMM
     I              INTC                        INTCM
     I              INTR                        INTRM
     I              BRTT                        BRTTM
     I              BRTE                        BRTEM
     I              RTSP                        RTSPM
     I              MARG                        MARGM
     I              SPIN                        SPINM
     I              CHIN                        CHINM
     I              WTRT                        WTRTM
     I              WTIN                        WTINM
     I              REPT                        REPTM
     I              RAMT                        RAMTM
     I              NRPD                        NRPDM
     I              RFRQ                        RFRQM
     I              RDYN                        RDYNM
     I              FCCY                        FCCYM
     I              LIND                        LINDM
     I              CRSK                        CRSKM
     I              ACOF                        ACOFM
     I              NACD                        NACDM
     I              RELI                        RELIM
     I              AUTO                        AUTOM
     I              PSAM                        PSAMM
     I              BCXR                        BCXRM
     I              FCXR                        FCXRM
     I              SDST                        SDSTM
     I              OSDA                        OSDAM
     I              TSTN                        TSTNM
     I              MDST                        MDSTM
     I              OMDA                        OMDAM
     I              TMAN                        TMANM
     I              FACO                        FACOM
     I              RLDT                        RLDTM
     I              NROD                        NRODM
     I              RLFQ                        RLFQM
     I              RLDY                        RLDYM
     I              RDFC                        RDFCM
     I              NBRA                        NBRAM
     I              NRTS                        NRTSM
     I              NSIN                        NSINM
     I              NCAS                        NCASM
     I              AWTP                        AWTPM
     I              WTRD                        WTRDM
     I              WTWD                        WTWDM
     I              IWOD                        IWODM
     I              PWOD                        PWODM
     I              BMDI                        BMDIM
     I              FMDI                        FMDIM
     I              PDIN                        PDINM
     I              LSWC                        LSWCM
     I              LSWS                        LSWSM
     I              OSDB                        OSDBM
     I              OMDB                        OMDBM
     I              ORBR                        ORBRM
     I              PRFC                        PRFCM
     I              FCLB                        FCLBM
     I              MLNR                        MLNRM
     I              BTIN                        BTINM
     I              BLDY                        BLDYM
     I              OLNO                        OLNOM
     I              RCSI                        RCSIM
     I              ICBS                        ICBSM
     I              IPFR                        IPFRM
     I              TOTI                        TOTIM
     I              NIDT                        NIDTM
     I              IBDT                        IBDTM
     I              SLID                        SLIDM
     I              AIPD                        AIPDM
     I              DLRC                        DLRCM
     I              IACD                        IACDM
     I              AITC                        AITCM
     I              TFEP                        TFEPM
     I              AIAP                        AIAPM
     I              IPRD                        IPRDM
     I              IPRM                        IPRMM
     I              ICTD                        ICTDM
     I              AIMN                        AIMNM
     I              RBDT                        RBDTM
     I              NOPS                        NOPSM
     I              NCHI                        NCHIM
     I              IFDY                        IFDYM
     I              LONI                        LONIM
     I              CNFI                        CNFIM
     I              ACEI                        ACEIM
     I              TLXI                        TLXIM
     I              CBLI                        CBLIM
     I              ORED                        OREDM
     I              LCD                         LCDM
     I              CHTP                        CHTPM
     I              TNLU                        TNLUM
     I              ADDI                        ADDIM
     I              ORMD                        ORMDM
     I              ORTI                        ORTIM
     I              BOKC                        BOKCM
     I              COCU                        COCUM
     I              RECE                        RECEM
     I              OMDT                        OMDTM
     I              NIPD                        NIPDM
     I              NMDT                        NMDTM
     I              APMI                        APMIM
     I              RSTM                        RSTMM
     I              RONS                        RONSM
     I              RIBN                        RIBNM
     I              RIBA                        RIBAM
     I              ROBN                        ROBNM
     I              ROCN                        ROCNM
     I              PSTM                        PSTMM
     I              PONS                        PONSM
     I              PIBN                        PIBNM
     I              PIBA                        PIBAM
     I              POBN                        POBNM
     I              POCN                        POCNM
     I              RCRN                        RCRNM
     I              RCRA                        RCRAM
     I              RVNO                        RVNOM
     I              AWBN                        AWBNM
     I              AWBA                        AWBAM
     I              BENN                        BENNM
     I              BENA                        BENAM
     I              DTP1                        DTP1M
     I              DTP2                        DTP2M
     I              DTP3                        DTP3M
     I              DTP4                        DTP4M
     I              DCHG                        DCHGM
     I              BTB1                        BTB1M
     I              BTB2                        BTB2M
     I              BTB3                        BTB3M
     I              BTB4                        BTB4M
     I              BTB5                        BTB5M
     I              BTB6                        BTB6M
     I              CVMR                        CVMRM
     I              PTFR                        PTFRM
     I              HLEX                        HLEXM
     I              FSRP                        FSRPM
     I              FSGN                        FSGNM
     I              FPRC                        FPRCM
     I              TCOF                        TCOFM
     I              ACPD                        ACPDM
     I              ACDA                        ACDAM
     I              ACAJ                        ACAJM
     I              ACAP                        ACAPM
     I              COFD                        COFDM
     I              COFM                        COFMM
     I              CFCD                        CFCDM
     I              NFRS                        NFRSM
     I              NFSN                        NFSNM
     I              NFPC                        NFPCM
     I              PDCF                        PDCFM
     I              FCTD                        FCTDM
     I              FWOD                        FWODM
     I              DFTP                        DFTPM
     I              DFST                        DFSTM
     I              MCRA                        MCRAM
     I              FCRA                        FCRAM
     I              PDDI                        PDDIM
     I              PTDI                        PTDIM
     I              GDPR                        GDPRM
     I              GDIN                        GDINM
     I              LNKS                        LNKSM
     I              MNSG                        MNSGM
     I              GASS                        GASSM
     I              GPRT                        GPRTM
     I              TOLN                        TOLNM
     I              LSTS                        LSTSM
     I              IUSR                        IUSRM
     I              AUSR                        AUSRM
     I              XUSR                        XUSRM
     I              RATF                        RATFM
     I              CNCF                        CNCFM
     I              PCRF                        PCRFM
     I              LPFI                        LPFIM
     I              PTFC                        PTFCM
     I              PTFT                        PTFTM
     I              PTFN                        PTFNM
     I              PCOB                        PCOBM
     I              LRLD                        LRLDM
     I              LMCD                        LMCDM
     I              SCCY                        SCCYM
     I              ICCY                        ICCYM
     I              OINR                        OINRM
     I              OIDT                        OIDTM
     I              REPI                        REPIM
     I              RFDY                        RFDYM
     I              RFRI                        RFRIM
     I              RFRT                        RFRTM
     I              RFAR                        RFARM
     I              FSYLDC                      YLDCM
     I              FSFYLD                      FYLDM
     I              FSURPL                      URPLM
     I              FSPLAM                      PLAMM
     I              FSPLDT                      PLDTM
     I              FSYUPL                      YUPLM
      /EJECT
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      **  Perform Initialisation.
     C                   EXSR      INIT
      *
      **  Perform Detail Processing.
     C                   EXSR      PROCD
     C                   MOVE      *ON           *INLR
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls : -- *PSSR                                             *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR                                                  ***  INIT  ***
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
     C                   MOVE      '0'           *IN01
     C                   MOVE      '0'           *IN09
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVE      '1'           *IN01
     C                   MOVE      '1'           *IN09
     C                   ENDIF
      *
      ** Initialize LDA
     C     *DTAARA       DEFINE                  LDA
      *
      ** Use access program to read BANK DETAILS FILE
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   WRITE     PAGHDG
     C     *LOCK         IN        LDA
     C                   MOVEL     '        '    DBKEY
     C                   MOVEL     'SMU00063'    DBPGM
     C                   MOVE      '01'          DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   Z-ADD     1             DBASE                          * DBERR 01 *
     C                   MOVEL     @OPTN         DBOPTN                         ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PROCD
      *****************************************************************
      *                                                               *
      *  PROCD - Subroutine to do the Detail Processing.              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls : -- PRINT; UPDTE                                      *
      *                                                               *
      *****************************************************************
      *
     C     PROCD         BEGSR                                                  *** PROCD ***
      *
      **  Write source header and detail header
     C                   WRITE     PAGHDG
      *
     C                   MOVE      '0'           *IN02
     C                   Z-ADD     0             COUNT             6 0
     C                   Z-ADD     0             COUNT1            6 0
     C                   Z-ADD     0             WCTR              2 0
     C                   Z-ADD     0             CNTNOP            3 0
     C                   MOVE      ' '           WTYP              1
      *
      **  Read first record from file
     C                   READ      CLOANCLF                               03
      *
      ** If End of File, perform Audit Reporting.
     C     *IN03         IFEQ      '1'
     C                   MOVE      '1'           *IN02
     C                   WRITE     END
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   WRITE     DETHDG
      *
      **  Do Until End of File.
     C     *IN03         DOUEQ     '1'
      *
     C                   ADD       1             COUNT1
      *
     C                   MOVEL     LNRF          LNRFA             6
     C     LNRFA         CHAIN     XCLOANCF                           04
      *
      **  If no record is found check for internal parts purchased.
      *
     C     *IN04         IFEQ      '1'
     C     LNRF          CHAIN     YCLOANCF                           10
      *
      **  If no record is found, print loan if NOPS not equal to zero.
      *
     C     *IN10         IFEQ      '1'
      *
     C     NOPS          IFNE      0
     C                   MOVE      '1'           *IN07
     C                   ADD       1             COUNT
     C                   MOVE      'Y'           WRECO1
     C                   EXSR      PRINT
      *
      **  If UPDATE mode and NOPS is not zero, update loan with
      **  NOPS = zero.
      *
     C     *IN01         IFEQ      '1'
     C                   Z-ADD     0             NOPS
     C                   EXSR      UPDTE
     C                   ENDIF
     C                   ENDIF
      *
     C                   GOTO      RDNXT
     C                   ENDIF
      *
      **  Else, a live Part Sold loan is found.  All attached Parts
      **  Sold loans must be read to check their corresponding
      **  RECIs.
      *
     C                   ELSE
      *
     C                   MOVEL     LNRF          LNRFA
     C     LNRFA         SETLL     SMU002L0
     C     LNRFA         READE     SMU002L0                               06
      *
     C     *IN06         DOWNE     '1'
     C     RECI2         IFEQ      'D'
     C     PTYP          IFEQ      70
     C     PTYP          OREQ      71
     C     PTYP2         IFEQ      72
     C                   ADD       1             CNTNOP
     C                   ENDIF
      *
     C                   ELSE
     C     PTYP2         IFNE      72
     C                   ADD       1             CNTNOP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     LNRF          LNRFA
     C     LNRFA         READE     SMU002L0                               06
     C                   ENDDO
      *
      **  Count number of internal parts purchased.
     C     LNRF          SETLL     SMU002L1
     C     LNRF          READE     SMU002L1                               06
      *
     C     *IN06         DOWNE     '1'
     C     RECIM         IFEQ      'D'
     C     PTYP          IFEQ      70
     C     PTYP          OREQ      71
     C     PTYPM         IFEQ      71
     C                   ADD       1             CNTNOP
     C                   ENDIF
      *
     C                   ELSE
     C     PTYPM         IFEQ      64
     C     PTYPM         OREQ      65
     C     PTYPM         OREQ      68
     C                   ADD       1             CNTNOP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     LNRF          READE     SMU002L1                               06
     C                   ENDDO
      *
      **  Write details to SMU00063P1 if the loan is in error.
     C     NOPS          IFNE      CNTNOP
     C                   ADD       1             COUNT
      *
     C                   MOVEL     LNRF          LNRFA
     C     LNRFA         SETLL     SMU002L0
     C     LNRFA         READE     SMU002L0                               06
      *
     C                   MOVE      'Y'           WRECO1            1
      *
     C     *IN06         DOWNE     '1'
      *
     C                   MOVE      'S'           WTYP
     C                   EXSR      PRINT
      *
     C                   MOVEL     LNRF          LNRFA
     C     LNRFA         READE     SMU002L0                               06
     C                   ENDDO
      *
     C     LNRF          SETLL     SMU002L1
     C     LNRF          READE     SMU002L1                               06
      *
     C     *IN06         DOWNE     '1'
      *
     C                   MOVE      'P'           WTYP
     C                   EXSR      PRINT
      *
     C                   MOVEL     LNRF          LNRFA
     C     LNRF          READE     SMU002L1                               06
     C                   ENDDO
      *
      **  If UPDATE mode and CNTNOP is different from NOPS of the
      **  original loan, update NOPS with CNTNOP value.
     C     *IN01         IFEQ      '1'
     C     NOPS          ANDNE     CNTNOP
     C                   Z-ADD     CNTNOP        NOPS
     C                   EXSR      UPDTE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  Read next record.
     C     RDNXT         TAG                                                    ** RDNXT **
      *
     C                   READ      CLOANCLF                               03
     C                   Z-ADD     0             CNTNOP
     C                   MOVE      ' '           WTYP
     C                   MOVE      '0'           *IN07
      *
     C                   ENDDO
      *
      **  Print end of report
     C     COUNT         IFEQ      0
     C                   MOVE      *ON           *IN02
     C                   WRITE     END
     C                   ELSE
     C     WCTR          IFLT      42
     C                   WRITE     TOTALS
     C                   WRITE     END
     C                   ELSE
     C                   WRITE     PAGHDG
     C                   WRITE     DETHDG
     C                   WRITE     TOTALS
     C                   WRITE     END
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDPGM        TAG                                                    ** ENDPGM **
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/PRINT
      *****************************************************************
      *                                                               *
      *  PRINT - Subroutine to print the report.                      *
      *                                                               *
      *  Called By: PROCD                                             *
      *  Calls : --                                                   *
      *                                                               *
      *****************************************************************
      *
     C     PRINT         BEGSR                                                  *** PRINT ***
      *
     C**********         Z-ADD     LNRF          WLNRF1                                       CLE148
     C                   MOVEL     LNRF          WLNRF1                                       CLE148
     C                   MOVE      RECI          WRECI1
     C                   MOVE      LTYP          WLTYP1
     C                   MOVE      SUTP          WSUTP1
     C                   Z-ADD     PTYP          WPTYP1
     C     *IN09         IFEQ      '0'
     C                   Z-ADD     NOPS          WNOPS1
     C                   ELSE
     C                   Z-ADD     CNTNOP        WNOPS1
     C                   ENDIF
      *
      ** Print part sold or part purchased detail
      *
     C     WTYP          IFEQ      'S'
     C**********         Z-ADD     LNRF2         WLNRF2                                       CLE148
     C                   MOVEL     LNRF2         WLNRF2                                       CLE148
     C                   Z-ADD     PTYP2         WPTYP2
     C                   MOVE      RECI2         WRECI2
     C                   ELSE
     C**********         Z-ADD     LNRFM         WLNRF2                                       CLE148
     C                   MOVEL     LNRFM         WLNRF2                                       CLE148
     C                   Z-ADD     PTYPM         WPTYP2
     C                   MOVE      RECIM         WRECI2
     C                   ENDIF
      *
     C     *IN07         IFEQ      '1'
     C                   MOVE      ' '           WRECI2
     C                   ENDIF
      *
      **  Process report lines.  Write DETAIL if it is the firt Parts
      **  Sold loan record.  Otherwise, DETAIL2 will be written.
     C     WRECO1        IFEQ      'Y'
     C                   MOVE      'N'           WRECO1
      *
     C     WCTR          IFLT      44
     C     COUNT         ANDGT     0
     C                   WRITE     DETAIL
     C                   ADD       1             WCTR
     C                   ELSE
     C                   WRITE     PAGHDG
     C                   WRITE     DETHDG
     C                   WRITE     DETAIL
     C                   Z-ADD     1             WCTR
     C                   ENDIF
      *
      **  Its is the 2ND, 3RD... etc Parts Sold loan record, write
      **  only LNRF2 and RECI2 on the detail line.
     C                   ELSE
      *
     C     WCTR          IFLT      44
     C     COUNT         ANDGT     0
     C                   WRITE     DETAIL2
     C                   ADD       1             WCTR
     C                   ELSE
     C                   WRITE     PAGHDG
     C                   WRITE     DETHDG
     C                   WRITE     DETAIL2
     C                   Z-ADD     1             WCTR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/UPDTE
      *****************************************************************
      *                                                               *
      *  UPDTE - Subroutine to update CLOANCL with correct NOPS value *
      *                                                               *
      *  Called By: PROCD                                             *
      *  Calls : -- *PSSR                                             *
      *                                                               *
      *****************************************************************
      *
     C     UPDTE         BEGSR                                                  *** UPDTE ***
      *
     C                   UPDATE    CLOANCLF                             05
      *
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SC201762'    DBPGM
     C                   MOVE      '01'          DBPGM
     C                   MOVEL     '*UPDATE'     DBKEY
     C                   MOVEL     'CLOANCL '    DBFILE                         ************
     C                   Z-ADD     3             DBASE                          * DBERR 03 *
     C                   OUT       LDA                                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called By: INIT; UPDTE                                       *
      *  Calls : --                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR ***
     C                   WRITE     DBERR
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
