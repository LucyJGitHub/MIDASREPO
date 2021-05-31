     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Display RDEs    Display file')
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG1010   Display RDEs              Display file              *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG2330            Date 29Apr04               *
      *                 CAAA03             Date 30Mar04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 S01522             Date 22Nov94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CAAA03 - Webfacing Changes                                   *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  115722 - Comment out references to CGUSRMSG/CGD1001          *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*DSPRCD: Cpysrc Templates Initialise Program F-Spec
     F/COPY WNCPYSRC,CG1010DFPG
     FCG1010DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display RDEs              Display file
      *
     F*CGRDTAL1* IF   E           K DISK    USROPN                                          MD054955
     F**********                           INFDS(INFDS1)                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Report Data Elements      Retrieval index
      *
     F*CGRDTAL0* IF   E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * UPD : Report Data Elements      Update index
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
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program E-Spec
     D/COPY WNCPYSRC,CG1010DEPG
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
     D CGRDTA        E DS                  EXTNAME(CGRDTJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program I-Spec
     D/COPY WNCPYSRC,CG1010DIPG
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
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            10
      * KEY: Report Data Elements      Retrieval index
      * B : MAP Report Data Element
     D  P2RDE                  1     10
     D O2PARM          DS            10
      * KEY: Report Data Elements      Retrieval index
      * B : MAP Report Data Element
     D  O2RDE                  1     10
     D O3PARM          DS            16
      * KEY: Derived Data Elements     Retrieval index
      * I : RST Report Data Element
     D  O3RDE                  1     10
      * I : MAP Group Set Name
     D  O3GRPS                11     16
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
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Report Dat
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
     C/COPY WNCPYSRC,CG1010DISC
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    RDRDE                          Report Data Ele
      * Setup key
     C                   MOVEL     #2RDE         RDRDE                          Report Data Ele
     C                   IF        RDRDE  = *BLANKS                                         MD054955
     C                   EVAL      RDRDE   = '%'                                            MD054955
     C                   ENDIF                                                              MD054955
     C*****KPOS*         SETLL     @RDTAL1                                                  MD054955
     C**********         READ      @RDTAL1                              8782    *82=EOF     MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRDTJW0                                                              MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D' or RDRDE > :RDRDE and RDRECI = 'D'            MD054955
     C+ order by RDRDE                                                                      MD054955
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
     C+ fetch next from ACursor into :CGRDTA                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        82                    MD054955
     C                   ELSE                                                               MD054955
     C                   SETOFF                                       82                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      * Save previous selector values
     C     *LIKE         DEFINE    #2RECI        WZRECI
     C                   MOVEL     #2RECI        WZRECI                         Record Identifi
     C     *LIKE         DEFINE    #2MAXL        WZMAXL
     C                   MOVEL     #2MAXL        WZMAXL                         Maximum Length
     C     *LIKE         DEFINE    #2ETXT        WZETXT
     C                   MOVEL     #2ETXT        WZETXT                         Example Data
     C     *LIKE         DEFINE    #2DINT        WZDINT
     C                   MOVEL     #2DINT        WZDINT                         Derived Data in
     C     *LIKE         DEFINE    #2SPOS        WZSPOS
     C                   MOVEL     #2SPOS        WZSPOS                         Start Position
     C     *LIKE         DEFINE    #2EPOS        WZEPOS
     C                   MOVEL     #2EPOS        WZEPOS                         End Position
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
     C     *LIKE         DEFINE    #2RDE         WZRDE
     C                   MOVEL     #2RDE         WZRDE                          Report Data Ele
     C     *LIKE         DEFINE    #2ELYP        WZELYP
     C                   MOVEL     #2ELYP        WZELYP                         Element Type
     C     *LIKE         DEFINE    #2DRVD        WZDRVD
     C                   MOVEL     #2DRVD        WZDRVD                         Allow Derived I
     C     *LIKE         DEFINE    #2DSRC        WZDSRC
     C                   MOVEL     #2DSRC        WZDSRC                         Derived Informa
     C     *LIKE         DEFINE    #2DESC        WZDESC
     C                   MOVEL     #2DESC        WZDESC                         Description
     C     *LIKE         DEFINE    #2FOPT        WZFOPT
     C                   MOVEL     #2FOPT        WZFOPT                         Formatting Opti
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2ETXT        WQETXT                         Example Data
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      25            WQA5N             5 0
     C                   PARM      #2ETXT        WQETXT                         Example Data
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
     C     *LIKE         DEFINE    #2DESC        WQDESC                         Description
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2DESC        WQDESC                         Description
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
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
     C**N82*****         READP     @RDTAL1                                90    *           MD054955
     C**N82*****         READ      @RDTAL1                                90    *           MD054955
     C                   If        *IN82 = '0'                                              MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch prior from ACursor into :CGRDTA                                               MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGRDTA                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(37)
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
     C     #2RECI        IFNE      *BLANK                                       Record Identifi
     C     RDRECI        CABNE     #2RECI        BB020                          Record Identifi
     C                   END
     C     #2MAXL        IFNE      *ZERO                                        Maximum Length
     C     RDMAXL        CABNE     #2MAXL        BB020                          Maximum Length
     C                   END
     C     #2ETXT        IFNE      *BLANK                                       Example Data
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    RDETXT                         Example Data
      * Length
     C                   PARM      25            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQETXT
      * Length
     C                   PARM      25            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
     C     #2DINT        IFNE      *BLANK                                       Derived Data in
     C     RDDINT        CABNE     #2DINT        BB020                          Derived Data in
     C                   END
     C     #2SPOS        IFNE      *ZERO                                        Start Position
     C     RDSPOS        CABNE     #2SPOS        BB020                          Start Position
     C                   END
     C     #2EPOS        IFNE      *ZERO                                        End Position
     C     RDEPOS        CABNE     #2EPOS        BB020                          End Position
     C                   END
     C     #2AJOB        IFNE      *BLANK                                       Job name
     C     RDAJOB        CABNE     #2AJOB        BB020                          Job name
     C                   END
     C     #2AUSR        IFNE      *BLANK                                       User name
     C     RDAUSR        CABNE     #2AUSR        BB020                          User name
     C                   END
     C     #2ATIM        IFNE      *ZERO                                        Action Time
     C     RDATIM        CABNE     #2ATIM        BB020                          Action Time
     C                   END
     C     #2ARDT        IFNE      *BLANK                                       Action Date
     C     RDARDT        CABNE     #2ARDT        BB020                          Action Date
     C                   END
     C     #2AACT        IFNE      *BLANK                                       Action Type
     C     RDAACT        CABNE     #2AACT        BB020                          Action Type
     C                   END
     C     #2RDNB        IFNE      *ZERO                                        Run day number
     C     RDRDNB        CABNE     #2RDNB        BB020                          Run day number
     C                   END
     C     #2ELYP        IFNE      *BLANK                                       Element Type
     C     RDELYP        CABNE     #2ELYP        BB020                          Element Type
     C                   END
     C     #2DRVD        IFNE      *BLANK                                       Allow Derived I
     C     RDDRVD        CABNE     #2DRVD        BB020                          Allow Derived I
     C                   END
     C     #2DSRC        IFNE      *BLANK                                       Derived Informa
     C     RDDSRC        CABNE     #2DSRC        BB020                          Derived Informa
     C                   END
     C     #2DESC        IFNE      *BLANK                                       Description
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    RDDESC                         Description
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQDESC
      * Length
     C                   PARM      30            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
     C     #2FOPT        IFNE      *BLANK                                       Formatting Opti
     C     RDFOPT        CABNE     #2FOPT        BB020                          Formatting Opti
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
     C/COPY WNCPYSRC,CG1010DISR
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
     C**********         READ      @RDTAL1                                82    *82=EOF     MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGRDTA                                                MD054955
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
     C/COPY WNCPYSRC,CG1010DSCF
      * Change of position specified
     C     WZRDE         CASNE     #2RDE         FBRQRL
     C     WZELYP        CASNE     #2ELYP        FBRQRL
     C     WZDRVD        CASNE     #2DRVD        FBRQRL
     C     WZDSRC        CASNE     #2DSRC        FBRQRL
     C     WZDESC        CASNE     #2DESC        FBRQRL
     C     WZFOPT        CASNE     #2FOPT        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * DSPFIL: Process SF Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process subfile control
     C/COPY WNCPYSRC,CG1010DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * DSPFIL: Final Processing - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Final Processing
     C/COPY WNCPYSRC,CG1010DFPR
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
     C                   MOVEL     *BLANKS       O2RDE
      *
     C                   CALL      'CG1000'                             9090
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
     C                   SETON                                        9837      *
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
     C/COPY WNCPYSRC,CG1010DPCK
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
     C     #1SEL         ANDNE     'G'                                          *IF
     C     #1SEL         ANDNE     '1'                                          *IF
     C     #1SEL         ORNE      '1'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     #1SEL         ANDNE     'G'                                          *IF
     C     P1ACTC        ANDEQ     'S'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     #1SEL         ANDNE     'G'                                          *IF
     C     P1ACTC        ANDEQ     'E'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     #1SEL         ANDNE     'G'                                          *IF
     C     P1ACTC        ANDEQ     'A'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Invalid Action code'
     C                   MOVEL     'CGD1002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
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
     C                   SETON                                        9837      *
     C                   END                                                    *FI
      *
      * Invalid action
      *
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SETON                                        9837      *
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
     C                   KFLD                    #1RDE                          Report Data Ele
      *
      * Only chain if record if live #1RECI is 'D'
      *
     C     #1RECI        IFEQ      'D'
     C*****KYMFL0        CHAIN     @RDTAL0                            90        *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :#1RDE                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
      *
      * Record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGRDTAL0'    W0FILE
     C                   MOVEL     #1RDE         W0KEY                          Report Date E
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ELSE
     C                   MOVEL     #1RECI        RDRECI
     C                   END
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI not equal to 'D'
      *
     C     #1SEL         IFNE      *BLANKS
     C     RDRECI        IFNE      'D'
      * Send message 'Invalid Action code - record deleted'
     C                   MOVEL     'CGD1003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
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
     C                   MOVEA     WKIND0        *IN(37)
     C                   MOVEL     *BLANKS       P0RTN
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * DSPFIL: Process SF rec - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Subfile Record
     C/COPY WNCPYSRC,CG1010DPSR
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
     C                   MOVEL     #1RDE         O2RDE
      *
     C                   CALL      'CG1000'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1SEL         WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: RDE
      *
      * If in error set up return code
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END
      *
      * Derived Group Sets
      *
     C     #1SEL         WHENEQ    'G'
      *
      * Set up parameters
      *
     C     P1ACTC        IFEQ      'A'
     C                   MOVEL     'a'           #USEL             1            Action Code
     C                   ELSE
     C                   MOVEL     'e'           #USEL                          Action Code
     C                   END
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       O3PARM
     C                   MOVEL     #1RDE         O3RDE
      *
     C                   CALL      'CG1150'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      #USEL         WP0001            1            Action Code
     C                   PARM                    O3PARM                         KEY: RDE
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
     C                   MOVEL     #1RDE         P2RDE
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
     C                   SETON                                        9837      *
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
     C                   SETON                                        9837      *
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
      * Move @RDTAL1 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     RDRECI        #1RECI                         Record Identifi
     C                   MOVEL     RDFOPT        #1FOPT                         Formatting Opti
     C                   Z-ADD     RDMAXL        #1MAXL                         Maximum Length
     C                   MOVEL     RDETXT        #1ETXT                         Example Data
     C                   MOVEL     RDDINT        #1DINT                         Derived Data in
     C                   Z-ADD     RDSPOS        #1SPOS                         Start Position
     C                   Z-ADD     RDEPOS        #1EPOS                         End Position
     C                   MOVEL     RDAJOB        #1AJOB                         Job name
     C                   MOVEL     RDAUSR        #1AUSR                         User name
     C                   Z-ADD     RDATIM        #1ATIM                         Action Time
     C                   MOVEL     RDARDT        #1ARDT                         Action Date
     C                   MOVEL     RDAACT        #1AACT                         Action Type
     C                   Z-ADD     RDRDNB        #1RDNB                         Run day number
     C                   MOVEL     RDRDE         #1RDE                          Report Data Ele
     C                   MOVEL     RDELYP        #1ELYP                         Element Type
     C                   MOVEL     RDDRVD        #1DRVD                         Allow Derived I
     C                   MOVEL     RDDSRC        #1DSRC                         Derived Informa
     C                   MOVEL     RDDESC        #1DESC                         Description
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *
      * If deleted stop subfile selection and place deleted in
      * access point
      *
     C     #1RECI        IFEQ      '*'                                          Record Identifi
     C                   MOVEL     *BLANKS       #1DESC                         Special Instruc
     C                   MOVEL     U#DELT        #1DESC
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
     C/COPY WNCPYSRC,CG1010DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #2RECI                         Record Identifi
     C                   Z-ADD     *ZERO         #2MAXL                         Maximum Length
     C                   MOVEL     *BLANK        #2ETXT                         Example Data
     C                   MOVEL     *BLANK        #2DINT                         Derived Data in
     C                   Z-ADD     *ZERO         #2SPOS                         Start Position
     C                   Z-ADD     *ZERO         #2EPOS                         End Position
     C                   MOVEL     *BLANK        #2AJOB                         Job name
     C                   MOVEL     *BLANK        #2AUSR                         User name
     C                   Z-ADD     *ZERO         #2ATIM                         Action Time
     C                   MOVEL     *BLANK        #2ARDT                         Action Date
     C                   MOVEL     *BLANK        #2AACT                         Action Type
     C                   Z-ADD     *ZERO         #2RDNB                         Run day number
     C                   MOVEL     P2RDE         #2RDE                          Report Data Ele
     C                   MOVEL     *BLANK        #2ELYP                         Element Type
     C                   MOVEL     *BLANK        #2DRVD                         Allow Derived I
     C                   MOVEL     *BLANK        #2DSRC                         Derived Informa
     C                   MOVEL     *BLANK        #2DESC                         Description
     C                   MOVEL     *BLANK        #2FOPT                         Formatting Opti
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
     C                   PARM      'CGD1027'     #MSGID
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
     C**********           PARM 'CGD1026' #MSGID                                              CAAA03
     C                   PARM      'CGD1103'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C**********           PARM 'CGD1103' #MSGID                                              CAAA03
     C                   PARM      'CGD1028'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Update screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1029'     #MSGID
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
     C                   PARM      'CGD1102'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1031'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
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
     C                   PARM      'CGD1032'     #MSGID
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
     C                   PARM      'CGD1104'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Allow function key 12
      *
     C                   MOVEL     '1'           *IN78
      *
     C                   ENDSL
      *================================================================
     CSR   MEEXIT        ENDSR
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
     C/COPY WNCPYSRC,CG1010DEPP
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
                                                                                            MD054955
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
     C                   Z-ADD     09            ##SFPG            3 0          SFLPAG
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
     C                   MOVEA     CPY@          BIS@             80
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
      * Open file CGRDTAL1
      *
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file CGRDTAL1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'CGRDTAL1'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C**********         CALL      'QCMDEXC'                              90    90          MD054955
     C**********         PARM                    OVRDBF                                     MD054955
     C**********         PARM                    CMDLEN                                     MD054955
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
     C**********         OPEN      CGRDTAL1                                                 MD054955
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      * Open file CGRDTAL0
      *
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file MEINMVL0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'CGRDTAL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C**********         CALL      'QCMDEXC'                              90    90          MD054955
     C**********         PARM                    OVRDBF                                     MD054955
     C**********         PARM                    CMDLEN                                     MD054955
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
     C**********         OPEN      CGRDTAL0                                                 MD054955
     C                   MOVEL     'Y'           FIL002            1
     C                   END
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
     C     *LIKE         DEFINE    #1DESC        U#DELT
     C                   MOVEL     #MSTX1        U#DELT
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSC022'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                51
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     21            W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CSC022
      * DSPFIL: Initialise Prog. - R10 Copy source templates  *
     C*DSPRCD: Cpysrc Templates Initialise Program C-Spec
     C/COPY WNCPYSRC,CG1010DCPG
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     C*
     C* PSSR Processing
     C*
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     O*DSPRCD: Cpysrc Templates Initialise Program O-Spec
     O/COPY WNCPYSRC,CG1010DOPG
**  CPY@
(c) Finastra International Limited 2001
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
