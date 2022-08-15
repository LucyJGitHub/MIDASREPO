     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058069
/*STD *  RPGSQLBND                                                    *                     MD058069
/*EXI *  TEXT('Midas CG C/M - Process selection')                     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG5010 - Correspondence Maintenance - process selection      *
      *                                                               *
      *  Function:  This program processes actions on Correspondence  *
      *             items selected in CG5000.                         *
      *                                                               *
      *  Called By: CG5000                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058069           Date 11May21               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR797795           Date 19Jul11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 13Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 116275             Date 07Apr97               *
      *                 S01408             DATE 19AUG96               *
      *                 083775             DATE 17FEB95               *
      *                 083785             DATE 17FEB95               *
      *                 S01522             DATE 01FEB95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058069 - Deliverable Data Split for Correspondence Mgr 2   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR797795 - Interest Scale Report Enquiry is missing in       *
      *             BFMidas                                           *
      *  CCG015 - Correspondence Manager Phase 1 (Recompile)          *
      *  116275 - Recompiled due to change of display file.(CG5010DF) *
      *  S01408 - Core Hook CG5010CCP1 Added
      *         - Core Hook CG5010FFP1 Added
      *  083775 - Format retention period as a date in Archive mode   *
      *  083785 - Scheduled print date should only be formatted if    *
      *           non-zero                                            *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
      /COPY WNCPYSRC,CG5010DFPG
     FCG5010DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Edit Reference Record     Edit record(1 screen)
      *
     FCGUDCRL1  IF   E           K DISK    USROPN
      **  UPD : UDC Data Reference        Retrieval index
     F                                     INFSR(SRFILE)
      *
     FCGUDCRL0  UF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      * RTV : UDC Data Reference        Update index
      *
     FCGXDCRL1  IF   E           K DISK    USROPN
      **  UPD : UDC Data Reference (Archive) Retrieval index
     F                                     INFSR(SRFILE)
      *
     FCGXDCRL0  UF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      * RTV : UDC Data Reference (Archive)       Update index
      *
     F*CGISTSL1* IF   E           K DISK                                                    MD058069
     F**********                           INFSR(SRFILE)                                    MD058069
     F*                                                                   S01408
     F/COPY WNCPYSRC,CG5010FFP1                                           S01408
     F*                                                                   S01408
      *
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*  Array containing Copyright statement
     D*
      *COPY*CGCPYSRC,SRERRE                                                                 MD058069
      /COPY CGCPYSRC,SRERRDLE                                                               MD058069
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
      /COPY WNCPYSRC,CG5010DEPG
      /EJECT
      *COPY*CGCPYSRC,SRERRI                                                                 MD058069
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
      /COPY WNCPYSRC,CG5010DIPG
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
     D P#UDCL        E DS                  EXTNAME(CGUDCLPD)
      **  External DS for parameters based on PF/CGUDCLPD
      *
     D #1DBRC          DS           179
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D CGISTS        E DS                  EXTNAME(CGISTJW0)                                MD058069
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            15
      * KEY: UDC Data Reference        Retrieval index
      * I : MAP Item Identifier
     D  P2ITEM                 1      5P 0
      * I : MAP Destination Correspondent
     D  P2DCOR                 6     15
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D ##KEY           DS
     D  ##ITEM                 1      5P 0
     D  ##DCOR                 6     15
      ** Used to report database error
      *
     D ##MSDT          DS
     D  DRITEM                 1      5P 0
     D  DRDCOR                 6     15
     D  DRAUSR                16     25
      ** Message data for log file
      *
     D #STSNF          DS            24
     D  #STSN1                 1     17    INZ('<Description not')
     D  #STSN2                18     24    INZ(' found>')
      ** Standard narrative for item status not found
      *
     D P0KEYI          DS           100
      **  Define data structure used to pass parameters
      *
     D  ##ARCH                 1     10
     D  ##FPGM                11     20                                                           AR
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: UDC Data R
     C                   PARM                    P3PARM            4            Return status
     C                   PARM                    P0KEYI
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      ** Display and process screen
     C                   EXSR      CADSDA
      *
     C     ##FPGM        IFEQ      'CG007020'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *                                                                                     AR797795
     C                   RETURN
      *
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      *
      ** Access details on file and set up screen fields
     C                   EXSR      SRGETR
      *
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C     *IN10         IFEQ      '1'
     C                   EXSR      SRDELT
     C                   ENDIF
      *
      ** Exit program
     C                   EXSR      ZXEXPG
      *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   SETON                                        8788
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   SRGETR        BEGSR
      *================================================================
      * Get reference details
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to Reference Rec fields
     C                   Z-ADD     P2ITEM        DRITEM                         Item Identifier
     C                   MOVEL     P2DCOR        DRDCOR                         Destination Cor
      *
     C     KLCHSC        KLIST
     C                   KFLD                    DRITEM                         Item Identifier
     C                   KFLD                    DRDCOR                         Destination Cor
      *
     C     ##ARCH        IFEQ      'ARCHIVE '
     C     KLCHSC        CHAIN     @XDCRL1                            90
     C                   ELSE
     C     KLCHSC        CHAIN     @UDCRL1                            90
     C                   ENDIF
      *
     C     *IN90         IFEQ      '1'
      * Record not found - database error
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   MOVEL     'CGXDCRL1'    W0FILE
     C                   ELSE
     C                   MOVEL     'CGUDCRL1'    W0FILE
     C                   ENDIF
     C                   MOVEL     DRITEM        ##ITEM
     C                   MOVEL     DRDCOR        ##DCOR
     C                   MOVEL     ##KEY         W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Decode item status
     C*****DRISTS        CHAIN     @ISTSL1                            90                    MD058069
     C/EXEC SQL                                                                             MD058069
     C+ SELECT *                                                                            MD058069
     C+ into :CGISTS                                                                        MD058069
     C+ from CGISTJW0                                                                       MD058069
     C+ where ISISTS = :DRISTS and ISRECI = 'D'                                             MD058069
     C/END-EXEC                                                                             MD058069
     C                   SETOFF                                       90                    MD058069
     C                   If        SQLCODE = 100                                            MD058069
     C                   SETON                                        90                    MD058069
     C                   ENDIF                                                              MD058069
      *
      ** If NrF, set screen field to <Description not found>
     C     *IN90         IFEQ      '1'
     C                   MOVEL     #STSNF        #1STDS
     C                   ELSE
      *
      ** Otherwise, use message id to get description
     C                   CALL      'CGC0100'                            9090
     C                   PARM      ISIMSG        #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   PARM      *BLANKS       ##RTCD
      *
      ** Use retrieved message text, if found.
     C     ##RTCD        IFEQ      '*NRF   '
     C                   MOVEL     ISDESC        #1STDS
     C                   ELSE
     C                   MOVEL     #MSTX1        #1STDS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Set up screen fields
     C                   MOVEL     P1ACTC        #PACTC                         Action code
     C                   Z-ADD     DRITEM        #1ITEM                         Item Identifier
     C                   MOVEL     DRRECI        #1RECI                         Record Identifi
     C                   MOVEL     DRMSHT        #1MSHT                         Mail Shot Ident
     C                   MOVEL     DRAJOB        #1AJOB                         Job name
     C                   MOVEL     DRAACT        #1AACT                         Action Type
     C                   Z-ADD     DRRDNB        #1RDNB                         Run day number
     C                   MOVEL     DRDCOR        #1DCOR                         Destination Cor
     C*                                                                   S01408
     C/COPY WNCPYSRC,CG5010CCP1                                           S01408
     C*                                                                   S01408
     C                   MOVEL     DRBRCA        #1BRCA                         Branch Code
     C                   MOVEL     DRPCOR        #1PCOR                         Primary Corresp
     C                   MOVEL     DRORBR        #1ORBR                         Originating Bra
     C                   MOVEL     DRMODI        #1MODI                         Module id
     C                   MOVEL     DROVBR        #1OVBR                         Overriding Bran
     C                   MOVEL     DRPTYP        #1PTYP                         Print Item Type
     C                   MOVEL     DRPSTP        #1PSTP                         Print Item Sub-
     C                   MOVEL     DRMTRN        #1MTRN                         Midas Transacti
     C                   MOVEL     DRMACT        #1MACT                         Midas Account I
     C                   MOVEL     DRISTS        #1ISTS                         Item Status
     C                   MOVEL     DRCHQR        #1CHQR                         Cheque Referenc
     C                   MOVEL     DRATRM        #1ATRM                         Auto-Transmissi
     C                   MOVEL     DRLGID        #1LGID                         Language identi
     C                   MOVEL     DRFREF        #1FREF                         Further Referen
     C                   MOVEL     DRAUSR        #1AUSR                         User name
     C                   Z-ADD     DRATIM        #1ATIM                         Action Time
     C                   MOVEL     DRARDT        #1ARDT                         Action Date
     C                   Z-ADD     DRDDAT        #1DDAT                         Scheduled Drop
      *                                                                   083775
      **  Format Date for display                                         083775
      *                                                                   083775
      * If Current format as a number, else format as date if non         083775
      * zero                                                              083775
      *                                                                   083775
     C                   SELECT                                                                08377
     C     DRDDAT        WHENGT    0                                                           08377
     C     ##ARCH        ANDEQ     'ARCHIVE '                                                  08377
     C                   Z-ADD     DRDDAT        SSDAYN                                        08377
     C                   CALL      'ZA0140'                                                    08377
     C                   PARM                    SSDAYN                                        08377
     C                   PARM      WUDFF         SSDFMT                                        08377
     C                   PARM      *ZEROS        SSDATE                                        08377
     C                   PARM      *BLANKS       SSDATA                                        08377
     C                   PARM      *BLANK        SSRTN                                         08377
     C                   PARM      *ZEROS        SSDAT8                                        08377
     C                   MOVEL     SSDATE        #1DDTA                                        08377
     C     DRDDAT        WHENGT    0                                                           08377
     C                   Z-ADD     DRDDAT        ZFLD15                                        08377
      *                                                                   083775
     C                   CALL      'ZSEDIT'                                                    08377
     C                   PARM                    ZFLD15           15 0                         08377
     C                   PARM      0             ZDECS             1 0                         08377
     C                   PARM      *BLANKS       ZECODE            1                           08377
     C                   PARM      *BLANKS       ZOUT21           21                           08377
      *                                                                   083775
     C     6             SUBST     ZOUT21:15     #1DDTA                                        08377
     C                   OTHER                                                                 08377
     C                   MOVEL     'Unknown'     #1DDTA                                        08377
     C                   ENDSL                                                                 08377
      *
      **  Format Date for display
      *                                                                   083785
      * If 0 add text IMMED, if -1 add text HOLD                          083785
      *                                                                   083785
     C                   SELECT                                                                08378
     C     DRPRTD        WHENGT    0                                                           08378
     C                   Z-ADD     DRPRTD        SSDAYN                         Scheduled Print
     C                   CALL      'ZA0140'
     C                   PARM                    SSDAYN            5 0
     C                   PARM      WUDFF         SSDFMT            1
     C                   PARM      *ZEROS        SSDATE            6 0
     C                   PARM      *BLANKS       SSDATA            7
     C                   PARM      *BLANK        SSRTN             1
     C                   PARM      *ZEROS        SSDAT8            8 0
     C                   MOVEL     SSDATE        #1PRDA                         Scheduled Print
     C     DRPRTD        WHENEQ    0                                            Scheduled Print08378
     C                   MOVEL     'IMED   '     #1PRDA                                        08378
     C     DRPRTD        WHENEQ    -1                                           Scheduled Print08378
     C                   MOVEL     'HOLD   '     #1PRDA                                        08378
     C                   OTHER                                                  Scheduled Print08378
     C                   MOVEL     'Unknown'     #1PRDA                                        08378
     C                   ENDSL                                                                 08378
      *================================================================
     CSR   EXGETR        ENDSR
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
      * Cancel and exit from key screen
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
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,CG5010DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      ** If From Program comes from CG007020, set On the LR indicator as                    AR797795
      ** the program enquires current and archived data.  Database error will               AR797795
      ** occur if LR indicator is not set On because of the opening/closing of files        AR797795
     C     ##FPGM        IFEQ      'CG007020'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      * Subroutine  :  SRDELT                                         *
      * Function    :  Delete item                                    *
      *                                                               *
      * Called by   :  CADSDA                                         *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRDELT        BEGSR
      *
      ** Delete attempted, so disable action for next time
     C                   MOVEL     ##ENQY        ##CMD2
     C                   MOVE      '0'           *IN89
      *
      ** Re-access item on update index
     C     ##ARCH        IFEQ      'ARCHIVE '
     C     KLCHSC        CHAIN     @XDCRL0                            90
     C                   ELSE
     C     KLCHSC        CHAIN     @UDCRL0                            90
     C                   ENDIF
      *
      ** Record not found - database error
     C     *IN90         IFEQ      '1'
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   MOVEL     'CGXDCRL0'    W0FILE
     C                   ELSE
     C                   MOVEL     'CGUDCRL0'    W0FILE
     C                   ENDIF
     C                   MOVEL     DRITEM        ##ITEM
     C                   MOVEL     DRDCOR        ##DCOR
     C                   MOVEL     ##KEY         W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Check item is still eligible for deletion. If it is, delete
      ** it, and write a log file record. If not, redisplay screen
      ** in enquire only mode and warning message.
     C     DRISTS        IFNE      'PRTD'
     C     DRISTS        ANDNE     'DLTD'
     C                   MOVEL     'DLTD'        DRISTS                         Item status
     C                   MOVEL     ##JOB         DRAJOB                         Job name
     C                   MOVEL     ##USR         DRAUSR                         User name
     C                   TIME                    DRATIM                         Action Time
     C                   MOVEL     AGMRDT        DRARDT                         Action Date
     C                   MOVEL     'D'           DRAACT                         Action Type
     C                   Z-ADD     AGRDNB        DRRDNB                         Run day number
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   UPDATE    @XDCRL0
     C                   ELSE
     C                   UPDATE    @UDCRL0
     C                   ENDIF
      *
      **  Output a Log file record.
     C                   CLEAR                   P#UDCL
     C                   MOVEL     'CGD1623'     DLMSID
     C                   Z-ADD     DRITEM        DLITEM
     C                   MOVE      DRDCOR        DLDCOR
     C                   MOVEL     ##MSDT        DLMSDT
     C                   MOVEL     'CG5020  '    DLCPGM
     C                   MOVEL     'CG5010  '    DLRPGM
      *
     C                   CALL      'CG9030'                             9090
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*WRITE  '    ##ACT             8
     C                   PARM                    P#UDCL
     C                   PARM      *BLANKS       ##TITL            7
     C                   PARM      *BLANKS       ##ULIN            7
     C                   PARM      'YES'         ##CMT             3
      *
     C     *IN90         IFEQ      '1'
     C     ##RTCD        ORNE      *BLANKS
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   MOVEL     'CGXDCLL0'    W0FILE
     C                   ELSE
     C                   MOVEL     'CGUDCLL0'    W0FILE
     C                   ENDIF
     C                   MOVEL     DRITEM        ##ITEM
     C                   MOVEL     DRDCOR        ##DCOR
     C                   MOVEL     ##KEY         W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Commit changes
     C                   COMMIT
      *
     C                   ELSE
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   UNLOCK    CGXDCRL0
     C                   ELSE
     C                   UNLOCK    CGUDCRL0
     C                   ENDIF
     C                   MOVEL     'CGD1619'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     '0'           *IN89
     C                   MOVEL     ##ENQY        ##CMD2
     C                   EXSR      CBEXFM
     C                   ENDIF
      *
     C                   ENDSR
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
      * Define work field Midas run date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Change mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C                   MOVEA     CPY@          ACT@             80
     C*
     C* Get Rundate - Rundate  *
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
     C                   Z-ADD     4             W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      **  Open fileS
     C     FIL001        IFEQ      *BLANKS
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   OPEN      CGXDCRL0
     C                   ELSE
     C                   OPEN      CGUDCRL0
     C                   ENDIF
     C                   MOVEL     'Y'           FIL001            1
     C                   ENDIF
      *
     C     FIL002        IFEQ      *BLANKS
     C     ##ARCH        IFEQ      'ARCHIVE '
     C                   OPEN      CGXDCRL1
     C                   ELSE
     C                   OPEN      CGUDCRL1
     C                   ENDIF
     C                   MOVEL     'Y'           FIL002            1
     C                   ENDIF
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
      ** Set up command keys - CGD1787 for Delete; CGD1592 for Enquire
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1787'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        ##DELT          132
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1592'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     #MSTX1        ##ENQY          132
      *
     C     P1ACTC        IFEQ      'D'
     C                   MOVEL     ##DELT        ##CMD2
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVEL     ##ENQY        ##CMD2
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,CG5010DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
      *
      ** PSSR Processing
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD058069
      /COPY CGCPYSRC,SRERRPSSRL                                                             MD058069
      *
      ** File and Program Error Processing
      *COPY*CGCPYSRC,SRERRC                                                                 MD058069
      /COPY CGCPYSRC,SRERRCLE                                                               MD058069
      *
     O/COPY WNCPYSRC,CG5010DOPG
**  CPY@
(c) Finastra International Limited 2001
