     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG C/M - Display summary')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG5000 - Correspondence Management: display summary          *
      *                                                               *
      *  Function:  This program displays all selected Correspondence *
      *             items and allows their enquiry/management         *
      *                                                               *
      *  Called By: CG5020 - prompt for selection                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CCG017             Date 23Jun06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 12Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 171050             Date 20Apr00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 120038             Date 05FEB98               *
      *                 103217             DATE 23MAY96               *
      *                 096540             DATE 29NOV95               *
      *                 096539             DATE 29NOV95               *
      *                 095461             DATE 24OCT95               *
      *                 CCG009             DATE 01JUN95               *
      *                 090385             DATE 12JUL95               *
      *                 087281             DATE 04MAY95               *
      *                 086184             DATE 16MAR95               *
      *                 083952             DATE 25FEB95               *
      *                 083783             DATE 15FEB95               *
      *                 S01522             DATE 01FEB95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CCG017 - Reprint by Item ID                                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CCG015 - Correspondence Manager - Phase 1.
      *  171050 - Pass the Branch Code of the corresponance to        *
      *           PGM/CG1020 to correct SPF processing.               *
      *  115722 - Comment out references to CGUSRMSG/CGD1001          *
      *  120038 - Increase the scan limit to 99999.                   *
      *  103217 - Correct 096540.                                     *
      *           Not able to print as UDC_IMMEDS is active,          *
      *           allocate CGRASCPD instead                           *
      *           Use new error message                               *
      *  096540 - Print only allowed if no one editting layouts       *
      *  096539 - Correct Xmas tree look, F12 does not stop           *
      *           sub-file processing and selection fields sometimes  *
      *           are highlighted even though no action taken         *
      *  095461 - Add Correspondent type to selection                 *
      *  090385 - Amend scheduled print date selection criteria.      *
      *  CCG009 - Private Banking UDC                                 *
      *  087281 - Correct size of #WDOR to 10 long                    *
      *  086184 - FC0040X returns with LR on                          *
      *  083952 - Remove V(iew) action code                           *
      *           (Originally wrongly annotated as 083592)            *
      *  083783 - Set Archive variable when requesting Report         *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *DSPRCD: Cpysrc Templates Initialise Program F-Spec
      /COPY WNCPYSRC,CG5000DFPG
     FCG5000DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     SFILE(#SFLRCD2:##RR)                               CCG015
     F                                     INFDS(INFDS#)
      * DSP: Display Reference Records Display file
      *
     F*GUDCRL2IF  E           K        DISK                           UC                      CCG009
     F*CGUDCRL8IF E           K        DISK                           UC             CCG009 MD054955
     FCGUDCRL2  IF   E           K DISK    USROPN                                    CCG009 MD054955
     F                                     INFSR(SRFILE)
      * RSQ : UDC Data Reference        By Correspondent
      *
     F*GXDCRL2IF  E           K        DISK                           UC                      CCG009
     F*CGXDCRL8IF E           K        DISK                           UC             CCG009 MD054955
     FCGXDCRL2  IF   E           K DISK    USROPN                                    CCG009 MD054955
     F                                     INFSR(SRFILE)
      * RSQ : UDC Data Reference (Archive) By Correspondent
      *                                                                                       CCG015
     FCGUDCLL1  IF   E           K DISK    USROPN                                             CCG015
     F                                     INFSR(SRFILE)                                      CCG015
      * RSQ : UDC Data Reference Log By Correspondent                                         CCG015
      *                                                                                       CCG015
     FCGXDCLL1  IF   E           K DISK    USROPN                                             CCG015
     F                                     INFSR(SRFILE)                                      CCG015
      * RSQ : UDC Data Reference Log (Archive) By Correspondent                               CCG015
      *
     FCGCORRL1  IF   E           K DISK    USROPN                                             095461
     F                                     INFSR(SRFILE)                                      095461
      * RTV : Correspondent Details     Retrieval index                                       095461
      *                                                                                       095461
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      **  Array containing Copyright statement
      *
     D********************CMD@    1   1 80                                                    096540
     D CMD@            S             80    DIM(3) CTDATA PERRCD(1)                            096540
      **  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      **  Array of QCMDEXC command to edit
      *
      *COPY*CGCPYSRC,SRERRE                                                                 MD056543
      /COPY CGCPYSRC,SRERRDLE                                                               MD056543
      **  Copysource for error processing
      *
      *DSPRCD: Cpysrc Templates Initialise Program E-Spec
      /COPY WNCPYSRC,CG5000DEPG
      /EJECT
      *COPY*CGCPYSRC,SRERRI                                                                 MD056543
      *  End of Program Error Processing copysource
      *
      *DSPRCD: Cpysrc Templates Initialise Program I-Spec
      /COPY WNCPYSRC,CG5000DIPG
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
      **  Display file information data structure
      *
     D CGDTA         E DS                  EXTNAME(CGDTA)                                     096540
      *                                                                                       096540
      *  Definition of CGDTA                                                                  096540
      *                                                                                       096540
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      **  Get Rundate - Rundate  *
      *
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      **  Modules Data Structure *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Data Structures used by Access Programs
      *
      * Parameter declarations
     D P0PARM          DS
     D  P#DCOR                 1     10
     D  P#PCOR                11     20
     D  P#BRCA                21     23
     D  P#MODI                24     25
     D  P#MTRN                26     40
     D  P#OVBR                41     43
     D**********                             44  61 P#MACT                                    CGL029
     D  QQMACT                44     61                                                       CGL029
     D  P#ISTS                62     65
     D  P#PRTD                66     70  0
     D  P#PTYP                71     80
     D  P#PSTP                81     90
     D  P#LGID                91     92
     D  P#ATRM                93     93
     D  P#CTYP                94    103                                                       095461
     D  P#MACT               104    127                                                       CGL029
     D  P#ITEM               128    135  0                                                    CGL017
      *
     D                 DS
     D  ZAMSDA                 1    132
      **  Message data for 'Invalid Action code (FT1)'
      * *SFLSEL
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      **  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D #LPARM          DS            15
      **  Parameter for lower link + print request type if needed
     D  #1ITEM                 1      5P 0
     D  #1DCOR                 6     15
      *
     D #KPOS           DS
      **  Key data for database error.
     D  #KITEM                 1      9  0
     D  #KDCOR                10     19
      *
     D*#WPARM******DS                             93                                          083783
     D #WPARM          DS           100                                                       083783
      **  Parameter for print request
     D  #WITEM                 1      8  0
     D************                            9  17 #WDCOR                                    087281
     D  #WDCOR                 9     18                                                       087281
     D  #WGPTR                64     71                                                       CCG009
     D  #WFINL                93     93
     D  #WARCH                94     94                                                       083783
      *
     D W0DATA          DS           256
      **  Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
     D P2PARM          DS           256
      * RCD: UDC Data Reference Log    Retrieval index
      * I : RST Item Identifier
     D  P2ITEM                 1      5P 0
      * I : RST Destination Correspondent
     D  P2DCOR                 6     15
      * I : MAP Date of Action
     D  P2DTAC                16     18P 0
      * I : MAP Action Time
     D  P2ATIM               242    245P 0
      *
     D P0KEYI          DS           100
      **  Define data structure used to pass parameters
      *
     D  ##ARCH                 1     10
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CCG015
      ** MIDAS Switchable Features Accessed Via Access Program                                CCG015
      *                                                                                       CCG015
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P0PARM
     C                   PARM                    P0ACTC            1
     C                   PARM                    P0KEYI
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
      *                                                                                       CCG015
      ** Use subfile with 'PDF File Name' heading if Correspondence                           CCG015
      ** Manager is set. Otherwise use the original with 'Print Type                          CCG015
      ** / Subtype' column.                                                                   CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   WRITE     #SFLCTL2                                                   CCG015
     C                   ELSE                                                                 CCG015
     C                   WRITE     #SFLCTL
     C                   ENDIF                                                                CCG015
      *
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile control
      * DSPFIL: Init. Subfile Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile control
      /COPY WNCPYSRC,CG5000DISC
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    DRDCOR                         Destination Cor
     C                   KFLD                    DRITEM                         Item Identifier
      * Setup key
     C                   MOVEL     #2DCOR        DRDCOR                         Destination Cor
     C                   Z-ADD     *ZERO         DRITEM                         Item Identifier
      *
     C     ##ARCH        IFEQ      'ARCHIVE '
     C***********KPOS      SETLL@XDCRL2                                                       CCG009
     C***********          READ @XDCRL2                  82*82=EOF                            CCG009
     C********** KPOS      SETLL@XDCRL8                                              CCG009 MD054955
     C**********           READ @XDCRL8                  82*82=EOF                   CCG009 MD054955
     C     KPOS          SETLL     @XDCRL2                                                    CCG009
     C                   READ      @XDCRL2                                82    *82=EOF       CCG009
     C                   ELSE
     C***********KPOS      SETLL@UDCRL2                                                       CCG009
     C***********          READ @UDCRL2                  82*82=EOF                            CCG009
     C********** KPOS      SETLL@UDCRL8                                              CCG009 MD054955
     C**********           READ @UDCRL8                  82*82=EOF                   CCG009 MD054955
     C     KPOS          SETLL     @UDCRL2                                                    CCG009
     C                   READ      @UDCRL2                                82    *82=EOF       CCG009
     C                   ENDIF
      * Save previous selector values
     C     *LIKE         DEFINE    #2DCOR        WZDCOR
     C                   MOVEL     #2DCOR        WZDCOR                         Destination Cor
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
     C     ##ARCH        IFEQ      'ARCHIVE '
     C**N82******          READP@XDCRL2                  90*                                  CCG009
     C**N82******          READ @XDCRL2                  90*                                  CCG009
     C**N82*****           READP@XDCRL8                  90*                         CCG009 MD054955
     C**N82*****           READ @XDCRL8                  90*                         CCG009 MD054955
     C  N82              READP     @XDCRL2                                90    *             CCG009
     C  N82              READ      @XDCRL2                                90    *             CCG009
     C                   ELSE
     C**N82******          READP@UDCRL2                  90*                                  CCG009
     C**N82******          READ @UDCRL2                  90*                                  CCG009
     C**N82*****           READP@UDCRL8                  90*                         CCG009 MD054955
     C**N82*****           READ @UDCRL8                  90*                         CCG009 MD054955
     C  N82              READP     @UDCRL2                                90    *             CCG009
     C  N82              READ      @UDCRL2                                90    *             CCG009
     C                   ENDIF
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(32)
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
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C                   EXSR      SRGETR
     C     ##RFND        IFEQ      'N'
     C                   GOTO      BB020
     C                   ENDIF
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
      /COPY WNCPYSRC,CG5000DISR
     C                   SUB       1             ##RR
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      *                                                                                       CCG015
      ** If switchable feature CCG015 = *ON, display subfile #SFLRCD2                         CCG015
      ** (w/ PDF File Name) instead of #SFLRCD (w/ Print Item Type /                          CCG015
      ** Subtype).                                                                            CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   WRITE     #SFLRCD2                                                   CCG015
     C                   ELSE                                                                 CCG015
     C                   WRITE     #SFLRCD
     C                   END                                                                  CCG015
      *                                                                                       CCG015
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C     ##ARCH        IFEQ      'ARCHIVE '
     C***********          READ @XDCRL2                  82*82=EOF                            CCG009
     C**********           READ @XDCRL8                  82*82=EOF                   CCG009 MD054955
     C                   READ      @XDCRL2                                82    *82=EOF       CCG009
     C                   ELSE
     C***********          READ @UDCRL2                  82*82=EOF                            CCG009
     C**********           READ @UDCRL8                  82*82=EOF                   CCG009 MD054955
     C                   READ      @UDCRL2                                82    *82=EOF       CCG009
     C                   ENDIF
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
      *                                                                                       CCG015
      ** Display subfile with 'PDF File Name' if Correspondence                               CCG015
      ** Manager set, otherwise use original subfile with 'Print                              CCG015
      ** Item Type / Subtype' column.                                                         CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   EXFMT     #SFLCTL2                                                   CCG015
     C                   ELSE                                                                 CCG015
     C                   EXFMT     #SFLCTL
     C                   ENDIF                                                                CCG015
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
      /COPY WNCPYSRC,CG5000DSCF
      * Change of position specified
     C     WZDCOR        CASNE     #2DCOR        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * DSPFIL: Process SF Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process subfile control
      /COPY WNCPYSRC,CG5000DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * DSPFIL: Final Processing - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Final Processing
      /COPY WNCPYSRC,CG5000DFPR
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
      * DSPFIL: Process Cmd keys - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Command Keys
      /COPY WNCPYSRC,CG5000DPCK
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
      *================================================================
      *                                                               *
      * SRACTD - Check Action code                                    *
      *                                                               *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *================================================================
     CSR   SRACTD        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
      *
      **  Check all valid actions
      *
      **  If the selection is blank, by-pass
     C     #1SEL         IFEQ      ' '                                          *IF
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
      ****If*the*selection*is not valid (E, D, L, P, F, V), by-pass.                          083952
     C***********#1SEL*****SCAN 'EDLPFV'                 70                                   083952
      **  If the selection is not valid (E, D, L, P, F), by-pass.                             083952
     C     #1SEL         SCAN      'EDLPF'                                70                  083952
     C     *IN70         IFEQ      *OFF
      *
      **  Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      *
      **  Send message 'Invalid Action code'
     C                   MOVEL     'CGD1002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      EXACTD
     C                   ENDIF                                                  *FI
      *
      **  If the selection is not valid for the Program Mode, by-pass.
     C********** #1SEL     SCAN 'ELV'                    70                                   083952
     C     #1SEL         SCAN      'EL'                                   70                  083952
     C     *IN70         IFEQ      *OFF
     C     P0ACTC        ANDNE     'A'
      *
      **  Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      *
      **  Send message 'Invalid Action code'
     C                   MOVEL     'CGD1002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      EXACTD
     C                   ENDIF                                                  *FI
      *
      **  If the selection is not valid for the Item Status, by-pass.
     C     #1SEL         IFEQ      'D'
     C     #1ISTS        ANDEQ     'DLTD'
     C     #1SEL         OREQ      'D'
     C     #1ISTS        ANDEQ     'PRTD'
      *
      **  Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      *
      **  Send message 'Invalid Action code'
     C                   MOVEL     'CGD1596'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      EXACTD
     C                   ENDIF                                                  *FI
      *
      **  Check multi-branch actions
     C                   EXSR      SRMBIN
      *
      **  Unwind subroutine stack name
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
      *                                                               *
      * SRMBIN - Check Multi-branch actions                           *
      *                                                               *
      *                                                               *
      * Called by: SRACTD                                             *
      *                                                               *
      *================================================================
     CSR   SRMBIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRMBIN'      @STK(Q)
      *
      **  Set up parameters
     C                   CLEAR                   W0DATA
     C                   MOVEL     #1BRCA        B#BRCA                                       171050
     C                   MOVEL     #1SEL         O#ACTD
     C                   MOVEL     ##PGM         O#CPGM
      *
     C     #1SEL         IFEQ      '1'                                          *IF
     C                   MOVEL     'X'           O#ACTD
     C                   END                                                    *FI
      *
      **  Check all valid actions
     C                   CALL      'CG1020'                             9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      '*ACTCODE'    W0ACT             8
     C                   PARM                    W0DATA
      *
      **  Option ended in error
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
     C                   SETON                                        9832      *
     C                   END                                                    *FI
      *
      **  Invalid action
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SETON                                        9832      *
     C                   ELSE                                                   *FI
     C                   SETON                                        99        *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      **  Unwind subroutine stack name
     C     EXMBIN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
      *                                                               *
      * SRRCHG - Record Changed                                       *
      *                                                               *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *================================================================
     CSR   SRRCHG        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRRCHG'      @STK(Q)
      *
      **  Only chain if record if live #1RECI is 'D'
     C     #1RECI        IFEQ      'D'
      *
     C     KREC          KLIST
     C                   KFLD                    #1DCOR                         Destination Cor
     C                   KFLD                    #1ITEM                         Item Identifier
      *
     C     ##ARCH        IFEQ      'ARCHIVE '
     C***********KREC      CHAIN@XDCRL2              90    *                                  CCG009
     C********** KREC      CHAIN@XDCRL8              90    *                         CCG009 MD054955
     C     KREC          CHAIN     @XDCRL2                            90                      CCG009
     C                   ELSE
     C***********KREC      CHAIN@UDCRL2              90    *                                  CCG009
     C********** KREC      CHAIN@UDCRL8              90    *                         CCG009 MD054955
     C     KREC          CHAIN     @UDCRL2                            90                      CCG009
     C                   ENDIF
      *
      **  Record not found - database error
     C     *IN90         IFEQ      '1'
     C     ##ARCH        IFEQ      'ARCHIVE '
     C***********          MOVEL'CGXDCRL2'W0FILE                                              CCG009
     C**********           MOVEL'CGXDCRL8'W0FILE                                     CCG009 MD054955
     C                   MOVEL     'CGXDCRL2'    W0FILE                                       CCG009
     C                   ELSE
     C***********          MOVEL'CGUDCRL2'W0FILE                                              CCG009
     C**********           MOVEL'CGUDCRL8'W0FILE                                     CCG009 MD054955
     C                   MOVEL     'CGUDCRL2'    W0FILE                                       CCG009
     C                   ENDIF
     C                   Z-ADD     DRITEM        #KITEM
     C                   MOVEL     DRDCOR        #KDCOR
     C                   MOVEL     #KPOS         W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ELSE
     C                   MOVEL     #1RECI        DRRECI
     C                   END
      *
      **  If action code is not blank then send message record has been
      **  deleted if RECI not equal to 'D'
     C     #1SEL         IFNE      *BLANKS
     C     DRRECI        IFNE      'D'
      * Send message 'Invalid Action code - record deleted'
     C                   MOVEL     'CGD1003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832      *
     C                   END
     C                   GOTO      EXRCHG
     C                   END
      *
      **  Reload subfile record
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
      *
      **  Unwind subroutine stack name
     C     EXRCHG        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      **  Read first changed slf record
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   READC     #SFLRCD2                               92    *             CCG015
     C                   ELSE                                                                 CCG015
     C                   READC     #SFLRCD                                92    *
     C                   END                                                                  CCG015
     C     *IN92         DOWEQ     '0'
      *
      **  Process subfile record
     C                   EXSR      DCPRSR
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   UPDATE    #SFLRCD2                                                   CCG015
     C                   ELSE                                                                 CCG015
     C                   UPDATE    #SFLRCD
     C                   END                                                                  CCG015
      *
      **  If F12 then redisplay screen with action code
      **  Or action did not complete
     C     P0RTN         IFNE      *BLANKS                                      *Return code
     C     ##RTN         ORNE      *BLANKS                                      *Return code  096539
     C                   MOVEL     *BLANKS       P0RTN
     C                   GOTO      DBEXIT
     C                   END
      *
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   READC     #SFLRCD2                               92    *             CCG015
     C                   ELSE                                                                 CCG015
     C                   READC     #SFLRCD                                92    *
     C                   END                                                                  CCG015
      *                                                                                       CCG015
     C                   ENDDO
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(32)
     C                   MOVEL     *BLANKS       P0RTN
     C                   MOVEL     *BLANKS       ##RTN                                        096539
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * DSPFIL: Process SF rec - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Subfile Record
      /COPY WNCPYSRC,CG5000DPSR
      *
      **  Check action code is valid, if invalid exit.
     C                   EXSR      SRACTD
      *
      **  Check record is active
     C                   EXSR      SRRCHG
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
     C                   ENDIF                                                  *FI
      *---------------------------------------------------------------*
      *
      **  Validate the Action Code and perform appropriate action.
     C                   SELECT
      *...............................................................*
      *
      **  For Print Copy/Management the status can be anything but
      **  'Deleted' (DLTD).
     C     #1SEL         WHENEQ    'P'
     C     #1ISTS        IFEQ      'DLTD'
     C                   MOVEL     'CGD1639'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832
     C                   ELSE
     C                   EXSR      SRPRNT
     C                   ENDIF
      *...............................................................*
      *
      **  For Print Final the status must be 'Scheduled' or 'Held'
     C     #1SEL         WHENEQ    'F'
     C     #1ISTS        IFNE      'SCHD'
     C     #1ISTS        ANDNE     'HELD'
     C                   MOVEL     'CGD1640'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832
     C                   ELSE
     C                   EXSR      SRPRNT
     C                   ENDIF
      *...............................................................*
      *
      **  For Action code 'V' - View ....
     C********** #1SEL     WHEQ 'V'                                                           083952
      *...............................................................*
      *
      **  For Action code 'L' - Display Log file
     C     #1SEL         WHENEQ    'L'
     C                   MOVEL     DRDCOR        P2DCOR
     C                   Z-ADD     DRITEM        P2ITEM
     C                   Z-ADD     *ZEROS        P2DTAC
     C                   Z-ADD     *ZEROS        P2ATIM
     C                   CALL      'CG5040'                             9090
     C                   PARM      *BLANK        ##RTN             7
     C                   PARM      'e'           ##ACTN            1
     C                   PARM                    P2PARM
     C                   PARM                    P0KEYI
      *
      **  If in error set up return code
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1000'     ##RTN
     C                   ENDIF
      *...............................................................*
      *
      **  Process Action Code. (D(elete) or E(nquire))
     C     #1SEL         WHENEQ    'D'
     C     #1SEL         OREQ      'E'
     C                   MOVEL     #LPARM        ##PARM           15
     C                   CALL      'CG5010'                             9090
     C                   PARM      *BLANK        ##RTN             7
     C                   PARM      #1SEL         ##ACTN            1
     C                   PARM                    ##PARM
     C                   PARM      *BLANK        P#NSTS            4
     C                   PARM                    P0KEYI
      *
      **  If in error set up return code
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1000'     ##RTN
     C                   ENDIF
     C                   OTHER
     C                   ENDSL                                                  *LS
      *
      **  Depending on return code - exit or re-display screen
     C                   SELECT                                                 *SL
      *
      **  F12 pressed - redisplay subfile
     C     ##RTN         WHENEQ    'USR0790'                                    *IF
      *
     C****Send*message*'F12*taken*from*previous*screen'***************                        115722
     C*********************MOVEL'CGD1001' ZAMSID                                              115722
     C*********************EXSR ZASNMS                                                        115722
     C                   SETON                                        9832      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      **  F3 pressed - exit program
     C     ##RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      **  If error redisplay
     C     ##RTN         WHENNE    *BLANKS                                      *IF
      *
      **  Re-display screen
     C                   MOVEL     'CGD1000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9832      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      **  Function completed normally
     C     ##RTN         WHENEQ    *BLANKS                                      *IF
     C                   ENDSL                                                  *LS
      *
     C     DCENDT        TAG
      *
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
      **  If option did not end in error, F12 or F3 then update record
      **  with changes
     C     ##RTN         IFEQ      *BLANKS
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
      * Move file fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   Z-ADD     DRITEM        #1ITEM                         Item Identifier
     C                   MOVEL     DRRECI        #1RECI                         Record Identifi
     C                   MOVEL     DRPCOR        #1PCOR                         Primary Corresp
     C                   MOVEL     DRBRCA        #1BRCA                         Branch Code
     C                   MOVEL     DRORBR        #1ORBR                         Originating Bra
     C                   MOVEL     DROVBR        #1OVBR                         Overriding Bran
     C                   MOVEL     DRMODI        #1MODI                         Module id
     C                   MOVEL     DRMTRN        #1MTRN                         Midas Transacti
     C                   MOVEL     DRMACT        #1MACT                         Midas Account I
     C                   MOVEL     DRISTS        #1ISTS                         Item Status
     C                   MOVEL     DRPTYP        #1PTYP                         Print Item Type
     C                   MOVEL     DRPSTP        #1PSTP                         Print Item Sub-
     C                   MOVEL     DRATRM        #1ATRM                         Auto-Transmissi
     C                   Z-ADD     DRPRTD        #1PRTD                         Scheduled Print
     C                   Z-ADD     DRDDAT        #1DDAT                         Scheduled Drop
     C                   MOVEL     DRLGID        #1LGID                         Language identi
     C                   MOVEL     DRMSHT        #1MSHT                         Mail Shot Ident
     C                   MOVEL     DRCHQR        #1CHQR                         Cheque Referenc
     C                   MOVEL     DRFREF        #1FREF                         Further Referen
     C                   MOVEL     DRAJOB        #1AJOB                         Job name
     C                   MOVEL     DRAUSR        #1AUSR                         User name
     C                   Z-ADD     DRATIM        #1ATIM                         Action Time
     C                   MOVEL     DRARDT        #1ARDT                         Action Date
     C                   MOVEL     DRAACT        #1AACT                         Action Type
     C                   Z-ADD     DRRDNB        #1RDNB                         Run day number
     C                   MOVEL     DRDCOR        #1DCOR                         Destination Cor
     C**********           MOVELITGPHD    #1GPHD           Group Header/DeCCG009            MD054955
     C                   MOVEL     DRITEM        ##ITEM                         Item Id       CCG017
      *                                                                                       CCG015
      ** If CCG015 = *ON, retrieve latest PDF file name                                       CCG015
      ** from log file using the Item Reference of the                                        CCG015
      ** correspondence.                                                                      CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   EXSR      GETPDF                                                     CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   GETPDF        BEGSR                                                                CCG015
      *================================================================                       CCG015
      * GETPDF - Retrieve the last action record for an item which                            CCG015
      *          holds the latest PDF file name printed.                                      CCG015
      *================================================================                       CCG015
      *                                                                                       CCG015
      ** Initialise work variables                                                            CCG015
      *                                                                                       CCG015
     C                   MOVEL     *BLANKS       LSPDFN           35                          CCG015
     C                   Z-ADD     0             LSDATE            5 0                        CCG015
     C                   Z-ADD     0             LSTIME            6 0                        CCG015
     C                   MOVEL     *OFF          *IN93                                        CCG015
      *                                                                                       CCG015
      ** Initialise key fields (for KPOS2) from current record                                CCG015
      ** read from CGUDCRPD.                                                                  CCG015
      *                                                                                       CCG015
     C                   MOVEL     DRITEM        KYITEM                                       CCG015
     C                   MOVEL     DRDCOR        KYDCOR                                       CCG015
      *                                                                                       CCG015
      ** Read the log file depending on value of Archive indicator                            CCG015
      *+--------------------------------------------------------------+                       CCG015
      *¦ Read CGXDCLL1 if Archive Indicator = 'ARCHIVE'               ¦                       CCG015
      *+--------------------------------------------------------------+                       CCG015
     C     ##ARCH        IFEQ      'ARCHIVE '                                                 CCG015
      *                                                                                       CCG015
     C     KPOS2         SETLL     @XDCLL1                                                    CCG015
      *                                                                                       CCG015
     C     *IN93         DOWEQ     *OFF                                                       CCG015
     C                   READ      @XDCLL1                                93                  CCG015
      *                                                                                       CCG015
      ** Matching record read with PDF name field not BLANK                                   CCG015
      *                                                                                       CCG015
     C     *IN93         IFEQ      *OFF                                                       CCG015
     C     DLITEM        ANDEQ     DRITEM                                                     CCG015
     C     DLDCOR        ANDEQ     DRDCOR                                                     CCG015
      *                                                                                       CCG015
      ** Last action date is equal / greater than and action                                  CCG015
      ** time is later than the previous saved values.                                        CCG015
      *                                                                                       CCG015
     C     DLPDFN        IFNE      *BLANKS                                                    CCG015
     C     DLDTAC        ANDGE     LSDATE                                                     CCG015
     C     DLATIM        ANDGT     LSTIME                                                     CCG015
      *                                                                                       CCG015
      ** Save latest log records (with PDF name) so far...                                    CCG015
      *                                                                                       CCG015
     C                   MOVEL     DLPDFN        LSPDFN                                       CCG015
     C                   Z-ADD     DLDTAC        LSDATE                                       CCG015
     C                   Z-ADD     DLATIM        LSTIME                                       CCG015
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
      ** Exit if change in Item Ref. and Destination Correspondent                            CCG015
      ** occurs. (Reason: CGXDCLL1/CGUDCLL1 are both keyed to DLITEM+                         CCG015
      ** DLDCOR + DLDTAC (action date) + DLITEM (action time) it is                           CCG015
      ** unlikely that related records to current selection key will                          CCG015
      ** be found later in the file. Hence it is logical to exit the                          CCG015
      ** loop at this point to optimise processing time).                                     CCG015
      *                                                                                       CCG015
     C                   ELSE                                                                 CCG015
     C                   LEAVE                                                                CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
     C                   ENDDO                                                                CCG015
      *+--------------------------------------------------------------+                       CCG015
      *¦ Read CGUDCLL1 if Archive Indicator = *BLANK.                 ¦                       CCG015
      *+--------------------------------------------------------------+                       CCG015
     C                   ELSE                                                                 CCG015
      *                                                                                       CCG015
     C     KPOS2         SETLL     @UDCLL1                                                    CCG015
      *                                                                                       CCG015
     C     *IN93         DOWEQ     *OFF                                                       CCG015
     C                   READ      @UDCLL1                                93                  CCG015
      *                                                                                       CCG015
      ** Matching record read with PDF name field not BLANK                                   CCG015
      *                                                                                       CCG015
     C     *IN93         IFEQ      *OFF                                                       CCG015
     C     DLITEM        ANDEQ     DRITEM                                                     CCG015
     C     DLDCOR        ANDEQ     DRDCOR                                                     CCG015
      *                                                                                       CCG015
      ** Last action date is equal / greater than and action                                  CCG015
      ** time is later than the previous saved values.                                        CCG015
      *                                                                                       CCG015
     C     DLPDFN        IFNE      *BLANKS                                                    CCG015
     C     DLDTAC        ANDGE     LSDATE                                                     CCG015
     C     DLATIM        ANDGT     LSTIME                                                     CCG015
      *                                                                                       CCG015
      ** Save latest log records (with PDF name) so far...                                    CCG015
      *                                                                                       CCG015
     C                   MOVEL     DLPDFN        LSPDFN                                       CCG015
     C                   Z-ADD     DLDTAC        LSDATE                                       CCG015
     C                   Z-ADD     DLATIM        LSTIME                                       CCG015
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
      ** Exit if change in Item Ref. and Destination Correspondent                            CCG015
      ** occurs. (Reason: CGXDCLL1/CGUDCLL1 are both keyed to DLITEM+                         CCG015
      ** DLDCOR + DLDTAC (action date) + DLITEM (action time) it is                           CCG015
      ** unlikely that related records to current selection key will                          CCG015
      ** be found later in the file. Hence it is logical to exit the                          CCG015
      ** loop at this point to optimise processing time).                                     CCG015
      *                                                                                       CCG015
     C                   ELSE                                                                 CCG015
     C                   LEAVE                                                                CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
     C                   ENDDO                                                                CCG015
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
      ** Latest PDF name should have been retrieved at this point,                            CCG015
      ** load it into screen field for display.                                               CCG015
      *                                                                                       CCG015
     C                   MOVEL     *BLANKS       #1PDFN                                       CCG015
      *                                                                                       CCG015
     C     LSPDFN        IFNE      *BLANKS                                                    CCG015
     C                   MOVEL     LSPDFN        #1PDFN                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
      *================================================================                       CCG015
     CSR                 ENDSR                                                                CCG015
      /EJECT                                                                                  CCG015
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * DSPFIL: SF rec func flds - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Subfile Record function fields
      /COPY WNCPYSRC,CG5000DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     P#DCOR        #2DCOR                         Destination Cor
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRGETR                                         *
      * Purpose     :  Get next valid record                          *
      *                                                               *
      * Called by   :  BAIZSF                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRGETR        BEGSR
      *
      ** Initialise valid_record_found indication
     C                   MOVEL     'Y'           ##RFND            1
      *
      ** If record does not meet selection criteria, set
      ** valid_record_found indication to false
     C     P#PCOR        IFNE      *BLANKS
     C     P#PCOR        ANDNE     DRPCOR
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#BRCA        IFNE      *BLANKS
     C     P#BRCA        ANDNE     DRBRCA
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#MODI        IFNE      *BLANKS
     C     P#MODI        ANDNE     DRMODI
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#MTRN        IFNE      *BLANKS
     C     P#MTRN        ANDNE     DRMTRN
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#ITEM        IFNE      *ZERO                                                      CCG017
     C     P#ITEM        ANDNE     DRITEM                                                     CCG017
     C                   MOVEL     'N'           ##RFND                                       CCG017
     C                   ENDIF                                                                CCG017
      *                                                                                       CCG017
     C     P#OVBR        IFNE      *BLANKS
     C     P#OVBR        ANDNE     DROVBR
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#MACT        IFNE      *BLANKS
     C     P#MACT        ANDNE     DRMACT
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *                                                                                       095461
      * Check Correspondent Type                                                              095461
      *                                                                                       095461
     C     P#CTYP        IFNE      *BLANKS                                                    095461
     C     DRDCOR        CHAIN     @CORRL1                            91                      095461
     C     P#CTYP        IFNE      CDCTYP                                                     095461
     C     *IN90         ANDEQ     *OFF                                                       095461
     C                   MOVEL     'N'           ##RFND                                       095461
     C                   ENDIF                                                                095461
     C                   ENDIF                                                                095461
      *
     C     P#ISTS        IFNE      *BLANKS
     C     P#ISTS        ANDNE     DRISTS
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C***********P#PRTD    IFNE *ZERO                                                         090385
     C***********P#PRTD    ANDGTDRPRTD                                                        090385
     C     P#PRTD        IFNE      *ZERO                                                      090385
     C                   SELECT                                                               090385
     C     P#PRTD        WHENNE    DRPRTD                                                     090385
     C     DRPRTD        ANDNE     0                                                          090385
     C                   MOVEL     'N'           ##RFND
     C     P#PRTD        WHENNE    DRRDNB                                                     090385
     C     DRPRTD        ANDEQ     0                                                          090385
     C                   MOVEL     'N'           ##RFND                                       090385
     C                   ENDSL                                                                090385
     C                   ENDIF
      *
     C     P#PTYP        IFNE      *BLANKS
     C     P#PTYP        ANDNE     DRPTYP
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#PSTP        IFNE      *BLANKS
     C     P#PSTP        ANDNE     DRPSTP
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#LGID        IFNE      *BLANKS
     C     P#LGID        ANDNE     DRLGID
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C     P#ATRM        IFNE      *BLANKS
     C     P#ATRM        ANDNE     DRATRM
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
      *
     C                   ENDSR
      *================================================================
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
      * DSPFIL: Exit Program Proc - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Exit Program Processing
      /COPY WNCPYSRC,CG5000DEPP
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
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      * Subroutine  :  SRPRNT                                         *
      * Purpose     :  Submit print job via RCF                       *
      *                                                               *
      * Called by   :  DCPRSR                                         *
      * Calls       :  FC0040X                                        *
      *****************************************************************
      *
     C     SRPRNT        BEGSR
      ** The following part can be skipped as layout tool is not used                       MD054955
      **********                                                                     096540 MD054955
      **Get*CGDTA set up                                                             096540 MD054955
      **********                                                                     096540 MD054955
     C********** *NAMVAR   DEFN           CGDTA                                      096540 MD054955
     C**********           IN   CGDTA                                                096540 MD054955
      **********                                                                     096540 MD054955
      **If*layouts may be amended                                                    096540 MD054955
      **********                                                                     096540 MD054955
     C********** DAGRPC    IFEQ 'Y'                                                  096540 MD054955
      **********                                                                     096540 MD054955
      **Check*if layout tool being used                                              096540 MD054955
      **********                                                                     096540 MD054955
     C**********           MOVEACMD@,2    ALCOBJ 80                                  096540 MD054955
     C**********           Z-ADD80        CMDLEN 155                                 096540 MD054955
     C**********           CALL 'QCMDEXC'              9090                          096540 MD054955
     C**********           PARM           ALCOBJ                                     096540 MD054955
     C**********           PARM           CMDLEN                                     096540 MD054955
      **********                                                                     096540 MD054955
     C********** *IN90     IFEQ '1'                                                  096540 MD054955
      **Clear*messages from program message queue                                    096540 MD054955
     C**********           CALL 'Y2CLMSC'                                            096540 MD054955
     C**********           PARM ##PGM     ZAPGMQ 10                                  096540 MD054955
     C**********           PARM '*SAME'   ZAPGRL  5                                  096540 MD054955
      **********                                                                     096540 MD054955
      ****Layout tool in use - exit and do not print                                 096540 MD054955
      **********                                                                     096540 MD054955
     C***********          MOVEL'CGD2525' ZAMSID                                        096540103217
     C***********          MOVEL'CGD2525' P0RTN                                         096540103217
     C**********           MOVEL'CGD2537' ZAMSID                                     103217 MD054955
     C**********           MOVEL'CGD2537' P0RTN                                      103217 MD054955
     C**********           EXSR ZASNMS                                               096540 MD054955
     C**********           SETON                     9832  *                         096540 MD054955
     C**********           MOVEL'Y'       W0DCF            *Defer confirm            096540 MD054955
      **********                                                                     096540 MD054955
     C**********           GOTO EXPRNT                                               096540 MD054955
     C**********           ELSE                                                      096540 MD054955
      **********                                                                     096540 MD054955
      ***De-allocate object                                                          096540 MD054955
      **********                                                                     096540 MD054955
     C**********           MOVEACMD@,3    DLCOBJ 80                                  096540 MD054955
     C**********           Z-ADD80        CMDLEN 155                                 096540 MD054955
     C**********           CALL 'QCMDEXC'              9090                          096540 MD054955
     C**********           PARM           DLCOBJ                                     096540 MD054955
     C**********           PARM           CMDLEN                                     096540 MD054955
     C**********           ENDIF                                                     096540 MD054955
      **********                                                                     096540 MD054955
     C**********           ENDIF                                                     096540 MD054955
      *
      ** Set up RPARM (standard RCF parameter) for selection (set
      ** final print indicator #WFINL according to action code)
     C                   CLEAR                   #WPARM
     C                   MOVEL     #1DCOR        #WDCOR
     C                   Z-ADD     #1ITEM        #WITEM
     C     #1SEL         IFEQ      'F'
     C                   MOVEL     'Y'           #WFINL
     C                   ELSE
     C                   MOVEL     'N'           #WFINL
     C                   ENDIF
      *                                                                                       083783
      * Set up Archive indicator                                                              083783
      *                                                                                       083783
     C     ##ARCH        IFEQ      'ARCHIVE '                                                 083783
     C                   MOVEL     'A'           #WARCH                                       083783
     C                   ELSE                                                                 083783
     C                   MOVEL     'C'           #WARCH                                       083783
     C                   ENDIF                                                                083783
      *                                                                                       083783
     C     #1GPHD        IFEQ      'H'                                                        CCG009
     C                   MOVEL     #1MTRN        #WGPTR                                       CCG009
     C                   MOVE      #1MODI        #WGPTR                                       CCG009
     C                   END                                                                  CCG009
      *                                                                                       CCG009
     C                   MOVEL     #WPARM        O#PARM
      *
      ** Call FC0040X to submit RCF report job
     C**********           CALL 'FC0040X'              9090Call FC0040X                       086184
     C                   CALL      'FC0040X'                            90      Call FC0040X  086184
     C     ##RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      'CG3000'      O#PRG            10            Report name
     C                   PARM      'CGC5220'     O#CPRG           10            CL Controlling
     C                   PARM      '10001'       O#CSEQ            5            CL Sequence Num
     C                   PARM                    O#PARM          100            Calling Parm
     C                   PARM      AGMBIN        O#MBIN            1            Multi-Branching
     C                   PARM      'B'           O#LVL             1            Level
     C                   PARM      #1BRCA        O#ENTY            3            Entity
      *
     C     *IN90         IFEQ      '1'
     C     ##RTN         ORNE      *BLANKS
     C                   MOVEL     'CGD1000'     P0RTN
     C                   MOVEL     *BLANKS       R#RTN             7
     C                   ENDIF
      *
     C     EXPRNT        TAG                                                                  096540
      *================================================================
     CSR                 ENDSR
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
      *
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C**********           Z-ADD500       W0SLM   50                                          120038
     C                   Z-ADD     99999         W0SLM             5 0          *Scan limit   120038
      *                                                                                       120038
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
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
      *
     C     AGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN71
     C                   ENDIF
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
      *                                                                                       CCG015
      ** Access SAR details file to determine if CCG015 is installed.                         CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'                                                 CCG015
     C                   PARM      *BLANKS       PRTCD             7                          CCG015
     C                   PARM      '*VERIFY'     POPTN             7                          CCG015
     C                   PARM      'CCG015'      PSARD             6                          CCG015
     C     SCSARD        PARM      SCSARD        DSSDY                                        CCG015
      *                                                                                       CCG015
      ** Database Error                                                                       CCG015
      *                                                                                       CCG015
     C     PRTCD         IFNE      *BLANK                                                     CCG015
     C     PRTCD         ANDNE     '*NRF   '                                                  CCG015
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************  CCG015
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR 04 *  CCG015
     C                   Z-ADD     4             W0ERNB                         ************  CCG015
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG015
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   END                                                                  CCG015
      *                                                                                       CCG015
     C                   MOVEL     'N'           CCG015            1                          CCG015
     C     PRTCD         IFEQ      *BLANK                                                     CCG015
     C                   MOVEL     'Y'           CCG015                                       CCG015
     C                   ENDIF                                                                CCG015
      *
      ****Open*file CGUDCRL2 or CGXDCRL2                                                      CCG009
      **  Open file CGUDCRL8 or CGXDCRL8                                                      CCG009
     C     FIL001        IFEQ      *BLANKS
      *
     C     ##ARCH        IFEQ      'ARCHIVE '
     C***********          MOVEL'CGXDCRL2'U#FILE 10 P                                         CCG009
     C**********           MOVEL'CGXDCRL8'U#FILE 10 P                                CCG009 MD054955
     C                   MOVEL(P)  'CGXDCRL2'    U#FILE           10                 CCG009 MD054955
     C                   ELSE
     C***********          MOVEL'CGUDCRL2'U#FILE    P                                         CCG009
     C**********           MOVEL'CGUDCRL8'U#FILE    P                                CCG009 MD054955
     C                   MOVEL(P)  'CGUDCRL2'    U#FILE                              CCG009 MD054955
     C                   ENDIF
      *
      **  Override file to share(*NO)
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     ##ARCH        IFEQ      'ARCHIVE '
     C***********          OPEN CGXDCRL2                                                      CCG009
     C**********           OPEN CGXDCRL8                                             CCG009 MD054955
     C                   OPEN      CGXDCRL2                                          CCG009 MD054955
     C                   OPEN      CGXDCLL1                                                   CCG015
     C                   OPEN      CGCORRL1                                                   095461
     C                   ELSE
     C***********          OPEN CGUDCRL2                                                      CCG009
     C**********           OPEN CGUDCRL8                                             CCG009 MD054955
     C                   OPEN      CGUDCRL2                                          CCG009 MD054955
     C                   OPEN      CGUDCLL1                                                   CCG015
     C                   OPEN      CGCORRL1                                                   095461
     C                   ENDIF
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      ** Option Name
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1496'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      *
      ** Options
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1497'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      ** Command keys
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * File and Program Error Processing
      * DSPFIL: Initialise Prog. - R10 Copy source templates  *
      *DSPRCD: Cpysrc Templates Initialise Program C-Spec
      /COPY WNCPYSRC,CG5000DCPG
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *                                                                                       CCG015
      ** Set key for Correspondence Log file                                                  CCG015
      *                                                                                       CCG015
     C     *LIKE         DEFINE    DRITEM        KYITEM                                       CCG015
     C     *LIKE         DEFINE    DRDCOR        KYDCOR                                       CCG015
      *                                                                                       CCG015
     C     KPOS2         KLIST                                                                CCG015
     C                   KFLD                    KYITEM                         Item Identifi CCG015
     C                   KFLD                    KYDCOR                         Correspondent CCG015
      *                                                                                       CCG015
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
      *
      ** PSSR Processing
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
      /COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
      *
      ** File and Program Error Processing
      *COPY*CGCPYSRC,SRERRC                                                                 MD056543
      /COPY CGCPYSRC,SRERRCLE                                                               MD056543
      /EJECT
      *
      ******ALCOBJ     OBJ((CGLAYOL0 *FILE *EXCL)) WAIT(1)                                    103217
      ******DLCOBJ     OBJ((CGLAYOL0 *FILE *EXCL))                                            103217
     O*DSPRCD: Cpysrc Templates Initialise Program O-Spec
      /COPY WNCPYSRC,CG5000DOPG
**  CPY@
(c) Finastra International Limited 2001
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
ALCOBJ     OBJ((CGRASCPD *FILE *EXCL)) WAIT(1)
DLCOBJ     OBJ((CGRASCPD *FILE *EXCL))
