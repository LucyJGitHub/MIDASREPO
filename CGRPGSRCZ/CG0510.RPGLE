     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*OVRF*  OVRDBF (Internal File) (External File)                       *
/*S*D ***RPGBASE*******************************************************                     MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Print Process Extract for Retail Teller')     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG0510 - Print Process Extract Retail Teller                 *
      *                                                               *
      *  Function:  This program reads a selected file (via OPNQRY)   *
      *             for Correspondence Items that match a user's      *
      *             request and outputs the details to CG5100P1       *
      *             which is the relevant printer file                *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (C) COPYRIGHT ACT INTERNATIONAL LTD.1994                     *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 CCG016             Date 21Feb97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG016 - UDC FOR RTS                                         *
      *                                                               *
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  50   -    No Record found on PF/CGUDCRL1                     *
      *  51   -    General indicator                                  *
      *  65   -    Overflow indicator                                 *
      *  90   -    ROLBK indicator                                    *
      *                                                               *
      *                                                               *
      *****************************************************************
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGPGENPD  O    E             DISK
     F                                     INFSR(SRFILE)
     F                                     COMMIT
     FCGUDCRL1  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FCGUDCRL0  UF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
     FCG5100P1  O    E             PRINTER INFDS(SPOOLP)
     F                                     OFLIND(*IN65)
     F                                     USROPN
      *
      /EJECT
      *
      **  Copyright array.
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
     D  ##ACCP                62     63
     D  ##GPTR                64     71
     D  ##STS1                72     75
     D  ##STS2                76     79
     D  ##STS3                80     83
     D  ##STS4                84     87
     D  ##STS5                88     91
     D  ##ATRM                92     92
     D  ##PPFN                93     93
     D  ##COT                 96     96
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
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for bank details
     D  TITL         E                     EXTFLD(BJURPT)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for branches details
     D  BICN         E                     EXTFLD(A8BICN)
      *
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
     D  LINE                 367    368B 0
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
     C                   PARM                    P#RTN             7
     C                   PARM                    P#ITEM           10
     C                   PARM                    P#CUST           10
     C                   PARM                    P#RSEQ            5
     C                   PARM                    P#RLVL            1
     C                   PARM                    P#RBCH            3
     C                   PARM                    P#ARCH            1
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
B01  C     ##INIT        IFEQ      *BLANK
 01  C                   EXSR      SRINIT
 01  C                   MOVE      'Y'           ##INIT            1
E01  C                   ENDIF
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
     C                   MOVEL     P#ITEM        DRITEM
     C                   MOVEL     P#CUST        DRDCOR
     C     KUDCR         CHAIN     CGUDCRL1                           50
      *
      **  For each record found ...
B01  C     *IN50         DOWEQ     *OFF
      *
      **  Initialise the output format.
 01  C                   CLEAR                   @PGENPD
 01  C                   MOVEL     *BLANKS       ##ISTS
      *
      **  Set up the output record with data from PF/CGUDCRL1.
 01  C                   Z-ADD     DRITEM        B2ITEM
 01  C                   MOVE      DRDCOR        B2DCOR
 01  C                   MOVE      DRPCOR        B2PCOR
 01  C                   MOVE      DRBRCA        B2BRCA
 01  C                   MOVE      DRORBR        B2ORBR
 01  C                   MOVE      DROVBR        B2OVBR
 01  C                   MOVE      DRMODI        B2MODI
 01  C                   MOVE      DRMTRN        B2MTRN
 01  C                   MOVE      DRMACT        B2MACT
 01  C                   MOVE      DRPTYP        B2PTYP
 01  C                   MOVE      DRPSTP        B2PSTP
 01  C                   MOVE      DRATRM        B2ATRM
 01  C                   Z-ADD     DRPRTD        B2PRTD
 01  C                   Z-ADD     DRDDAT        B2DDAT
 01  C                   MOVE      DRLGID        B2LGID
      *
      **  Obtain the Correspondent Type using tHe Correspondent.
 01  C     B2DCOR        CHAIN     CGCORRL1                           51
      *
      **  If no record found, process database error.
B02  C     *IN51         IFEQ      *ON
 02  C                   MOVEL     'CGCORRL1'    W0FILE
 02  C                   MOVEL     B2DCOR        W0KEY                          ***************
 02  C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
 02  C                   MOVEL     'MEM5004'     W0MSGD                         ***************
 02  C                   MOVEL     'MIDAS  '     W0MSGF
 02  C                   EXSR      SRERR
E02  C                   ENDIF
      *
      **  Apply selection for correspsondent type here as opposed to in
      **  the OPNQRYF in CGC5230.
B02  C     ##COT         IFEQ      'T'
 02  C     *LIKE         DEFINE    ##DCOR        W0CTYP
 02  C                   MOVEL     ##DCOR        W0CTYP
      *
B03  C     W0CTYP        IFNE      *BLANKS
 03  C     W0CTYP        ANDNE     CDCTYP
 03  C                   GOTO      NXTREC
E03  C                   ENDIF
E02  C                   ENDIF
      *
 01  C     CCG015        IFNE      'Y'
      *
      **  Obtain the Layout, Printer Profile and associated information
 01  C                   CALL      'AOLYPPR0'                             90
 01  C                   PARM      *BLANKS       ##RTCD            7
 01  C                   PARM                    P#PGEN
      *
      **  Error in called program.
      *
B02  C     ##RTCD        IFNE      *BLANK
      *
      **  Set up the Log file fields for this level.
 02  C                   CLEAR                   P#UDCL
 02  C                   Z-ADD     B2ITEM        DLITEM
 02  C                   MOVE      B2DCOR        DLDCOR
 02  C                   MOVEL     'CGD1650'     DLMSID
 02  C                   MOVEL     'CG5100  '    DLCPGM
 02  C                   MOVEL     'AOLYPPR0'    DLRPGM
      *
      **  Output a Log file record.
 02  C                   CALL      'CG9030'
 02  C                   PARM      *BLANKS       ##RTCD            7
 02  C                   PARM      '*WRITE  '    ##PACT            8
 02  C                   PARM                    P#UDCL
 02  C                   PARM      *BLANKS       ##TITL            7
 02  C                   PARM      *BLANKS       ##ULIN            7
 02  C                   PARM      'YES'         ##CMT             3
      *
      **  Terminal error in called program.
B03  C     ##RTCD        IFNE      *BLANKS
 03  C                   MOVEL     ##RTCD        W0KEY
      *
 03  C                   MOVEL     'CG9030  '    W0FILE                         ***************
 03  C                   Z-ADD     02            W0ERNB                         ***************
 03  C                   MOVEL     'MEM5003'     W0MSGD
 03  C                   MOVEL     'MIDAS  '     W0MSGF
 03  C                   EXSR      SRERR
E03  C                   ENDIF
 01  C                   ENDIF
      *
      **  Update with error status
 02  C     *LIKE         DEFINE    DRISTS        ##ISTS
 02  C                   MOVE      'ELAY'        ##ISTS
      **  Obtain the Reference record for update
 02  C     KUDCR         KLIST
 02  C                   KFLD                    DRITEM
 02  C                   KFLD                    DRDCOR
      *
 02  C     KUDCR         CHAIN     @UDCRL0                            51
      *
      **  If no record found, process database error.
B03  C     *IN51         IFEQ      *ON
 03  C                   MOVEL     'CGUDCRL0'    W0FILE
 03  C                   MOVEL     DRDCOR        W0KEY                          ***************
 03  C                   Z-ADD     03            W0ERNB                         * DB ERROR 03 *
 03  C                   MOVEL     'MEM5004'     W0MSGD                         ***************
 03  C                   MOVEL     'MIDAS  '     W0MSGF
 03  C                   EXSR      SRERR
E03  C                   ENDIF
      *
 02  C                   MOVEL     ##ISTS        DRISTS
 02  C                   UPDATE    @UDCRL0
 02  C                   ENDIF
      *
      **  Update the status.
 02  C                   MOVE      'PPFN'        B2ISTS
 02  C                   MOVE      'PPFN'        ##ISTS
      **  Obtain the Reference record for update
      *
 02  C     KUDCR         CHAIN     @UDCRL0                            51
      *
      **  If no record found, process database error.
B03  C     *IN51         IFEQ      *ON
 03  C                   MOVEL     'CGUDCRL0'    W0FILE
 03  C                   MOVEL     DRDCOR        W0KEY                          ***************
 03  C                   Z-ADD     04            W0ERNB                         * DB ERROR 04 *
 03  C                   MOVEL     'MEM5004'     W0MSGD                         ***************
 03  C                   MOVEL     'MIDAS  '     W0MSGF
 03  C                   EXSR      SRERR
E03  C                   ENDIF
      *
 02  C                   MOVEL     ##ISTS        DRISTS
 02  C                   UPDATE    @UDCRL0
      *
 02  C                   EXSR      SRPCUS
      *
      **  Output the extracted Driver record.
      *
      * If system report blank out branch
      *
B03  C     P#RLVL        IFEQ      'S'
 03  C                   MOVEL     *BLANKS       B2BRCA
E03  C                   ENDIF
 02  C                   WRITE     @PGENPD
      *
      * If system report restore branch
      *
B03  C     P#RLVL        IFEQ      'S'
 03  C                   MOVEL     DRBRCA        B2BRCA
E03  C                   ENDIF
      *
      **  Set the records extracted flag to 'Y'.
 01  C                   MOVE      'Y'           P#RECS            1
      *
      **  Commit Changes
 01  C                   COMMIT
      *
 01  C                   CALL      'CG5200'
 01  C                   PARM                    W0RTN             7
 01  C                   PARM      'TELLER'      P#MBRN           10
 01  C                   PARM      'CGPGENL2'    P#ACCP           10
 01  C                   PARM                    P#RSEQ
 01  C                   PARM                    P#RLVL
 01  C                   PARM                    P#RBCH
 01  C                   PARM                    P#ARCH
      *
 01  C     NXTREC        TAG
      *
      **  Read the UDC Reference file (selected via OPNQRYF)
 01  C                   SETON                                            50
      *
E01  C                   ENDDO
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
B01  C     *IN65         IFEQ      *ON
 01  C     #FIRST        ORNE      'Y'                                          No records
 01  C                   WRITE     HEADER
 01  C                   SETOFF                                           65
E01  C                   ENDIF
      *
      *  Write 'No details to report'
      *
B01  C     #FIRST        IFNE      'Y'
 01  C                   WRITE     F5DTL1
E01  C                   ENDIF
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
B01  C     #COUNT        IFEQ      4
 01  C     #FIRST        ORNE      'Y'
 01  C                   MOVEL     'Y'           #FIRST            1
 01  C                   WRITE     HEADER
 01  C                   Z-ADD     1             #COUNT
E01  C                   ENDIF
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
B01  C     B2PRTD        IFGT      0
 01  C                   CALL      'ZDATE2'                             90
 01  C                   PARM                    B2PRTD            5 0          Day No.
 01  C                   PARM      WUDFF         W2DTFM            1            Date Format
 01  C                   PARM      *ZEROS        W2DATE            6 0          Date
 01  C                   PARM      *BLANKS       D1PRTD            7            DDMMMYY
 01  C                   ELSE
 01  C                   MOVE      'NO DATE'     D1PRTD
E01  C                   ENDIF
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
     C     SDBANK        PARM      *BLANKS       DSFDY             7
      *
      **  If return with an error (LR seton in called program)
      **  then process for database error.
      *
B01  C     *IN90         IFEQ      '1'
 01  C     P@RTCD        OREQ      '*ERROR*'
 01  C                   MOVEL     'AOBANKR0'    W0FILE
 01  C                   MOVEL     '*CALL'       W0KEY                          ***************
 01  C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 *
 01  C                   MOVEL     'MEM5003'     W0MSGD                         ***************
 01  C                   MOVEL     'MIDAS  '     W0MSGF
E01  C                   END
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
     C                   OPEN      CGUDCRL1
     C                   OPEN      CGUDCRL0
     C*
     C*** Open report and log to RCF
     C                   OPEN      CG5100P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
     C                   MOVE      *BLANKS       ZSENTY
     C                   EXSR      SPLF
      *
     C                   MOVEL     *BLANKS       CCG015            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CCG015'      PSAR              6
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     'Y'           CCG015
     C                   END
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
B01  C     ZSERR         IFEQ      'Y'
 01  C                   MOVEL     'ZSFILE  '    W0FILE                         **************
 01  C                   MOVEL     'ONLY    '    W0KEY                          *DB ERROR 06 *
 01  C                   Z-ADD     6             W0ERNB                         **************
 01  C                   MOVEL     'MEM5003'     W0MSGD
 01  C                   MOVEL     'MIDAS  '     W0MSGF
 01  C                   EXSR      SRERR
E01  C                   END
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
(c) COPYRIGHT ACT INTERNATIONAL LIMITED 1994
