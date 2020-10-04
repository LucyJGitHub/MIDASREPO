     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
     H*CVTOPT*(*GRAPHIC)***********************************************            MD054955 MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Display Corr. Sched Display file')
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG0290 - Display Corr. Schedules   Display file              *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 095467             Date 24Oct95               *
      *                 089273             Date 12May95               *
      *                 S01522             Date 21Nov94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  115722 - Comment out references to CGUSRMSG/CGD1001          *
      *  095467 - New order on screen via LA logical                  *
      *  089273 - Show account code if entered                        *
      *  S01522 - User Defined correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*DSPRCD: Cpysrc Templates Initialise Program F-Spec
     F/COPY WNCPYSRC,CG0290DFPG
     FCG0290DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display Corr. Schedules   Display file
      *
     F**CGCSCHL1IF**E           K        DISK                           UC095467
     F*CGCSCHLA* IF   E           K DISK    USROPN                               095467     MD054955
     F**********                           INFDS(INFDS1)                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Correspondent Schedule    Retrieval index
      *
     F*CGCSCHL0* IF   E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * UPD : Correspondent Schedule    Update index
      *
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Details     Retrieval index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)
      **                                                                                      CSC022
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program E-Spec
     D/COPY WNCPYSRC,CG0290DEPG
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
      *COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program I-Spec
     D/COPY WNCPYSRC,CG0290DIPG
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            33
      * KEY: Correspondent Schedule    Retrieval index
      * I : RST Correspondent
     D  P2CORR                 1     10
      * I : MAP Print Item Type
     D  P2PTYP                11     20
      * I : MAP Print Item Sub-type
     D  P2PSTP                21     30
      * I : MAP Sequence Number
     D  P2SEQN                31     33  0
     D O2PARM          DS            33
      * KEY: Correspondent Schedule    Retrieval index
      * I : RST Correspondent
     D  O2CORR                 1     10
      * I : MAP Print Item Type
     D  O2PTYP                11     20
      * I : MAP Print Item Sub-type
     D  O2PSTP                21     30
      * I : MAP Sequence Number
     D  O2SEQN                31     33  0
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT1)'
      * *SFLSEL
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D W0DATA          DS           256
      *
      *  Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      **                                                                                      CSC022
     D SCCMT           DS           256
     D  WCMTNO                 1      3  0
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** DS for Switchable Features details                                                   CSC022
      **                                                                                      CSC022
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Correspond
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile control
      * DSPFIL: Init. Subfile Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile control
     C/COPY WNCPYSRC,CG0290DISC
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
     C***********          KFLD           CPSEQN           Sequence Number095467
      * Setup key
     C                   MOVEL     #2CORR        CPCORR                         Correspondent
     C                   MOVEL     #2PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #2PSTP        CPPSTP                         Print Item Sub-
     C                   Z-ADD     #2SEQN        CPSEQN                         Sequence Number
     C***********KPOS      SETLL@CSCHL1                                   095467
     C*****KPOS*         SETLL     @CSCHLA                                            09546 MD054955
     C     KRST          KLIST
     C                   KFLD                    CPCORR                         Correspondent
      * Setup key
     C                   MOVEL     #2CORR        CPCORR                         Correspondent
     C***********KRST      READE@CSCHL1                8782*82=EOF        095467
     C*****KRST*         READE     @CSCHLA                              8782    *82=EO09546 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPCORR = :CPCORR and CPRECI = 'D'                                             MD054955
     C+ and CPPTYP >= :CPPTYP and CPPSTP >= :CPPSTP                                         MD054955
     C+ order by CPCORR, CPPTYP, CPPSTP, CPPCOR, CPACCD, CPMACT, CPLGID, CPSEQN             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        82                    MD054955
     C                   ELSE                                                               MD054955
     C                   SETOFF                                       82                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      * Save previous selector values
     C     *LIKE         DEFINE    #2SEQN        WZSEQN
     C                   MOVEL     #2SEQN        WZSEQN                         Sequence Number
     C     *LIKE         DEFINE    #2RECI        WZRECI
     C                   MOVEL     #2RECI        WZRECI                         Record Identifi
     C     *LIKE         DEFINE    #2PSCH        WZPSCH
     C                   MOVEL     #2PSCH        WZPSCH                         Print Schedule
     C     *LIKE         DEFINE    #2PCOR        WZPCOR
     C                   MOVEL     #2PCOR        WZPCOR                         Primary Corresp
     C     *LIKE         DEFINE    #2LGID        WZLGID
     C                   MOVEL     #2LGID        WZLGID                         Language identi
     C     *LIKE         DEFINE    #2ACCD        WZACCD
     C                   MOVEL     #2ACCD        WZACCD                         Account Code
     C     *LIKE         DEFINE    #2NPDT        WZNPDT
     C                   MOVEL     #2NPDT        WZNPDT                         Next Print Date
     C     *LIKE         DEFINE    #2MACT        WZMACT
     C                   MOVEL     #2MACT        WZMACT                         Midas Account I
     C     *LIKE         DEFINE    #2PLAB        WZPLAB
     C                   MOVEL     #2PLAB        WZPLAB                         Print Address L
     C     *LIKE         DEFINE    #2SFDY        WZSFDY
     C                   MOVEL     #2SFDY        WZSFDY                         Frequency Day N
     C     *LIKE         DEFINE    #2RETP        WZRETP
     C                   MOVEL     #2RETP        WZRETP                         Retention Perio
     C     *LIKE         DEFINE    #2MSHC        WZMSHC
     C                   MOVEL     #2MSHC        WZMSHC                         Mail Shot code
     C     *LIKE         DEFINE    #2OSQN        WZOSQN
     C                   MOVEL     #2OSQN        WZOSQN                         Output Sequence
     C     *LIKE         DEFINE    #2NPAG        WZNPAG
     C                   MOVEL     #2NPAG        WZNPAG                         Number of Pages
     C     *LIKE         DEFINE    #2TPAG        WZTPAG
     C                   MOVEL     #2TPAG        WZTPAG                         Total Number of
     C     *LIKE         DEFINE    #2RDTE        WZRDTE
     C                   MOVEL     #2RDTE        WZRDTE                         Reset Date
     C     *LIKE         DEFINE    #2RFRQ        WZRFRQ
     C                   MOVEL     #2RFRQ        WZRFRQ                         Reset Frequency
     C     *LIKE         DEFINE    #2CCCY        WZCCCY
     C                   MOVEL     #2CCCY        WZCCCY                         Charge Currency
     C     *LIKE         DEFINE    #2CITM        WZCITM
     C                   MOVEL     #2CITM        WZCITM                         Charge per item
     C     *LIKE         DEFINE    #2BSNB        WZBSNB
     C                   MOVEL     #2BSNB        WZBSNB                         Charge Not Post
     C     *LIKE         DEFINE    #2CACC        WZCACC
     C                   MOVEL     #2CACC        WZCACC                         Charge Accumlat
     C     *LIKE         DEFINE    #2CFRQ        WZCFRQ
     C                   MOVEL     #2CFRQ        WZCFRQ                         Post charge fre
     C     *LIKE         DEFINE    #2NTDT        WZNTDT
     C                   MOVEL     #2NTDT        WZNTDT                         Next Post Date
     C     *LIKE         DEFINE    #2ACHG        WZACHG
     C                   MOVEL     #2ACHG        WZACHG                         Apply Charge
     C     *LIKE         DEFINE    #2CACT        WZCACT
     C                   MOVEL     #2CACT        WZCACT                         Charge Account
     C     *LIKE         DEFINE    #2PDAY        WZPDAY
     C                   MOVEL     #2PDAY        WZPDAY                         Post Charges da
     C     *LIKE         DEFINE    #2AJOB        WZAJOB
     C                   MOVEL     #2AJOB        WZAJOB                         Job name
     C     *LIKE         DEFINE    #2AUSR        WZAUSR
     C                   MOVEL     #2AUSR        WZAUSR                         User name
     C     *LIKE         DEFINE    #2ATIM        WZATIM
     C                   MOVEL     #2ATIM        WZATIM                         Action Time
     C     *LIKE         DEFINE    #2ARDT        WZARDT
     C                   MOVEL     #2ARDT        WZARDT                         Action Date
     C     *LIKE         DEFINE    #2AACT        WZAACT
     C                   MOVEL     #2AACT        WZAACT                         Action Type
     C     *LIKE         DEFINE    #2RDNB        WZRDNB
     C                   MOVEL     #2RDNB        WZRDNB                         Run day number
     C     *LIKE         DEFINE    #2PTYP        WZPTYP
     C                   MOVEL     #2PTYP        WZPTYP                         Print Item Type
     C     *LIKE         DEFINE    #2PSTP        WZPSTP
     C                   MOVEL     #2PSTP        WZPSTP                         Print Item Sub-
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in read-ahead record
     C   27              DO
     C**N82******          READP@CSCHL1                  90*              095467
     C**N82******          READ @CSCHL1                  90*              095467
     C**N82*****         READP     @CSCHLA                                90    *    09546  MD054955
     C**N82*****         READ      @CSCHLA                                90    *    09546  MD054955
     C                   If        *IN82 = '0'                                              MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch prior from ACursor into :CGCSCH                                               MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(33)
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *................................................................
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C******IN82         DOWEQ     '0'                                          DO          MD054955
     C*****##RROK        ANDLT     ##SFLN                                                   MD054955
     C*****##RRRD        ANDLT     W0SLM                                                    MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C                             and ##RROK < ##SFLN                                      MD054955
     C                             and ##RRRD < W0SLM                                       MD054955
      * Check selection fields - if fail, read next record
     C     #2PTYP        IFEQ      *BLANK                                       Print Item Type
     C     #2PSTP        OREQ      *BLANK                                       Print Item Sub-
     C     #2SEQN        IFNE      *ZERO                                        Sequence Number
     C     CPSEQN        CABNE     #2SEQN        BB020                          Sequence Number
     C                   END
     C                   END
     C     #2RECI        IFNE      *BLANK                                       Record Identifi
     C     CPRECI        CABNE     #2RECI        BB020                          Record Identifi
     C                   END
     C     #2PSCH        IFNE      *BLANK                                       Print Schedule
     C     CPPSCH        CABNE     #2PSCH        BB020                          Print Schedule
     C                   END
     C     #2PCOR        IFNE      *BLANK                                       Primary Corresp
     C     CPPCOR        CABNE     #2PCOR        BB020                          Primary Corresp
     C                   END
     C     #2LGID        IFNE      *BLANK                                       Language identi
     C     CPLGID        CABNE     #2LGID        BB020                          Language identi
     C                   END
     C     #2ACCD        IFNE      *BLANK                                       Account Code
     C     CPACCD        CABNE     #2ACCD        BB020                          Account Code
     C                   END
     C     #2NPDT        IFNE      *ZERO                                        Next Print Date
     C     CPNPDT        CABNE     #2NPDT        BB020                          Next Print Date
     C                   END
     C     #2MACT        IFNE      *BLANK                                       Midas Account I
     C     CPMACT        CABNE     #2MACT        BB020                          Midas Account I
     C                   END
     C     #2PLAB        IFNE      *BLANK                                       Print Address L
     C     CPPLAB        CABNE     #2PLAB        BB020                          Print Address L
     C                   END
     C     #2SFDY        IFNE      *ZERO                                        Frequency Day N
     C     CPSFDY        CABNE     #2SFDY        BB020                          Frequency Day N
     C                   END
     C     #2RETP        IFNE      *ZERO                                        Retention Perio
     C     CPRETP        CABNE     #2RETP        BB020                          Retention Perio
     C                   END
     C     #2MSHC        IFNE      *BLANK                                       Mail Shot code
     C     CPMSHC        CABNE     #2MSHC        BB020                          Mail Shot code
     C                   END
     C     #2OSQN        IFNE      *ZERO                                        Output Sequence
     C     CPOSQN        CABNE     #2OSQN        BB020                          Output Sequence
     C                   END
     C     #2NPAG        IFNE      *ZERO                                        Number of Pages
     C     CPNPAG        CABNE     #2NPAG        BB020                          Number of Pages
     C                   END
     C     #2TPAG        IFNE      *ZERO                                        Total Number of
     C     CPTPAG        CABNE     #2TPAG        BB020                          Total Number of
     C                   END
     C     #2RDTE        IFNE      *ZERO                                        Reset Date
     C     CPRDTE        CABNE     #2RDTE        BB020                          Reset Date
     C                   END
     C     #2RFRQ        IFNE      *BLANK                                       Reset Frequency
     C     CPRFRQ        CABNE     #2RFRQ        BB020                          Reset Frequency
     C                   END
     C     #2CCCY        IFNE      *BLANK                                       Charge Currency
     C     CPCCCY        CABNE     #2CCCY        BB020                          Charge Currency
     C                   END
     C     #2CITM        IFNE      *ZERO                                        Charge per item
     C     CPCITM        CABNE     #2CITM        BB020                          Charge per item
     C                   END
     C     #2BSNB        IFNE      *ZERO                                        Charge Not Post
     C     CPBSNB        CABNE     #2BSNB        BB020                          Charge Not Post
     C                   END
     C     #2CACC        IFNE      *ZERO                                        Charge Accumlat
     C     CPCACC        CABNE     #2CACC        BB020                          Charge Accumlat
     C                   END
     C     #2CFRQ        IFNE      *BLANK                                       Post charge fre
     C     CPCFRQ        CABNE     #2CFRQ        BB020                          Post charge fre
     C                   END
     C     #2NTDT        IFNE      *ZERO                                        Next Post Date
     C     CPNTDT        CABNE     #2NTDT        BB020                          Next Post Date
     C                   END
     C     #2ACHG        IFNE      *BLANK                                       Apply Charge
     C     CPACHG        CABNE     #2ACHG        BB020                          Apply Charge
     C                   END
     C     #2CACT        IFNE      *BLANK                                       Charge Account
     C     CPCACT        CABNE     #2CACT        BB020                          Charge Account
     C                   END
     C     #2PDAY        IFNE      *ZERO                                        Post Charges da
     C     CPPDAY        CABNE     #2PDAY        BB020                          Post Charges da
     C                   END
     C     #2AJOB        IFNE      *BLANK                                       Job name
     C     CPAJOB        CABNE     #2AJOB        BB020                          Job name
     C                   END
     C     #2AUSR        IFNE      *BLANK                                       User name
     C     CPAUSR        CABNE     #2AUSR        BB020                          User name
     C                   END
     C     #2ATIM        IFNE      *ZERO                                        Action Time
     C     CPATIM        CABNE     #2ATIM        BB020                          Action Time
     C                   END
     C     #2ARDT        IFNE      *BLANK                                       Action Date
     C     CPARDT        CABNE     #2ARDT        BB020                          Action Date
     C                   END
     C     #2AACT        IFNE      *BLANK                                       Action Type
     C     CPAACT        CABNE     #2AACT        BB020                          Action Type
     C                   END
     C     #2RDNB        IFNE      *ZERO                                        Run day number
     C     CPRDNB        CABNE     #2RDNB        BB020                          Run day number
     C                   END
     C     #2PTYP        IFEQ      *BLANK                                       Print Item Type
     C     #2PSTP        IFNE      *BLANK                                       Print Item Sub-
     C     CPPSTP        CABNE     #2PSTP        BB020                          Print Item Sub-
     C                   END
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C                   EXSR      MC#1FN
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
      * USER: Initialize subfile record from DBF record
      * DSPFIL: Init. SF record - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile record
     C/COPY WNCPYSRC,CG0290DISR
     C                   SUB       1             ##RR
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C***********KRST      READE@CSCHL1                  82*82=EOF        095467
     C*****KRST*         READE     @CSCHLA                                82    *82=EO09546 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         TAG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      *
      * Reset Action taken
      *
     C                   MOVEL     *BLANKS       #ENTER            1
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8392    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * CALC: Subfile control function fields
      * DSPFIL: Cal. Control flds - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Calculate Control fields
     C/COPY WNCPYSRC,CG0290DSCF
      * Change of position specified
     C     WZPTYP        CASNE     #2PTYP        FBRQRL
     C     WZPSTP        CASNE     #2PSTP        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * DSPFIL: Process SF Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process subfile control
     C/COPY WNCPYSRC,CG0290DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * DSPFIL: Final Processing - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Final Processing
     C/COPY WNCPYSRC,CG0290DFPR
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *
      * CASE: CTL.*CMD key is CF09
      *
      *
      * Call add processing
      *
     C     *IN09         IFEQ      '1'                                          *IF
      *
      * Action taken
      *
     C                   MOVEL     'Y'           #ENTER
      *
      * Check user has access to add
      *
     C                   MOVEL     'I'           #1SEL
     C                   EXSR      SRMBIN
      *
      * User does not have access
      *
     C     *IN99         IFEQ      '1'                                          *IF
     C                   GOTO      DAEXIT
     C                   END                                                    *FI
      *
      * Set up parameters
      *
     C                   CLEAR                   O2PARM
     C                   MOVEL     #2CORR        O2CORR                         Correspondent
      *
     C                   CALL      'CG0280'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      'I'           WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END                                                    *FI
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
      *
     C**Send*message*'F12*taken*from*previous*screen'*****************    115722
     C*                                                                   115722
     C*********************MOVEL'CGD1001' ZAMSID                          115722
     C*********************EXSR ZASNMS                                    115722
     C                   GOTO      DAEXIT
      *
      *  F3 pressed - exit program
      *
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *  If error redisplay
      *
     C     P0RTN         WHENNE    *BLANKS                                      *IF
      *
      * Re-display screen
      *
     C                   MOVEL     'CGD1000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DAEXIT
      *
      *  New selection - redisplay subfile
      *
     C     P0RTN         WHENEQ    *BLANKS                                      *IF
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DAEXIT
     C                   ENDSL                                                  *LS
     C                   ENDIF                                                  *FI
      * USER: Process command keys
      * DSPFIL: Process Cmd keys - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,CG0290DPCK
      *
      * If no Action taken and F12 and not select exit
      *
     C     #ENTER        IFEQ      *BLANKS
     C     *IN78         ANDEQ     '1'
     C     P1ACTC        ANDNE     'S'
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
     C                   EXSR      ZXEXPG
     C                   ENDIF
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Read first changed slf record
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      *
      * Action taken
      *
     C                   MOVEL     'Y'           #ENTER
      * Process subfile record
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
      *
      * If F12 then redisplay screen with action code
      * Or action did not complete
      *
     C     P0RTN         IFNE      *BLANKS                                      *Return code
     C                   MOVEL     *BLANKS       P0RTN
     C                   GOTO      DBEXIT
     C                   END
      *
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
      *================================================================
     C*                                                               *
     C* SRACTD - Check Action code                                    *
     C*                                                               *
     C*                                                               *
     C* Called by: DCPRSR                                             *
     C*                                                               *
      *================================================================
     CSR   SRACTD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
      *
      * Check all valid actions
      *
      *
      * CASE: RCD.*SFLSEL is not valid
      *
     C     #1SEL         IFEQ      ' '                                          *IF
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
     C     #1SEL         IFNE      'E'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     #1SEL         ANDNE     '1'                                          *IF
     C     #1SEL         ORNE      '1'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     P1ACTC        ANDEQ     'S'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     P1ACTC        ANDEQ     'E'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     P1ACTC        ANDEQ     'A'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Invalid Action code'
     C                   MOVEL     'CGD1002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
      * Check multi-branch actions
      *
     C                   EXSR      SRMBIN
      *
      *  Unwind subroutine stack name
      *
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
     C*                                                               *
     C* SRMBIN - Check Multi-branch actions                           *
     C*                                                               *
     C*                                                               *
     C* Called by: SRACTD                                             *
     C*                                                               *
      *================================================================
     CSR   SRMBIN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMBIN'      @STK(Q)
      *
      * Set up parameters
      *
     C                   CLEAR                   W0DATA
     C                   MOVEL     *BLANKS       B#BRCA
     C                   MOVEL     #1SEL         O#ACTD
     C                   MOVEL     ##PGM         O#CPGM
      *
     C     #1SEL         IFEQ      '1'                                          *IF
     C                   MOVEL     'X'           O#ACTD
     C                   END                                                    *FI
      *
      * Check all valid actions
      *
     C                   CALL      'CG1020'                             9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      '*ACTCODE'    W0ACT             8
     C                   PARM                    W0DATA
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
     C                   SETON                                        9833      *
     C                   END                                                    *FI
      *
      * Invalid action
      *
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SETON                                        9833      *
     C                   ELSE                                                   *FI
     C                   SETON                                        99        *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      *  Unwind subroutine stack name
      *
     C     EXMBIN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
     C*                                                               *
     C* SRRCHG - Record Changed                                       *
     C*                                                               *
     C*                                                               *
     C* Called by: DCPRSR                                             *
     C*                                                               *
      *================================================================
     CSR   SRRCHG        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRCHG'      @STK(Q)
      *
      * Set up key from subfile record and chain to record
      *
     C     KYMFL0        KLIST
     C                   KFLD                    #1CORR                         Correspondent
     C                   KFLD                    #1PTYP                         Print Item Type
     C                   KFLD                    #1PSTP                         Print Item Sub-
     C                   KFLD                    #1SEQN                         Sequence Number
      *
      * Only chain if record if live #1RECI is 'D'
      *
     C     #1RECI        IFEQ      'D'
     C*****KYMFL0        CHAIN     @CSCHL0                            90        *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPCORR = :#1CORR and CPPTYP = :#1PTYP and CPPSTP = :#1PSTP                    MD054955
     C+ and CPSEQN = :#1SEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
      *
      * Record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGCSCHL0'    W0FILE
     C                   MOVEL     #1CORR        W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ELSE
     C                   MOVEL     #1RECI        CPRECI
     C                   END
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI not equal to 'D'
      *
     C     #1SEL         IFNE      *BLANKS
     C     CPRECI        IFNE      'D'
      * Send message 'Invalid Action code - record deleted'
     C                   MOVEL     'CGD1003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
     C                   END
     C                   GOTO      EXRCHG
     C                   END
      *
      *  Reload subfile record
      *
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
      *
      *  Unwind subroutine stack name
      *
     C     EXRCHG        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(33)
     C                   MOVEL     *BLANKS       P0RTN
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * DSPFIL: Process SF rec - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Subfile Record
     C/COPY WNCPYSRC,CG0290DPSR
      *
      * Check action code is valid, if invalid exit.
      *
     C                   EXSR      SRACTD
      *
      * Check record is active
      *
     C                   EXSR      SRRCHG
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
     C                   END                                                    *FI
      *
      * Call option
      *
     C                   SELECT
      *
      * Amend, Delete and Enquire
      *
     C     #1SEL         WHENEQ    'A'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'E'
      *
      * Set up parameters
      *
     C                   MOVEL     #1CORR        O2CORR                         Correspondent
     C                   MOVEL     #1PTYP        O2PTYP                         Print Item Type
     C                   MOVEL     #1PSTP        O2PSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        O2SEQN                         Sequence Number
      *
     C                   CALL      'CG0280'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1SEL         WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: CTYP
      *
      * If in error set up return code
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END
      *
      * Select
      *
     C     #1SEL         WHENEQ    '1'
     C                   MOVEL     #1CORR        P2CORR                         Correspondent
     C                   MOVEL     #1PTYP        P2PTYP                         Print Item Type
     C                   MOVEL     #1PSTP        P2PSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        P2SEQN                         Sequence Number
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
     C                   EXSR      ZXEXPG
      *
     C                   ENDSL
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END                                                    *FI
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
      *
     C**Send*message*'F12*taken*from*previous*screen'*****************    115722
     C*                                                                   115722
     C*********************MOVEL'CGD1001' ZAMSID                          115722
     C*********************EXSR ZASNMS                                    115722
     C                   SETON                                        9833      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      *  F3 pressed - exit program
      *
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *  If error redisplay
      *
     C     P0RTN         WHENNE    *BLANKS                                      *IF
      *
      * Re-display screen
      *
     C                   MOVEL     'CGD1000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      *  Function completed normally
      *
     C     P0RTN         WHENEQ    *BLANKS                                      *IF
     C                   ENDSL                                                  *LS
      *
     C     DCENDT        TAG
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ELSE
      * SFLRCD valid
      * SFLNXTCHG
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #1SEL
     C                   END                                                    FI *IN98
      *
      *  If option did not end in error, F12 or F3 then update record
      *  with changes
      *
     C     P0RTN         IFEQ      *BLANKS
     C     *IN98         ANDEQ     '0'
     C                   EXSR      SRRCHG
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @CSCHL1 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     CPCORR        #1CORR                         Correspondent
     C                   Z-ADD     CPSEQN        #1SEQN                         Sequence Number
     C                   MOVEL     CPRECI        #1RECI                         Record Identifi
     C                   MOVEL     CPPSCH        #1PSCH                         Print Schedule
     C                   MOVEL     CPACCD        #1ACCD                         Account Code
     C                   Z-ADD     CPNPDT        #1NPDT                         Next Print Date
     C                   Z-ADD     CPSFDY        #1SFDY                         Frequency Day N
     C                   Z-ADD     CPRETP        #1RETP                         Retention Perio
     C                   MOVEL     CPMSHC        #1MSHC                         Mail Shot code
     C                   MOVEL     CPAPDF        #1APDF                         Defaults must b
     C                   Z-ADD     CPOSQN        #1OSQN                         Output Sequence
     C                   Z-ADD     CPNPAG        #1NPAG                         Number of Pages
     C                   Z-ADD     CPTPAG        #1TPAG                         Total Number of
     C                   Z-ADD     CPRDTE        #1RDTE                         Reset Date
     C                   MOVEL     CPRFRQ        #1RFRQ                         Reset Frequency
     C                   MOVEL     CPCCCY        #1CCCY                         Charge Currency
     C                   Z-ADD     CPCITM        #1CITM                         Charge per item
     C                   Z-ADD     CPBSNB        #1BSNB                         Charge Not Post
     C                   Z-ADD     CPCACC        #1CACC                         Charge Accumlat
     C                   MOVEL     CPCFRQ        #1CFRQ                         Post charge fre
     C                   Z-ADD     CPNTDT        #1NTDT                         Next Post Date
     C                   MOVEL     CPACHG        #1ACHG                         Apply Charge
     C                   MOVEL     CPCACT        #1CACT                         Charge Account
     C                   Z-ADD     CPPDAY        #1PDAY                         Post Charges da
     C                   MOVEL     CPAJOB        #1AJOB                         Job name
     C                   MOVEL     CPAUSR        #1AUSR                         User name
     C                   Z-ADD     CPATIM        #1ATIM                         Action Time
     C                   MOVEL     CPARDT        #1ARDT                         Action Date
     C                   MOVEL     CPAACT        #1AACT                         Action Type
     C                   Z-ADD     CPRDNB        #1RDNB                         Run day number
     C                   MOVEL     CPPTYP        #1PTYP                         Print Item Type
     C                   MOVEL     CPPSTP        #1PSTP                         Print Item Sub-
     C                   MOVEL     CPPCOR        #1PCOR                         Primary Corresp
     C                   MOVEL     CPLGID        #1LGID                         Language identi
     C                   MOVEL     CPMACT        #1MACT                         Midas Account I
     C                   MOVEL     CPPLAB        #1PLAB                         Print Address L
      *                                                                   089273
      * If blank account use account code                                 089273
      *                                                                   089273
     C     #1MACT        IFEQ      *BLANKS                                                     08927
     C                   MOVEL     CPACCD        #1MACT                         Account Code   08927
     C                   ENDIF                                                                 08927
      *
      * If deleted stop subfile selection and place deleted in
      * access point
      *
     C     #1RECI        IFEQ      '*'                                          Record Identifi
     C                   MOVEL     *BLANKS       #1PCOR                         Special Instruc
     C                   MOVEL     U#DELT        #1PCOR
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   GOTO      MBEXIT
     C                   END
      *
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * DSPFIL: SF rec func flds - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Subfile Record function fields
     C/COPY WNCPYSRC,CG0290DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   Z-ADD     P2SEQN        #2SEQN                         Sequence Number
     C                   MOVEL     *BLANK        #2RECI                         Record Identifi
     C                   MOVEL     *BLANK        #2PSCH                         Print Schedule
     C                   MOVEL     *BLANK        #2PCOR                         Primary Corresp
     C                   MOVEL     *BLANK        #2LGID                         Language identi
     C                   MOVEL     *BLANK        #2ACCD                         Account Code
     C                   Z-ADD     *ZERO         #2NPDT                         Next Print Date
     C                   MOVEL     *BLANK        #2MACT                         Midas Account I
     C                   MOVEL     *BLANK        #2PLAB                         Print Address L
     C                   Z-ADD     *ZERO         #2SFDY                         Frequency Day N
     C                   Z-ADD     *ZERO         #2RETP                         Retention Perio
     C                   MOVEL     *BLANK        #2MSHC                         Mail Shot code
     C                   Z-ADD     *ZERO         #2OSQN                         Output Sequence
     C                   Z-ADD     *ZERO         #2NPAG                         Number of Pages
     C                   Z-ADD     *ZERO         #2TPAG                         Total Number of
     C                   Z-ADD     *ZERO         #2RDTE                         Reset Date
     C                   MOVEL     *BLANK        #2RFRQ                         Reset Frequency
     C                   MOVEL     *BLANK        #2CCCY                         Charge Currency
     C                   Z-ADD     *ZERO         #2CITM                         Charge per item
     C                   Z-ADD     *ZERO         #2BSNB                         Charge Not Post
     C                   Z-ADD     *ZERO         #2CACC                         Charge Accumlat
     C                   MOVEL     *BLANK        #2CFRQ                         Post charge fre
     C                   Z-ADD     *ZERO         #2NTDT                         Next Post Date
     C                   MOVEL     *BLANK        #2ACHG                         Apply Charge
     C                   MOVEL     *BLANK        #2CACT                         Charge Account
     C                   Z-ADD     *ZERO         #2PDAY                         Post Charges da
     C                   MOVEL     *BLANK        #2AJOB                         Job name
     C                   MOVEL     *BLANK        #2AUSR                         User name
     C                   Z-ADD     *ZERO         #2ATIM                         Action Time
     C                   MOVEL     *BLANK        #2ARDT                         Action Date
     C                   MOVEL     *BLANK        #2AACT                         Action Type
     C                   Z-ADD     *ZERO         #2RDNB                         Run day number
     C                   MOVEL     P2CORR        #2CORR                         Correspondent
     C                   MOVEL     P2PTYP        #2PTYP                         Print Item Type
     C                   MOVEL     P2PSTP        #2PSTP                         Print Item Sub-
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1341'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1026'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'CGD1028'     #UFKEY
     C                   ELSE
     C                   MOVEL     'CGD1021'     #UFKEY
     C                   END
      *
      * Update screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1342'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1030'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'CGD1031'     #UFKEY
     C                   ELSE
     C                   MOVEL     'CGD1052'     #UFKEY
     C                   END
      *
      * Allow function key 9
      *
     C                   MOVEL     '1'           *IN77
      *
      * Selection screen
      *
     C     P1ACTC        WHENEQ    'S'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1343'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1033'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'CGD1028'     #UFKEY
     C                   ELSE
     C                   MOVEL     'CGD1021'     #UFKEY
     C                   END
      *
     C                   ENDSL
      *
      * Function keys
      *
     C     *LIKE         DEFINE    #MSGID        #UFKEY
     C                   CALL      'CGC1000'                            9090
     C                   PARM      #UFKEY        #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      * Check restriction within
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      *
     C     KLVACD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #2CORR        CDCORR                         Correspondent
     C     KLVACD        CHAIN     @CORRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Restrictor relation not satisfied
      * Send message 'Correspondent Details  NF'
     C                   MOVEL     'CGD1157'     ZAMSID
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1157'     P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * DSPFIL: Exit Program Proc - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,CG0290DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'CGUSRMSG'    ZADFMF           10
     C                   Z-ADD     10            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          ACT@             80
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Open file CGCSCHL1
      *
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file CGCSCHL1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C*************        MOVEL'CGCSCHL1'U#FILE 10                       095467
     C                   MOVEL     'CGCSCHLA'    U#FILE           10                           09546
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C***********          OPEN CGCSCHL1                                  095467
     C**********         OPEN      CGCSCHLA                                           09546 MD054955
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      * Open file CGCSCHL0
      *
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file CGCSCHL0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'CGCSCHL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C**********         OPEN      CGCSCHL0                                                 MD054955
     C                   MOVEL     'Y'           FIL002            1
     C                   END
      **                                                                                      CSC022
      ** Initialize CSC022 and Skip Commit/Rollback flags                                     CSC022
      **                                                                                      CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY '    P@OPTN
     C                   PARM      'CSC022'      P@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
      **                                                                                      CSC022
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      **                                                                                      CSC022
     C                   ELSE
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     P@RTCD        IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     5             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      **                                                                                      CSC022
     C                   ENDIF
      **                                                                                      CSC022
      *
      * Allow function key 12 if lower case action
      *
     C                   SELECT
     C     P1ACTC        WHENEQ    's'
     C     P1ACTC        OREQ      'S'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'S'           P1ACTC
     C     P1ACTC        WHENEQ    'e'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'E'           P1ACTC
     C     P1ACTC        WHENEQ    'a'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'A'           P1ACTC
     C                   ENDSL
      *
      * Get deleted text
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1019'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *LIKE         DEFINE    #1PCOR        U#DELT
     C                   MOVEL     #MSTX1        U#DELT
      * DSPFIL: Initialise Prog. - R10 Copy source templates  *
     C*DSPRCD: Cpysrc Templates Initialise Program C-Spec
     C/COPY WNCPYSRC,CG0290DCPG
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     O*DSPRCD: Cpysrc Templates Initialise Program O-Spec
     O/COPY WNCPYSRC,CG0290DOPG
**  CPY@
(c) Finastra International Limited 2001
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
