     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG UDC print process extract')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG5100 - Print Process Extract                               *
      *                                                               *
      *  Function:  This program reads a selected file (via OPNQRY)   *
      *             for Correspondence Items that match a user's      *
      *             request and outputs the details to CG5100P1       *
      *             which is the relevant printer file                *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD025434           Date 02Oct17               *
      *                 CCG024             Date 29Sep16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 31Jul01               *
      *                 190022             Date 15Jan99               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 124756             Date 19Jun01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCG009             Date 01JUN95               *
      *                 088006             DATE 18MAY95               *
      *                 086662             DATE 25APR95               *
      *                 S01522             DATE 26JAN95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025434 - Avoid empty .dat file sent to CM.                 *
      *             Applied for MD048036.                             *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *  190022 - Recompiled due to increased size of OVRPRTF string  *
      *           in PF/CGPRTPPD and PF/CGPGENPD files.               *
      *  124756 - Report did not show the bank title and date.        *
      *  CCG009 - Private Banking UDC                                 *
      *  088006 - Blank out branch if system level report             *
      *  086662 - Add correspondence type to selection criteria       *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50   -    No Record found on PF/CGUDCRPD                     *
      *  51   -    General indicator                                  *
      *  65   -    Overflow indicator                                 *
      *  90   -    ROLBK indicator                                    *
      *                                                               *
      *                                                               *
      *****************************************************************
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRL4  IF   E           K DISK    INFSR(SRFILE)                                      CCG024
     FCGPGENPD  O    E             DISK
     F                                     INFSR(SRFILE)
     F                                     COMMIT
     FCGUDCRPD  IF   E             DISK    USROPN
     F                                     INFSR(SRFILE)
     FCGUDCRL0  UF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
     FCGXDCRPD  IF   E             DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(@UDCRPD:@XDCRPD)
     FCGXDCRL0  UF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
     FCGUXMLL0  IF   E           K DISK    USROPN                                           MD025434
     F                                     INFSR(SRFILE)                                    MD025434
     FCG5100P1  O    E             PRINTER INFDS(SPOOLP)
     F                                     OFLIND(*IN65)
     F                                     USROPN
      *
      /EJECT
      *
      **  Copyright array.
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)
      **                                                                                      CSC022
      *COPY*CGCPYSRC,SRERRE                                                                 MD056543
      /COPY CGCPYSRC,SRERRDLE                                                               MD056543
      /EJECT
      *
     D P#PGEN        E DS                  EXTNAME(CGPGENPD)
      **  External DS for parameters based on PF/CGPGENPD
      *
     D P#UDCL        E DS                  EXTNAME(CGUDCLPD)
      **  External DS for parameters based on PF/CGUDCLPD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CCG015
      ** MIDAS Switchable Features Accessed Via Access Program                                CCG015
      *                                                                                       CCG015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CCG015
      **  Second DS for access programs, long data structure                                  CCG015
      *                                                                                       CCG015
     D P#PARM          DS           100
      **  DS to obtain Data from RCF Parm
     D  ##USER                 1     10
     D  ##DCOR                11     20
     D  ##PRIM                21     21
     D  ##PTYP                22     31
     D  ##PSTP                32     41
     D  ##FRDT                42     46  0
     D  ##TODT                47     51  0
     D  ##LGID                52     61
     D********************                   62  71 ##ACCP                                    CCG009
     D  ##ACCP                62     63                                                       CCG009
     D  ##GPTR                64     71                                                       CCG009
     D  ##STS1                72     75
     D  ##STS2                76     79
     D  ##STS3                80     83
     D  ##STS4                84     87
     D  ##STS5                88     91
     D  ##ATRM                92     92
     D  ##PPFN                93     93
     D  ##COT                 96     96                                                       086662
     D/COPY WNCPYSRC,CG5100I001
      *
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *                                                                                       S01117
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  S01117
      **  External DS for bank details                                                        S01117
     D**********    BJURPT                          TITL                               S01117 124756
      *                                                                                       S01117
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  S01117
      ** External DS for branches details                                                     S01117
     D  BICN         E                     EXTFLD(A8BICN)                                     S01117
      *                                                                                       S01117
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
     D*
     D*
     D*** Spool File Data Structure
     D SPOOLP          DS
     D  PFILE                 83     92
     D  PFNUM                123    124B 0
     D  LINE                 367    368B 0                                                    E39480
      *                                                                                       124756
      ** First DS for access programs, short data structure                                   124756
      *                                                                                       124756
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     124756
      **                                                                                      CSC022
     D SCCMT           DS           256                                                       CSC022
     D  WCMTNO                 1      3  0                                                    CSC022
     D  WCJOBS                 4    103                                                       CSC022
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
      * Data structure for AOSVALR0 string                                                    CCG024
     D                 DS                                                                     CCG024
     D  SVAL1                  1    200                                                       CCG024
     D  SVAL11                 1      1                                                       CCG024
      *                                                                                       CCG024
      * System Value                                                                          CCG024
     D                 DS                                                                     CCG024
     D  SVALK1                 1     20    INZ('RecipientSpecialChar')                        CCG024
      *                                                                                       CCG024
      *
      *COPY*CGCPYSRC,SRERRI                                                                 MD056543
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRMAIN - Main processing                                    *
      *   SRINIT - Initial processing - On First Call                 *
      *   *PSSR  - Exception/Error Handling                           *
      *   SREND  - End processing                                     *
      *   SRPCUS - To write new header as necessary                   *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRMAIN - Main Processing                       *
      *                SREND  - End processing
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    P#RSEQ            5
     C                   PARM                    P#RLVL            1
     C                   PARM                    P#RBCH            3
     C                   PARM                    P#PARM
     C                   PARM                    P#RECS            1
     C                   PARM                    P#ARCH            1
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      **  Detail process
     C                   EXSR      SRMAIN
      *
     C                   EXSR      SREND
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      **  Terminate program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOLYPPR0 - Obtain Layout/Printer Profile       *
      *                SRPCUS   - To write new header as necessary    *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      * First open of print file
      *
     C                   MOVE      'Y'           ##OPEN            1
      *................................................................
      *
      **  Read the UDC Reference file (selected via OPNQRYF)
     C     P#ARCH        IFEQ      'A'
     C                   READ      CGXDCRPD                               50
     C                   ELSE
     C                   READ      CGUDCRPD                               50
     C                   ENDIF
      *
      **  For each record found ...
     C     *IN50         DOWEQ     *OFF
      *
      **  For current items, ensure first that records are in CGUXMLPD                      MD025434
     C     P#ARCH        IFNE      'A'                                                      MD025434
     C     DRITEM        SETLL     CGUXMLL0                                                 MD025434
     C     DRITEM        READE     CGUXMLL0                               80                MD025434
     C     *IN80         IFEQ      *ON                                                      MD025434
     C                   GOTO      NXTREC                                                   MD025434
     C                   ENDIF                                                              MD025434
     C                   ENDIF                                                              MD025434
      *                                                                                     MD025434
      **  Initialise the output format.
     C                   CLEAR                   @PGENPD
     C                   MOVEL     *BLANKS       ##ISTS
      *
      **  Set up the output record with data from PF/CGUDCRPD.
     C                   Z-ADD     DRITEM        B2ITEM
     C                   MOVE      DRDCOR        B2DCOR
     C                   MOVE      DRPCOR        B2PCOR
     C                   MOVE      DRBRCA        B2BRCA
     C                   MOVE      DRORBR        B2ORBR
     C                   MOVE      DROVBR        B2OVBR
     C                   MOVE      DRMODI        B2MODI
     C                   MOVE      DRMTRN        B2MTRN
     C                   MOVE      DRMACT        B2MACT
     C                   MOVE      DRPTYP        B2PTYP
     C                   MOVE      DRPSTP        B2PSTP
     C                   MOVE      DRATRM        B2ATRM
     C                   Z-ADD     DRPRTD        B2PRTD
     C                   Z-ADD     DRDDAT        B2DDAT
     C                   MOVE      DRLGID        B2LGID
      *
      ** If feature CCG024 is on and special character is found in DRDCOR                     CCG024
     C                   MOVEL     'N'           XFOUND            1                          CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
     C     SVAL11        SCAN      DRDCOR                                 99                  CCG024
     C     *IN99         IFEQ      *ON                                                        CCG024
     C                   MOVEL     DRDCOR        XXCORR            6                          CCG024
     C     XXCORR        CHAIN     CGCORRL4                           51                      CCG024
     C     *IN51         IFEQ      *ON                                                        CCG024
     C                   MOVEL     'CGCORRL4'    W0FILE                                       CCG024
     C                   MOVEL     B2DCOR        W0KEY                          **************CCG024
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 CCG024
     C                   MOVEL     'MEM5004'     W0MSGD                         **************CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
     C                   MOVEL     'Y'           XFOUND                                       CCG024
     C                   ENDIF                                                                CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C     XFOUND        IFEQ      'N'
      **  Obtain the Correspondent Type using tHe Correspondent.
     C     B2DCOR        CHAIN     CGCORRL1                           51
      *
      **  If no record found, process database error.
     C     *IN51         IFEQ      *ON
     C                   MOVEL     'CGCORRL1'    W0FILE
     C                   MOVEL     B2DCOR        W0KEY                          ***************
     C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       086662
      **  Apply selection for correspsondent type here as opposed to in                       086662
      **  the OPNQRYF in CGC5230.                                                             086662
     C     ##COT         IFEQ      'T'                                                        086662
     C     *LIKE         DEFINE    ##DCOR        W0CTYP                                       086662
     C                   MOVEL     ##DCOR        W0CTYP                                       086662
      *                                                                                       086662
     C     W0CTYP        IFNE      *BLANKS                                                    086662
     C     W0CTYP        ANDNE     CDCTYP                                                     086662
     C                   GOTO      NXTREC                                                     086662
     C                   ENDIF                                                                086662
     C                   ENDIF                                                                086662
      *
     C                   MOVE      CDCTYP        B2CTYP
      *
      **  Obtain the Layout, Printer Profile and associated information
      **  only if switchable feature CCG015 is *OFF.                                          CCG015
      *                                                                                       CCG015
     C                   MOVEL     *BLANKS       ##RTCD                                       CCG015
      *                                                                                       CCG015
      **  If CCG015 is *ON, we no longer need to retrieve the layout                          CCG015
      **  details associated with this correspondence. The error                              CCG015
      **  handling is no longer needed to be performed as well.                               CCG015
      *                                                                                       CCG015
     C     CCG015        IFEQ      'N'                                                        CCG015
      *                                                                                       CCG015
     C                   CALL      'AOLYPPR0'                             90
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM                    P#PGEN
      *
      **  Error in called program.
      *
     C     ##RTCD        IFNE      *BLANK
      *
      **  Set up the Log file fields for this level.
     C                   CLEAR                   P#UDCL
     C                   Z-ADD     B2ITEM        DLITEM
     C                   MOVE      B2DCOR        DLDCOR
     C                   MOVEL     'CGD1650'     DLMSID
     C                   MOVEL     'CG5100  '    DLCPGM
     C                   MOVEL     'AOLYPPR0'    DLRPGM
      *
      **  Output a Log file record.
     C     P#ARCH        IFEQ      'A'
     C                   CALL      'CG9050'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*WRITE  '    ##ACT
     C                   PARM                    P#UDCL
     C                   PARM      *BLANKS       ##TITL
     C                   PARM      *BLANKS       ##ULIN
     C                   PARM      'YES'         ##CMT
     C                   ELSE
     C                   CALL      'CG9030'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*WRITE  '    ##PACT            8
     C                   PARM                    P#UDCL
     C                   PARM      *BLANKS       ##TITL            7
     C                   PARM      *BLANKS       ##ULIN            7
     C                   PARM      'YES'         ##CMT             3
     C                   ENDIF
      *
      **  Terminal error in called program.
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     ##RTCD        W0KEY
      *
     C     P#ARCH        IFEQ      'A'
     C                   MOVEL     'CG9050  '    W0FILE
     C                   ELSE
     C                   MOVEL     'CG9030  '    W0FILE                         ***************
     C                   ENDIF                                                  * DB ERROR 02 *
     C                   Z-ADD     02            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Update with error status
     C     *LIKE         DEFINE    DRISTS        ##ISTS
     C                   MOVE      'ELAY'        ##ISTS
      **  Obtain the Reference record for update
     C     KUDCR         KLIST
     C                   KFLD                    DRITEM
     C                   KFLD                    DRDCOR
      *
     C     P#ARCH        IFEQ      'A'
     C     KUDCR         CHAIN     @XDCRL0                            51
     C                   ELSE
     C     KUDCR         CHAIN     @UDCRL0                            51
     C                   ENDIF
      *
      **  If no record found, process database error.
     C     *IN51         IFEQ      *ON
     C     P#ARCH        IFEQ      'A'
     C                   MOVEL     'CGUDCRL0'    W0FILE
     C                   ELSE
     C                   MOVEL     'CGXDCRL0'    W0FILE
     C                   ENDIF
     C                   MOVEL     DRDCOR        W0KEY                          ***************
     C                   Z-ADD     03            W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     ##ISTS        DRISTS
     C     P#ARCH        IFEQ      'A'
     C                   UPDATE    @XDCRL0
     C                   ELSE
     C                   UPDATE    @UDCRL0
     C                   ENDIF
     C***********          ELSE                                                               CCG015
      *                                                                                       CCG015
     C                   ENDIF                                                                CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
      ** No layout association error when CCG015 is *ON.                                      CCG015
      *                                                                                       CCG015
     C     ##RTCD        IFEQ      *BLANK                                                     CCG015
     C     CCG015        OREQ      'Y'                                                        CCG015
      *
      **  Update the status.
     C     ##PPFN        IFEQ      'Y'
     C                   MOVE      'PPFN'        B2ISTS
     C                   MOVE      'PPFN'        ##ISTS
      **  Obtain the Reference record for update
      *
     C     P#ARCH        IFEQ      'A'
     C     KUDCR         CHAIN     @XDCRL0                            51
     C                   ELSE
     C     KUDCR         CHAIN     @UDCRL0                            51
     C                   ENDIF
      *
      **  If no record found, process database error.
     C     *IN51         IFEQ      *ON
     C                   MOVEL     'CGUDCRL0'    W0FILE
     C                   MOVEL     DRDCOR        W0KEY                          ***************
     C                   Z-ADD     04            W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     ##ISTS        DRISTS
     C     P#ARCH        IFEQ      'A'
     C                   UPDATE    @XDCRL0
     C                   ELSE
     C                   UPDATE    @UDCRL0
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     DRISTS        B2ISTS
     C                   END
     C/COPY WNCPYSRC,CG5100C001
      *
     C                   EXSR      SRPCUS
      *
      **  Output the extracted Driver record.
      *                                                                                       088006
      * If system report blank out branch                                                     088006
      *                                                                                       088006
     C     P#RLVL        IFEQ      'S'                                                        088006
     C                   MOVEL     *BLANKS       B2BRCA                                       088006
     C                   ENDIF                                                                088006
     C                   WRITE     @PGENPD
      *                                                                                       088006
      * If system report restore branch                                                       088006
      *                                                                                       088006
     C     P#RLVL        IFEQ      'S'                                                        088006
     C                   MOVEL     DRBRCA        B2BRCA                                       088006
     C                   ENDIF                                                                088006
      *
     C                   ENDIF
      *
      **  Set the records extracted flag to 'Y'.
     C                   MOVE      'Y'           P#RECS
      *
      **  Commit Changes
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCRSKP        ANDEQ     'N'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
      *                                                                                       086662
     C     NXTREC        TAG                                                                  086662
      *
      **  Read the UDC Reference file (selected via OPNQRYF)
     C     P#ARCH        IFEQ      'A'
     C                   READ      CGXDCRPD                               50
     C                   ELSE
     C                   READ      CGUDCRPD                               50
     C                   ENDIF
      *
     C                   ENDDO
      *
      *................................................................
      *
     C     EXMAIN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      * Subroutine  :  SREND                                          *
      * Function    :  Sets on last record and prints no details      *
      *                to report or new header as necessary           *
      * Called by   :  Mainline Processing                            *
      * Calls       :  None                                           *
      *****************************************************************
     C     SREND         BEGSR
      *
      * If new page print header
      *
     C     *IN65         IFEQ      *ON
     C     #FIRST        ORNE      'Y'                                          No records
     C                   WRITE     HEADER
     C                   SETOFF                                           65
     C                   ENDIF
      *
      *  Write 'No details to report'
      *
     C     #FIRST        IFNE      'Y'
     C                   WRITE     F5DTL1
     C                   ENDIF
      *
      * To terminate program
      *
     C                   WRITE     F0TRL1
      *
     C                   ENDSR
      *
      *****************************************************************
      * Subroutine  :  SRPCUS                                         *
      * Function    :  To write new header as necessary               *
      *                                                               *
      * Called by   :  SRMAIN                                         *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRPCUS        BEGSR
      *
      ** If count equals 4 write new page
      *
     C     #COUNT        IFEQ      4
     C     #FIRST        ORNE      'Y'
     C                   MOVEL     'Y'           #FIRST            1
     C                   WRITE     HEADER
     C                   Z-ADD     1             #COUNT
     C                   ENDIF
      *
     C                   MOVE      B2ITEM        D1ITEM
     C                   MOVE      B2DCOR        D1DCOR
     C                   MOVE      B2PCOR        D1PCOR
     C                   MOVE      B2BRCA        D1BRCA
     C                   MOVE      B2ORBR        D1ORBR
     C                   MOVE      B2OVBR        D1OVBR
     C                   MOVE      B2MODI        D1MODI
     C                   MOVE      B2MTRN        D1MTRN
     C                   MOVE      B2MACT        D1MACT
     C                   MOVE      B2ISTS        D1ISTS
     C                   MOVE      B2PTYP        D1PTYP
     C                   MOVE      B2PSTP        D1PSTP
     C                   MOVE      B2ATRM        D1ATRM
     C     B2PRTD        IFGT      0
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    B2PRTD            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       D1PRTD            7            DDMMMYY
     C                   ELSE
     C                   MOVE      'NO DATE'     D1PRTD
     C                   ENDIF
     C                   MOVE      B2LGID        D1LGID
     C                   MOVE      B2CTYP        D1CTYP
     C                   MOVE      B2LAYO        D1LAYO
     C                   MOVE      B2PRTF        D1PRTF
     C                   MOVE      B2PRTN        D1PRTN
     C                   MOVE      B2APF         D1APF
     C                   MOVE      B2APFS        D1APFS
     C                   MOVE      B2OVRP        D1OVRP
      *
      ** Write details and record one to counter
      *
     C                   WRITE     DETAIL
     C                   ADD       1             #COUNT            1 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      **  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C********** SDBANK    PARM *BLANKS   DSFDY   7                       124756
     C     SDBANK        PARM      SDBANK        DSFDY                                         12475
      *
      **  If return with an error (LR seton in called program)
      **  then process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   END
      *                                                                                       CCG015
      ** Access SAR details file to determine if CCG015 is installed.                         CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'                                                 CCG015
     C                   PARM      *BLANKS       P@RTCD            7                          CCG015
     C                   PARM      '*VERIFY'     P@OPTN            7                          CCG015
     C                   PARM      'CCG015'      P@SARD            6                          CCG015
     C     SCSARD        PARM      SCSARD        DSSDY                                        CCG015
      *                                                                                       CCG015
      ** Database Error                                                                       CCG015
      *                                                                                       CCG015
     C     P@RTCD        IFNE      *BLANK                                                     CCG015
     C     P@RTCD        ANDNE     '*NRF   '                                                  CCG015
     C                   MOVEL     'SCSARDPD'    W0FILE                         **************CCG015
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 07 CCG015
     C                   Z-ADD     7             W0ERNB                         **************CCG015
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG015
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   END                                                                  CCG015
      *                                                                                       CCG015
     C                   MOVEL     'N'           CCG015            1                          CCG015
     C     P@RTCD        IFEQ      *BLANK                                                     CCG015
     C                   MOVEL     'Y'           CCG015                                       CCG015
     C                   ENDIF                                                                CCG015
      **                                                                                      CSC022
      ** Initialize CSC022 and Skip Commit/Rollback flags                                     CSC022
     C                   MOVE      'N'           CSC022            1                          CSC022
     C                   MOVE      'N'           WCRSKP            1                          CSC022
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       P@RTCD                                       CSC022
     C                   PARM      '*VERIFY'     P@OPTN                                       CSC022
     C                   PARM      'CSC022'      P@SARD                                       CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
     C     P@RTCD        IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMTJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT                                        CSC022
     C                   IN        SCCMT                                                      CSC022
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0                                                          CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT                                         CSC022
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50                  CSC022
     C     *IN50         IFEQ      *ON                                                        CSC022
     C                   MOVE      'Y'           WCRSKP                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ELSE                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     P@RTCD        IFNE      '*NRF'                                                     CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   Z-ADD     8             W0ERNB                                       CSC022
     C                   EXSR      SRERR                                                      CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ENDIF                                                                CSC022
      ** For copysource SRERRC                                                                CSC022
     C                   MOVE      WCRSKP        WCMTSK            1                          CSC022
      **                                                                                      CSC022
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'                                                 CCG024
     C                   PARM                    P@RTCD                                       CCG024
     C                   PARM      '*VERIFY'     P@OPTN                                       CCG024
     C                   PARM      'CCG024'      P@SARD                                       CCG024
      *                                                                                       CCG024
     C     P@RTCD        IFEQ      *BLANKS                                                    CCG024
     C                   MOVE      'Y'           CCG024            1                          CCG024
     C                   ELSE                                                                 CCG024
     C                   MOVE      'N'           CCG024                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
      *                                                                                       CCG024
     C                   CALL      'AOSVALR0'                                                 CCG024
     C                   PARM      *BLANKS       RTNCDE            7                          CCG024
     C                   PARM                    SVALK1           20                          CCG024
     C                   PARM                    SVAL1           200                          CCG024
     C                   PARM      *BLANKS       SVALK2           20                          CCG024
     C                   PARM                    SVAL2           200                          CCG024
     C                   PARM      *BLANKS       SVALK3           20                          CCG024
     C                   PARM                    SVAL3           200                          CCG024
     C                   PARM      *BLANKS       SVALK4           20                          CCG024
     C                   PARM                    SVAL4           200                          CCG024
     C                   PARM      *BLANKS       SVALK5           20                          CCG024
     C                   PARM                    SVAL5           200                          CCG024
     C                   PARM      *BLANKS       SVALK6           20                          CCG024
     C                   PARM                    SVAL6           200                          CCG024
     C                   PARM      *BLANKS       SVALK7           20                          CCG024
     C                   PARM                    SVAL7           200                          CCG024
     C                   PARM      *BLANKS       SVALK8           20                          CCG024
     C                   PARM                    SVAL8           200                          CCG024
     C                   PARM      *BLANKS       SVALK9           20                          CCG024
     C                   PARM                    SVAL9           200                          CCG024
     C                   PARM      *BLANKS       SVALK0           20                          CCG024
     C                   PARM                    SVAL10          200                          CCG024
      *                                                                                       CCG024
     C     RTNCDE        IFNE      *BLANKS                                                    CCG024
     C     SVAL1         IFEQ      '*NRF'                                                     CCG024
     C                   MOVE      SVALK1        DBKEY                                        CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   MOVEL     'SDSVALR0'    W0FILE                                       CCG024
     C                   MOVEL     '*CALL'       W0KEY                                        CCG024
     C                   Z-ADD     21            W0ERNB                                       CCG024
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
      *
      **  Key list ...
      *
     C                   MOVE      *BLANKS       #FIRST            1
      *
      **  Initialise work fields .....
      *
      ** Report ref.
     C                   MOVEL     ##PGM         H1REFN
      *
      *  Retrieve title for report.
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1781'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        H2TITL           60
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      *  Retrieve title underline
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1782'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        H2TUL            60
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##ACT            80
      *
      **  Open the relevant Access Path
     C     P#ARCH        IFEQ      'A'
     C                   OPEN      CGXDCRPD
     C                   OPEN      CGXDCRL0
     C                   ELSE
     C                   OPEN      CGUDCRPD
     C                   OPEN      CGUDCRL0
     C                   OPEN      CGUXMLL0                                                 MD025434
     C                   ENDIF
     C*
     C*** Open report and log to RCF
     C                   OPEN      CG5100P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
     C                   MOVE      *BLANKS       ZSENTY
     C                   EXSR      SPLF
     C/COPY WNCPYSRC,CG5100C002
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* SPLF   -  Log Spool File to RCF via ZSFILE                    *
     C*                                                               *
     C* Called by: SRINIT                                             *
     C*                                                               *
     C* Calls: ZSFILE(pgm), SRERR                                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     SPLF          BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SPLF'        @STK(Q)
     C*
     C*................................................................
     C*
     C*
     C                   CALL      'ZSFILE'
     C                   PARM      P#RSEQ        ZSSEQ             5
     C                   PARM                    ZSENTY            3
     C                   PARM                    SFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM                    ZSERR             1
     C*
     C     ZSERR         IFEQ      'Y'
     C                   MOVEL     'ZSFILE  '    W0FILE                         **************
     C                   MOVEL     'ONLY    '    W0KEY                          *DB ERROR 06 *
     C                   Z-ADD     6             W0ERNB                         **************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
      /COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
      /EJECT
      *COPY*CGCPYSRC,SRERRC                                                                 MD056543
      /COPY CGCPYSRC,SRERRCLE                                                               MD056543
**CTDATA ##CPY
(c) Finastra International Limited 2001
