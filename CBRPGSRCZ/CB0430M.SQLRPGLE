     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Mut. excl. components maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0430M - Mutually Exclusive Maintenance.                    *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             mutually exclusive components file.               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 095107             Date 22MAY96               *
      *                 090416             Date 12JUL95               *
      *                 S01459             Date 12JUL95               *
      *                 S01417             Date 24AUG93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  095107 - Mutually Exclusive Components not updated to file   *
      *           where MEC sequence 001 has been deleted - fix is to *
      *           read all records for the component and add 1 to the *
      *           last sequence number found.                         *
      *  090416 - 1. Standardise the header/footer.                   *
      *           2. Remove 'mutually exclusive unique number' from   *
      *              the screen and generate it in the background.    *
      *           3. Create both sides of the mutually exclusive      *
      *              record.                                          *
      *           4. Addition of help.                                *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01417 - Add 1A function input parameter to indicate         *
      *              successful update made to master file            *
      *                                                               *
      *****************************************************************
     FCB0430M#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB Mutually exclusive maintenance subfile
      *
     F*CBMEXCL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Mutually exclusive component retrieval
      *
     F*CBCMPNL3* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0001)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Components             mutually exclusives
      *
     F*CBMEXCL2* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0002)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RSQ : Midas CB Mutually exclusive component
      *
     F*CBMEXCL0* UF A E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0003)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Midas CB Mutually exclusive component update
      *
     F*CBCMPNL0* UF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0004)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Components             e
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
      *
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(CBMEXCL0)                                MD055891
     D @1DBRC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
     D                                     PREFIX(X)                                        MD055891
      * UPD : Midas CB Mutually exclusive component update
      * Current/previous master file format fields for change control
      *
     D*QCBCM1***     E DS                  EXTNAME(CBCMPNL0)                                MD055891
     D QCBCM1        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D                                     PREFIX(X)                                        MD055891
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D WDHCOTT         S             10                                                     MD055891
     D WDHCSEQ         S              5                                                     MD055891
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
     D WDKCOTT         S             10                                                     MD055891
     D WDKCSEQ         S              5                                                     MD055891
     D WDKMEUN         S              2                                                     MD055891
     D TotRow          S             13  0                                                  MD055891

      * UPD : Components             e
     D YARDCS          DS           262
     D YBRDCS          DS           262
     D YCRDCS          DS            32
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
     D ID0004          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * B :  Successful Update Made
     D  P1SUPD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Member Name
     D  ZA0001                 1     10
      * Message data for 'Combination exists.'
      * Component Name
     D  ZA0002                 1     10
      * Component Sequence Number
     D  ZA0003                11     15
      * Mut. Excl. Component Name
     D  ZA0004                16     25
      * Mut. Excl. Compnt Seq No
     D  ZA0005                26     30
      * Message data for 'Combination exists.'
      * Component Name
     D  ZA0006                 1     10
      * Component Sequence Number
     D  ZA0007                11     15
      * Mut. Excl. Component Name
     D  ZA0008                16     25
      * Mut. Excl. Compnt Seq No
     D  ZA0009                26     30
     I*@MEXCG8**                                                                            MD055891
      * Midas CB Mutually exclusive component
      * Renamed input format fields
     I**********    DKCOTT                      WACOTT                                      MD055891
     I**********    DKCSEQ                      WACSEQ                                      MD055891
     I**********    DKMEUN                      WAMEUN                                      MD055891
     I**********    DKMECN                      WAMECN                                      MD055891
     I**********    DKMECS                      WAMECS                                      MD055891
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SUPD        PARM      P1SUPD        WP0001            1            Successful Upda
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile header
      * Start of 090416
      * Footer for edit file - Mutually Exclusive Compnt  *
     C*****************************************************************
     C*  Set up the function key footer text
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If program mode is ADD:
     C*
     C     W0PMD         IFEQ      'ADD'
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
     C                   MOVEL     'CBM0197'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C*
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'CBM0198'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   END
      * End of 090416
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2COTT        WZCOTT
     C                   MOVEL     #2COTT        WZCOTT                         Component Name
     C     *LIKE         DEFINE    #2CSEQ        WZCSEQ
     C                   MOVEL     #2CSEQ        WZCSEQ                         Component Seque
     C     KPOS          KLIST
     C                   KFLD                    DKCOTT                         Component Name
     C                   KFLD                    DKCSEQ                         Component Seque
     C                   KFLD                    DKMEUN                         Mutually Excl.
      * Setup key
     C                   MOVEL     #2COTT        DKCOTT                         Component Name
     C                   MOVEL     #2CSEQ        DKCSEQ                         Component Seque
     C                   MOVEL     #2MEUN        DKMEUN                         Mutually Excl.
                                                                                            MD055891
      * 82=EOF
     C*****KPOS*         SETLL     @DKREGQ                            82        *           MD055891
      * 82=EOF
     C**N82*****         READ      @DKREGQ                              9182    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT >= :DKCOTT and DKCSEQ >= :DKCSEQ                                       MD055891
     C+ and DKMEUN >= :DKMEUN                                                               MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       82                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        82                    MD055891
     C                   ELSE                                                               MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      * Load subfile page
     C                   EXSR      BBLDSF
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      * Re-establish fields in read-ahead record
     C   27W0PMD         IFNE      'ADD'
     C**N82*****         READP     @DKREGQ                                90    *           MD055891
     C**N82*****         READ      @DKREGQ                                90    *           MD055891
     C                   If        *IN82 = '0'                                              MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch prior from ACursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Endif                                                              MD055891
     C                   END
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            5
     C                   MOVE      *ALL'1'       WKIND1            5
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
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
      * Load next subfile page
     C**N82##RROK        DOWLT     ##SFLN                                       DO          MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
     C                             and ##RROK < ##SFLN                                      MD055891
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       87        *
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      * Validate subfile record and calculate derived fields
     C                   EXSR      DFV2RC
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C**********         READ      @DKREGQ                                82    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   END
     C  N82              END
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
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
     C     W0PMD         IFNE      'ADD'
      * Check Component Sequence Number is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #2CSEQ               90  90    *
     C   90              MOVE      #2CSEQ        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#2CSEQ        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #2CSEQ        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZCOTT        CASNE     #2COTT        FBRQRL                         Component Name
     C     WZCSEQ        CASNE     #2CSEQ        FBRQRL                         Component Seque
     C                   END
     C                   END
      * Quit if reload requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END
      * Switch between *ADD/*CHANGE modes
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(33)
      * No errors
     C                   SETOFF                                       98
      * No SFLNXTCHG
     C                   SETOFF                                       84
     C     W0PMD         IFEQ      'ADD'
      * Check for null record
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      * If not null record, continue
     C                   END
      * Data entered
     C                   MOVEL     'Y'           WKIPIN
      * SFLNXTCHG
     C                   SETON                                        84
      * If delete request, bypass validation
     C     #1SEL         IFEQ      'D'
     C                   GOTO      DCEXIT
     C                   END
      * Validate subfile record
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        *
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1COTT        CABNE     *BLANK        DDEXIT                         Component Name
     C     #1CSEQ        CABNE     *BLANK        DDEXIT                         Component Seque
     C     #1MECN        CABNE     *BLANK        DDEXIT                         Mut. Excl. Comp
     C     #1MECS        CABNE     *BLANK        DDEXIT                         Mut. Excl. Comp
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Check Component Sequence Number is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1CSEQ               90  90    *
     C   90              MOVE      #1CSEQ        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1CSEQ        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1CSEQ        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * Check Mut. Excl. Compnt Seq No is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1MECS               90  90    *
     C   90              MOVE      #1MECS        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1MECS        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1MECS        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9837      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * USER: Validate subfile record fields
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     #1MEUN        WUJ8ST                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUJ8ST        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '?INVAL'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     #1MEUN        ZA0001                         Mutually Excl.
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of 090416
      * Component name & Component Seq no (check existence)
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     'N'           WUERCD                         Err Code
      * 1st combination exist ? - Mutually Exclusive Compnt  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0002                         Component Name
     C                   MOVEL     #1CSEQ        ZA0003                         Component Seque
     C                   MOVEL     #1MECN        ZA0004                         Mut. Excl. Comp
     C                   MOVEL     #1MECS        ZA0005                         Mut. Excl. Comp
      * Send message 'Combination exists.'
     C                   MOVEL     'CBM0149'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983435    *
     C                   SETON                                        3637      *
      *
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
      * 2nd combination exist ? - Mutually Exclusive Compnt  *
     C                   EXSR      SBRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0006                         Component Name
     C                   MOVEL     #1CSEQ        ZA0007                         Component Seque
     C                   MOVEL     #1MECN        ZA0008                         Mut. Excl. Comp
     C                   MOVEL     #1MECS        ZA0009                         Mut. Excl. Comp
      * Send message 'Combination exists.'
     C                   MOVEL     'CBM0149'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        983435    *
     C                   SETON                                        3637      *
      *
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of 090416
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Component Name required
     C     #1COTT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Sequence Number required
     C     #1CSEQ        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Mut. Excl. Component Name required
     C     #1MECN        IFEQ      *BLANK                                       IF
     C                   SETON                                        9836      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Mut. Excl. Compnt Seq No required
     C     #1MECS        IFEQ      *BLANK                                       IF
     C                   SETON                                        9837      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      * Check reference to Components
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983435    *
     C                   END
      * Check reference to Components
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983637    *
     C                   END
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      * Process all modified subfile records
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       98
      *
     C     W0PMD         IFEQ      'ADD'
      * Process add request
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      * Process delete request
     C                   EXSR      EDDLRQ
     C                   ELSE
      * Process change request
     C                   EXSR      EECHRQ
     C                   END
     C                   END
      * If error occurred on update, note the fact
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        *
     C                   END
     C                   ELSE
      * there seems to be core error where after delete, blank records                     MD055891
      * are inserted                                                                       MD055891
     C                   MOVEL     ' '           WUERCD                                    MD055891
      * USER: Extra processing after DBF update
      * Start of 090416
      * Component name & Component Seq no (check existence)
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     'N'           WUERCD                         Err Code
      * 1st combination exist ? - Mutually Exclusive Compnt  *
     C                   EXSR      SCRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
      * 2nd combination exist ? - Mutually Exclusive Compnt  *
     C                   EXSR      SDRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Not Found
     C     WUERCD        IFEQ      'N'                                          *IF
     C                   Z-ADD     *ZERO         WUMEXN                         Mut exc unique
     C                   MOVEL     '01'          WUMEUN                         Mutually Excl.
     C                   Z-ADD     *ZERO         WUMENN                         Mut. exc. uniq
     C                   MOVEL     '01'          WUWMEN                         Mut. excl. uniq
      * Create both sides of excl - Mutually Exclusive Compnt  *
      *
     C     *IN98         IFNE      '1'
     C                   SETOFF                                         9190
      *
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQCOTT                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQCSEQ                         Component Seque
     C     *LIKE         DEFINE    DKMECN        WQMECN                         Mut Exl Comp Nm
     C     *LIKE         DEFINE    DKMECS        WQMECS                         Mut Exl Comp Sq
      *
      * Define keylist
     C     KCBMX         KLIST
     C                   KFLD                    WQCOTT                         Component Name
     C                   KFLD                    WQCSEQ                         Component Seque
      * Define keylist
     C     KMEXC         KLIST
     C                   KFLD                    WQMECN                         MUT EXL COMP NM
     C                   KFLD                    WQMECS                         MUT EXL COMP SQ
      *
      * Move fields to key list
     C                   MOVEL     #1COTT        WQCOTT                         Component Name
     C                   MOVEL     #1CSEQ        WQCSEQ                         Component Seque
      *
     C*****KCBMX         SETLL     @DKREGQ                                      *           MD055891
     C*****KCBMX         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare CDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :WQCOTT and DKCSEQ = :WQCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close CDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open CDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
      *
     C     *IN90         IFEQ      '1'
      * Data record not found
      * Processing if Data record not found
     C                   Z-ADD     01            WUSUNB
      * Move all fields to @DKREGP
     C                   MOVEL     #1COTT        DKCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DKCSEQ                         Component Seque
     C**********         MOVEL     WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVE      WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVEL     #1MECN        DKMECN                         Mut. Excl. Comp
     C                   MOVEL     #1MECS        DKMECS                         Mut. Excl. Comp
      *
     C**********         WRITE     @DKREGP                              91      *           MD055891
     C                   MOVEL     'N'           WUCRRC                         Create recorMD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
     C                   MOVEL     'Y'           WUWMUT            1            Write Mut excl
      *
     C                   END
     C                   END
      *
      *
      * Start from first unique no. found.                                095107
     C                   MOVE      DKMEUN        WUMEUN                         Mut exc unique 09510
     C                   MOVE      WUMEUN        WUMEXN                         Mut exc unique
      *
     C     *IN90         DOWEQ     '0'
      * Process Data record
      * Mutually Excl. Unique No EQ DB1.Mutually Excl. Unique NO.
     C     WUMEUN        IFEQ      DKMEUN                                       *IF
      *
     C                   ADD       01            WUMEXN                         Mut exc unique
     C                   MOVE      WUMEXN        WUMEUN                         Mut exc unique
     C                   MOVE      DKMEUN        WUSUNB            2 0
     C                   ADD       01            WUSUNB
     C                   MOVEL     'Y'           WUCRRC            1            Create record f
      *
     C                   END                                                    *FI
     C*****KCBMX         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
      *
     C                   END                                                    *FI
      *
     C     WUCRRC        IFEQ      'Y'
      * Move all fields to @DKREGP
     C                   MOVEL     #1COTT        DKCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DKCSEQ                         Component Seque
     C**********         MOVEL     WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVE      WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVEL     #1MECN        DKMECN                         Mut. Excl. Comp
     C                   MOVEL     #1MECS        DKMECS                         Mut. Excl. Comp
      *
     C**********         WRITE     @DKREGP                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
     C                   MOVEL     'Y'           WUWMUT                         Write Mut excl
      *
     C                   END
     C                   END                                                    *FI
      *
      * Write the record for Mut. Excl. Compponent.
      *
     C     WUWMUT        IFEQ      'Y'
      *
      * Move fields to key list
      *
     C                   MOVEL     #1MECN        WQMECN                         MUT EXL COMP NM
     C                   MOVEL     #1MECS        WQMECS                         MUT EXL COMP SQ
      *
     C                   SETOFF                                         9190
     C                   MOVEL     'N'           WUCRRC                         Create record f
      *
     C*****KMEXC         SETLL     @DKREGQ                                      *           MD055891
     C*****KMEXC         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare DDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :WQMECN and DKCSEQ = :WQMECS                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close DDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open DDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
      *
     C     *IN90         IFEQ      '1'
      * Data record not found
      * Processing if Data record not found
     C                   Z-ADD     01            WUSUNB
      * Move all fields to @DKREGP
      *
     C                   MOVEL     #1MECN        DKCOTT                         Component Name
     C                   MOVEL     #1MECS        DKCSEQ                         Component Seque
     C**********         MOVEL     WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVE      WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVEL     #1COTT        DKMECN                         Mut. Excl. Comp
     C                   MOVEL     #1CSEQ        DKMECS                         Mut. Excl. Comp
      *
     C**********         WRITE     @DKREGP                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      *
      * Move 'Y' into parameter if DBF update complete
      *
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      *
     C                   END
     C                   END
      *
      * Start from first unique no. found.                                095107
     C                   MOVE      DKMEUN        WUWMEN                         Mut exc unique 09510
     C                   MOVE      WUWMEN        WUMENN                         Mut exc unique
      *
      ** Record found
      *
     C     *IN90         DOWEQ     '0'
      * Process Data record
      * Mutually Excl. Unique No EQ DB1.Mutually Excl. Unique NO.
      *
     C     WUWMEN        IFEQ      DKMEUN                                       *IF
      *
     C                   ADD       01            WUMENN                         Mut exc unique
     C                   MOVE      WUMENN        WUWMEN                         Mut exc unique
     C                   MOVE      DKMEUN        WUSUNB
     C                   ADD       01            WUSUNB
     C                   MOVEL     'Y'           WUCRRC                         Create record f
      *
     C                   END                                                    *FI
     C*****KMEXC         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
      *
     C                   END                                                    *FI
      *
     C     WUCRRC        IFEQ      'Y'
      * Move all fields to @DKREGP
     C                   MOVEL     #1MECN        DKCOTT                         Component Name
     C                   MOVEL     #1MECS        DKCSEQ                         Component Seque
     C**********         MOVEL     WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVE      WUSUNB        DKMEUN                         Mutually ExcMD055891
     C                   MOVEL     #1COTT        DKMECN                         Mut. Excl. Comp
     C                   MOVEL     #1CSEQ        DKMECS                         Mut. Excl. Comp
      *
     C**********         WRITE     @DKREGP                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,:DKMEUN                                                                           MD055891
     C+  ,:#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   ELSE
      *
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      *
     C                   END
     C                   END                                                    *FI
      *
     C                   END
      *
     C                   END
     C                   END                                                    *FI
      * End of 090416
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Do not create - Mutually Exclusive Compnt  *
     C                   EXSR      SECRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Mutually Exclusive - Mutually Exclusive Compnt  *
     C                   EXSR      SFDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
      * Reload subfile
     C                   MOVEL     'Y'           W0RSF             1
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Mutually Exclusive - Mutually Exclusive Compnt  *
     C                   EXSR      SOCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF update successful
      * Enable entry
     C                   SETOFF                                       87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN78
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   MOVEL     *BLANK        #1MEUN                         Mutually Excl.
     C                   MOVEL     *BLANK        #RWMEN                         Mut. excl. uniq
     C                   MOVEL     *BLANK        #RCRRC                         Create record f
     C                   MOVEL     *BLANK        #RCRCF                         Create. record.
     C                   MOVEL     *BLANK        #RRECF                         Record flag
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1COTT                         Component Name
     C                   MOVEL     *BLANK        #1CSEQ                         Component Seque
     C                   MOVEL     *BLANK        #1MECN                         Mut. Excl. Comp
     C                   MOVEL     *BLANK        #1MECS                         Mut. Excl. Comp
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DKREGQ fields to subfile
      *================================================================
     C                   MOVEL     DKMEUN        #1MEUN                         Mutually Excl.
     C                   MOVEL     DKCOTT        #1COTT                         Component Name
     C                   MOVEL     DKCSEQ        #1CSEQ                         Component Seque
     C                   MOVEL     DKMECN        #1MECN                         Mut. Excl. Comp
     C                   MOVEL     DKMECS        #1MECS                         Mut. Excl. Comp
      * Hold current record image for change detection
     C                   eval      @1DBRC = CBMEXC                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2MEUN                         Mutually Excl.
     C                   MOVEL     *BLANK        #2COTT                         Component Name
     C                   MOVEL     *BLANK        #2CSEQ                         Component Seque
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * 1st combination exist ? - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSA01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSA02                         Component Seque
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    WQSA01                         Component Name
     C                   KFLD                    WQSA02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSA01                         Component Name
     C                   MOVEL     #1CSEQ        WQSA02                         Component Seque
     C*****KRSSA         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSA         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare EDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close EDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open EDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from EDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Mut. Excl. Component Name EQ DB1.Mut. Excl. Comp
      *   |- c2    : PAR.Mut. Excl. Compnt Seq No EQ DB1.Mut. Excl. Compn
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1MECN        IFEQ      DKMECN                                       *IF
     C     #1MECS        IFEQ      DKMECS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C*****KRSSA         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from EDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * 2nd combination exist ? - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSB01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSB02                         Component Seque
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    WQSB01                         Component Name
     C                   KFLD                    WQSB02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1MECN        WQSB01                         Component Name
     C                   MOVEL     #1MECS        WQSB02                         Component Seque
     C*****KRSSB         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSB         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare FDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1MECN and DKCSEQ = :#1MECS                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close FDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open FDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from FDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Mut. Excl. Component Name EQ DB1.Mut. Excl. Comp
      *   |- c2    : PAR.Mut. Excl. Compnt Seq No EQ DB1.Mut. Excl. Compn
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1COTT        IFEQ      DKMECN                                       *IF
     C     #1CSEQ        IFEQ      DKMECS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C*****KRSSB         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from FDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * 1st combination exist ? - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSC01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSC02                         Component Seque
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    WQSC01                         Component Name
     C                   KFLD                    WQSC02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSC01                         Component Name
     C                   MOVEL     #1CSEQ        WQSC02                         Component Seque
     C*****KRSSC         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSC         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare GDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close GDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open GDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from GDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Mut. Excl. Component Name EQ DB1.Mut. Excl. Comp
      *   |- c2    : PAR.Mut. Excl. Compnt Seq No EQ DB1.Mut. Excl. Compn
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1MECN        IFEQ      DKMECN                                       *IF
     C     #1MECS        IFEQ      DKMECS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C*****KRSSC         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from GDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * 2nd combination exist ? - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSD01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSD02                         Component Seque
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    WQSD01                         Component Name
     C                   KFLD                    WQSD02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1MECN        WQSD01                         Component Name
     C                   MOVEL     #1MECS        WQSD02                         Component Seque
     C*****KRSSD         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSD         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare HDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1MECN and DKCSEQ = :#1MECS                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close HDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open HDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from HDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Mut. Excl. Component Name EQ DB1.Mut. Excl. Comp
      *   |- c2    : PAR.Mut. Excl. Compnt Seq No EQ DB1.Mut. Excl. Compn
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1COTT        IFEQ      DKMECN                                       *IF
     C     #1CSEQ        IFEQ      DKMECS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C*****KRSSD         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from HDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECRRC        BEGSR
      *================================================================
      * Do not create - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DKREGP
     C                   MOVEL     #1COTT        DKCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DKCSEQ                         Component Seque
     C                   MOVEL     #1MEUN        DKMEUN                         Mutually Excl.
     C                   MOVEL     #1MECN        DKMECN                         Mut. Excl. Comp
     C                   MOVEL     #1MECS        DKMECS                         Mut. Excl. Comp
      *
      * USER: Processing before Data update
      * Start of 090416
     C                   GOTO      SEEXIT                                       *QUIT
      * End of 090416
     C     KLCRSE        KLIST
     C                   KFLD                    DKCOTT                         Component Name
     C                   KFLD                    DKCSEQ                         Component Seque
     C                   KFLD                    DKMEUN                         Mutually Excl.
      * Check for duplicate primary key
     C*****KLCRSE        SETLL     @DKREGP                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare IDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ and DKMEUN = :#1MEUN                    MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close IDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open IDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
                                                                                            MD055891
     C                   If        TotRow > 0                                               MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0504'     W0RTN             7
      * Send message 'Mutually Exclusive Com EX'
     C                   MOVEL     'USR0504'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C**********         WRITE     @DKREGP                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,:#1MEUN                                                                           MD055891
     C+  ,:#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBMEXXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DKCOTT                                                                            MD055891
     C+  ,DKCSEQ                                                                            MD055891
     C+  ,DKMEUN                                                                            MD055891
     C+  ,DKMECN                                                                            MD055891
     C+  ,DKMECS                                                                            MD055891
     C+  ,DKMODE                                                                            MD055891
     C+  ,DKLOGD                                                                            MD058986
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+  ,:#1CSEQ                                                                           MD055891
     C+  ,:#1MEUN                                                                           MD055891
     C+  ,:#1MECN                                                                           MD055891
     C+  ,:#1MECS                                                                           MD055891
     C+  ,'B'                                                                               MD055891
     C+  ,'N'                                                                               MD058986
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
     C                   seton                                        91                    MD055891
     C                   else                                                               MD055891
     C                   setoff                                       91                    MD055891
     C                   endif                                                              MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           WUSUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFDLRC        BEGSR
      *================================================================
      * Delete Mutually Exclusive - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * Start of 090416
      * Get unique number - Mutually Exclusive Compnt  *
     C                   EXSR      SGRVGN
      * End of 090416
      * Move key fields to @DKREGP
     C                   MOVEL     #1COTT        DKCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DKCSEQ                         Component Seque
     C                   MOVEL     #1MEUN        DKMEUN                         Mutually Excl.
      *
     C     KLDLSF        KLIST
     C                   KFLD                    DKCOTT                         Component Name
     C                   KFLD                    DKCSEQ                         Component Seque
     C                   KFLD                    DKMEUN                         Mutually Excl.
     C*****KLDLSF        CHAIN     @DKREGP                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBMEXC                                                                        MD055891
     C+ from CBMEXJW0                                                                       MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ and DKMEUN = :#1MEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
                                                                                            MD055891
      * Do not allow deletion of core mutual exclusive                                      MD055891
     C*****DKMODE        IFEQ      'C'                                             MD055891 MD058986
      **Send*message 'Deletion of Core component is not allowed'                   MD055891 MD058986
     C**********         MOVEL     'USR0544'     ZAMSID                            MD055891 MD058986
     C**********         MOVEL     'Y2USRMSG'    ZAMSGF                            MD055891 MD058986
     C**********         EXSR      ZASNMS                                          MD055891 MD058986
     C**********         MOVEL     'USR0544'     W0RTN             7               MD055891 MD058986
     C**********         GOTO      SFEXIT                                       *QUMD055891 MD058986
     C**********         ENDIF                                                  *QUMD055891 MD058986
                                                                                            MD055891
      *
      * Check for changed record
     C                   eval      @1DBRC = CBMEXC                                          MD055891
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSF        SETLL     @DKREGP                            9091      *           MD055891
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @DKREGP                              91      *           MD055891
      * Logical delete is now allowed for both core and bespoke                             MD058986
     C/EXEC SQL                                                                             MD055891
     C**delete*from CBMEXBTD                                                       MD055891 MD058986
     C**where*DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ and DKMEUN = :#1MEUN           MD055891 MD058986
     C*END-EXEC*                                                                   MD055891 MD058986
     C*EXEC*SQL*                                                                   MD055891 MD058986
     C**delete*from CBMEXXTD                                                       MD055891 MD058986
     C+ update      CBMEXXTD  set DKLOGD = 'Y'                                              MD058986
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ and DKMEUN = :#1MEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   else                                                               MD055891
     C                   SETOff                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * Get Mutually Exclusive - Mutually Exclusive Compnt  *
     C                   EXSR      SHRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
     C                   EXSR      SIRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * change for Mut-Exc Flag - Components  *
     C                   EXSR      SJCHRC
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * Get Mutually Exclusive - Mutually Exclusive Compnt  *
     C                   EXSR      SKRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
     C                   EXSR      SLRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * change for Mut-Exc Flag - Components  *
     C                   EXSR      SMCHRC
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   END                                                    *FI
      * Start of 090416
      * Delete Mut. Excl. record - Mutually Exclusive Compnt  *
     C                   EXSR      SNDLRC
      * End of 090416
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGRVGN        BEGSR
      *================================================================
      * Get unique number - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C******LOVAL        SETLL     @DKREGQ                                      *           MD055891
     C**********         READ      @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare JDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close JDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open JDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from JDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
      *  - c1 AND c2
      *   |- c1    : PAR.Mut. Excl. Component Name EQ DB1.Mut. Excl. Comp
      *   |- c2    : PAR.Mut. Excl. Compnt Seq No EQ DB1.Mut. Excl. Compn
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1COTT        IFEQ      DKMECN                                       *IF
     C     #1CSEQ        IFEQ      DKMECS                                       *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   MOVEL     DKMEUN        WUSAVU                         Mutually Excl.
     C                   END                                                    *FI
     C**********         READ      @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from JDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Get Mutually Exclusive - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSH01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSH02                         Component Seque
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    WQSH01                         Component Name
     C                   KFLD                    WQSH02                         Component Seque
      * Move fields to key list
     C                   MOVEL     DKCOTT        WQSH01                         Component Name
     C                   MOVEL     DKCSEQ        WQSH02                         Component Seque
     C*****KRSSH         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSH         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare KDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :WQSH01 and DKCSEQ = :WQSH02                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close KDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open KDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from KDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSH         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from KDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C******LIKE         DEFINE    WAMECN        WQSI01                         Mut. Excl. CMD055891
     C******LIKE         DEFINE    WAMECS        WQSI02                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCOTT        WQSI01                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCSEQ        WQSI02                         Mut. Excl. CMD055891
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    WQSI01                         Mut. Excl. Comp
     C                   KFLD                    WQSI02                         Mut. Excl. Comp
      * Move fields to key list
     C                   MOVEL     DKCOTT        WQSI01                         Mut. Excl. Comp
     C                   MOVEL     DKCSEQ        WQSI02                         Mut. Excl. Comp
     C*****KRSSI         SETLL     @MEXCG8                                      *           MD055891
     C*****KRSSI         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare LDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKMECN = :WQSI01 and DKMECS = :WQSI02                                         MD055891
     C+ order by DKMECN, DKMECS                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close LDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open LDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from LDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSI         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from LDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJCHRC        BEGSR
      *================================================================
      * change for Mut-Exc Flag - Components  *
      *================================================================
      * Clear all neither parameters
     C                   MOVEL     *BLANK        WN0001            1            Component Statu
     C                   Z-ADD     *ZERO         WN0002            1 0          Scheduling Prio
     C                   Z-ADD     *ZERO         WN0003            2 0          Execution Prior
     C                   Z-ADD     *ZERO         WN0004           11 0          Timeslice
     C                   MOVEL     *BLANK        WN0005            1            FCOOB Error Acc
     C                   MOVEL     *BLANK        WN0006           60            Component Text
     C                   MOVEL     *BLANK        WN0007          100            Execution Param
     C                   MOVEL     *BLANK        WN0008            1            Sel for Today's
     C                   MOVEL     *BLANK        WN0009            2            Module
     C                   MOVEL     *BLANK        WN0010            1            Complex Module
     C                   MOVEL     *BLANK        WN0011            1            Restart Flag
     C                   Z-ADD     *ZERO         WN0012            5 0          No.Outstndng De
     C                   MOVEL     *BLANK        WN0013            2            Run Conditions
     C                   Z-ADD     *ZERO         WN0014            5 0          Start Date
     C                   Z-ADD     *ZERO         WN0015            6 0          Start Time
     C                   Z-ADD     *ZERO         WN0016            5 0          End Date
     C                   Z-ADD     *ZERO         WN0017            6 0          End Time
     C                   MOVEL     *BLANK        WN0018            1            Halt Before
     C                   MOVEL     *BLANK        WN0019            1            Halt After
     C                   MOVEL     *BLANK        WN0020            1            Component Faile
     C                   Z-ADD     *ZERO         WN0021            6 0          End of Day Run
     C                   Z-ADD     *ZERO         WN0022            6 0          End of Month Ru
     C                   Z-ADD     *ZERO         WN0023            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0024            6 0          End of Year Run
     C                   Z-ADD     *ZERO         WN0025            6 0          End of Day CPU
     C                   Z-ADD     *ZERO         WN0026            6 0          End of Month CP
     C                   Z-ADD     *ZERO         WN0027            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0028            6 0          End of Year CPU
     C                   MOVEL     *BLANK        WN0029            1            Allow Bypass in
     C                   MOVEL     *BLANK        WN0030            8            COB Stream Name
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     DKCOTT        DHCOTT                         Component Name
     C                   MOVEL     DKCSEQ        DHCSEQ                         Component Seque
     C                   MOVEL     DKCOTT        XXCOTT           10                        MD055891
     C                   MOVEL     DKCSEQ        XXCSEQ            5                        MD055891
      *
     C     KLCHSJ        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLCHSJ        CHAIN     @DHREGG                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :XXCOTT and DHCSEQ = :XXCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SJEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SJEXIT
     C                   END
      *
      * Store record data for null update check
     C                   eval      QCBCM1 = CBCMPN                                          MD055891
     C                   MOVE      QCBCM1        YARDCS
      * Move non-key fields to @DHREGG
     C                   MOVEL     'N'           DHCMEF                         Mut.Exclusive C
     C                   MOVEL     'N'           DHTASK                         Task Split Job
     C                   Z-ADD     *ZERO         DHTSNO                         Number of Task
      *
      * Set PGM.*Record Data Changed flag
     C     QCBCM1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @DHREGG                              91      *           MD055891
      * DHTASK and DHSTNO should not be updated                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCMEF = 'N'                                                                   MD055891
     C+ where DHCOTT = :XXCOTT and DHCSEQ = :XXCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * Get Mutually Exclusive - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSK01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSK02                         Component Seque
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    WQSK01                         Component Name
     C                   KFLD                    WQSK02                         Component Seque
      * Move fields to key list
     C                   MOVEL     DKMECN        WQSK01                         Component Name
     C                   MOVEL     DKMECS        WQSK02                         Component Seque
     C*****KRSSK         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSK         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare MDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :DKMECN and DKCSEQ = :DKMECS                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close MDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open MDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from MDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SKEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSK         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from MDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   SLRVGN        BEGSR
      *================================================================
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C******LIKE         DEFINE    WAMECN        WQSL01                         Mut. Excl. CMD055891
     C******LIKE         DEFINE    WAMECS        WQSL02                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCOTT        WQSL01                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCSEQ        WQSL02                         Mut. Excl. CMD055891
      * Define keylist
     C     KRSSL         KLIST
     C                   KFLD                    WQSL01                         Mut. Excl. Comp
     C                   KFLD                    WQSL02                         Mut. Excl. Comp
      * Move fields to key list
     C                   MOVEL     DKMECN        WQSL01                         Mut. Excl. Comp
     C                   MOVEL     DKMECS        WQSL02                         Mut. Excl. Comp
     C*****KRSSL         SETLL     @MEXCG8                                      *           MD055891
     C*****KRSSL         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare NDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKMECN = :WQSL01 and DKMECS = :WQSL02                                         MD055891
     C+ order by DKMECN, DKMECS                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close NDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open NDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from NDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SLEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSL         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from NDCursor into :CBMEXC                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   ELSE                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *================================================================
     CSR   SLEXIT        ENDSR
      /EJECT
     CSR   SMCHRC        BEGSR
      *================================================================
      * change for Mut-Exc Flag - Components  *
      *================================================================
      * Clear all neither parameters
     C                   MOVEL     *BLANK        WN0031            1            Component Statu
     C                   Z-ADD     *ZERO         WN0032            1 0          Scheduling Prio
     C                   Z-ADD     *ZERO         WN0033            2 0          Execution Prior
     C                   Z-ADD     *ZERO         WN0034           11 0          Timeslice
     C                   MOVEL     *BLANK        WN0035            1            FCOOB Error Acc
     C                   MOVEL     *BLANK        WN0036           60            Component Text
     C                   MOVEL     *BLANK        WN0037          100            Execution Param
     C                   MOVEL     *BLANK        WN0038            1            Sel for Today's
     C                   MOVEL     *BLANK        WN0039            2            Module
     C                   MOVEL     *BLANK        WN0040            1            Complex Module
     C                   MOVEL     *BLANK        WN0041            1            Restart Flag
     C                   Z-ADD     *ZERO         WN0042            5 0          No.Outstndng De
     C                   MOVEL     *BLANK        WN0043            2            Run Conditions
     C                   Z-ADD     *ZERO         WN0044            5 0          Start Date
     C                   Z-ADD     *ZERO         WN0045            6 0          Start Time
     C                   Z-ADD     *ZERO         WN0046            5 0          End Date
     C                   Z-ADD     *ZERO         WN0047            6 0          End Time
     C                   MOVEL     *BLANK        WN0048            1            Halt Before
     C                   MOVEL     *BLANK        WN0049            1            Halt After
     C                   MOVEL     *BLANK        WN0050            1            Component Faile
     C                   Z-ADD     *ZERO         WN0051            6 0          End of Day Run
     C                   Z-ADD     *ZERO         WN0052            6 0          End of Month Ru
     C                   Z-ADD     *ZERO         WN0053            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0054            6 0          End of Year Run
     C                   Z-ADD     *ZERO         WN0055            6 0          End of Day CPU
     C                   Z-ADD     *ZERO         WN0056            6 0          End of Month CP
     C                   Z-ADD     *ZERO         WN0057            6 0          Begin of Month
     C                   Z-ADD     *ZERO         WN0058            6 0          End of Year CPU
     C                   MOVEL     *BLANK        WN0059            1            Allow Bypass in
     C                   MOVEL     *BLANK        WN0060            8            COB Stream Name
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     DKMECN        DHCOTT                         Component Name
     C                   MOVEL     DKMECS        DHCSEQ                         Component Seque
     C                   MOVEL     DKMECN        XXMECN           10                        MD055891
     C                   MOVEL     DKMECS        XXMECS            5                        MD055891
      *
     C     KLCHSM        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLCHSM        CHAIN     @DHREGG                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :DHCOTT and DHCSEQ = :DHCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SMEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SMEXIT
     C                   END
      *
      * Store record data for null update check
     C                   eval      QCBCM1 = CBCMPN                                          MD055891
     C                   MOVE      QCBCM1        YBRDCS
      * Move non-key fields to @DHREGG
     C                   MOVEL     'N'           DHCMEF                         Mut.Exclusive C
     C                   MOVEL     'N'           DHTASK                         Task Split Job
     C                   Z-ADD     *ZERO         DHTSNO                         Number of Task
      *
      * Set PGM.*Record Data Changed flag
     C     QCBCM1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C**********         UPDATE    @DHREGG                              91      *           MD055891
      * DHTASK and DHSTNO should not be updated                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCMEF = 'N'                                                                   MD055891
     C+ where DHCOTT = :DHCOTT and DHCSEQ = :DHCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SMEXIT        ENDSR
      /EJECT
     CSR   SNDLRC        BEGSR
      *================================================================
      * Delete Mut. Excl. record - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @DKREGP
     C                   MOVEL     #1MECN        DKCOTT                         Component Name
     C                   MOVEL     #1MECS        DKCSEQ                         Component Seque
     C                   MOVEL     WUSAVU        DKMEUN                         Mutually Excl.
      *
     C     KLDLSN        KLIST
     C                   KFLD                    DKCOTT                         Component Name
     C                   KFLD                    DKCSEQ                         Component Seque
     C                   KFLD                    DKMEUN                         Mutually Excl.
     C*****KLDLSN        CHAIN     @DKREGP                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBMEXC                                                                        MD055891
     C+ from CBMEXJW0                                                                       MD055891
     C+ where DKCOTT = :#1MECN and DKCSEQ = :#1MECS and DKMEUN = :WUSAVU                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SNEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SNEXIT
     C                   END
      *
      *................................................................
     C**********         DELETE    @DKREGP                              91      *           MD055891
      * Logical delete is now allowed for both core and bespoke                             MD058986
     C/EXEC SQL                                                                             MD055891
     C**delete*from CBMEXBTD                                                       MD055891 MD058986
     C**where*DKCOTT = :#1MECN and DKCSEQ = :#1MECS and DKMEUN = :WUSAVU           MD055891 MD058986
     C*END-EXEC*                                                                   MD055891 MD058986
     C*EXEC*SQL*                                                                   MD055891 MD058986
     C**delete*from CBMEXXTD                                                       MD055891 MD058986
     C+ update      CBMEXXTD  set DKLOGD = 'Y'                                              MD058986
     C+ where DKCOTT = :#1MECN and DKCSEQ = :#1MECS and DKMEUN = :WUSAVU                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       91                    MD055891
     C                   If        SQLCODE <> 0                                             MD055891
     C                   SETON                                        91                    MD055891
     C                   else                                                               MD055891
     C                   SETOff                                       91                    MD055891
     C                   ENDIF                                                              MD055891
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SNEXIT        ENDSR
      /EJECT
     CSR   SOCHRC        BEGSR
      *================================================================
      * Change Mutually Exclusive - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @DKREGP
     C                   MOVEL     #1COTT        DKCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DKCSEQ                         Component Seque
     C                   MOVEL     #1MEUN        DKMEUN                         Mutually Excl.
      *
     C     KLCHSO        KLIST
     C                   KFLD                    DKCOTT                         Component Name
     C                   KFLD                    DKCSEQ                         Component Seque
     C                   KFLD                    DKMEUN                         Mutually Excl.
     C*****KLCHSO        CHAIN     @DKREGP                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBMEXC                                                                        MD055891
     C+ from CBMEXJW0                                                                       MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ and DKMEUN = :#1MEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SOEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SOEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    CBMEXCL0                             91      *           MD055891
     C                   GOTO      SOEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   eval      @1DBRC = CBMEXC                                          MD055891
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @DKREGP
     C                   MOVEL     #1MECN        DKMECN                         Mut. Excl. Comp
     C                   MOVEL     #1MECS        DKMECS                         Mut. Excl. Comp
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C**********         UPDATE    @DKREGP                              91      *           MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBMEXCL0                             91      *           MD055891
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
      * Start of S01417
      * Move 'Y' into parameter if DBF update complete
     C                   MOVEL     'Y'           P1SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SOEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Components
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1COTT        WK1X01            1
     C                   MOVEL     #1CSEQ        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     C                   CALL      'CB0402S'                            90      Sel Mutually Ex
     C                   PARM      *BLANK        W0RTN             7
     C     #1COTT        PARM      #1COTT        WQ0001           10            Component Name
     C     #1CSEQ        PARM      #1CSEQ        WQ0002            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0402S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        983435    *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VAEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1COTT        IFEQ      *BLANK                                       Component Name
     C     #1CSEQ        ANDEQ     *BLANK                                       Component Seque
     C                   GOTO      VAEXIT
     C                   END
      *
     C     KLVADH        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
     C*****KLVADH        CHAIN     @CMPNGY                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C+ and DHCMEF = 'Y'                                                                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   Else                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ELSE                                                               MD055891
     C                   SETOFF                                       91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Components           NF'
     C                   MOVEL     'USR0497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR0497'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to Components
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1MECN        WK1X01            1
     C                   MOVEL     #1MECS        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     C                   CALL      'CB0402S'                            90      Sel Mutually Ex
     C                   PARM      *BLANK        W0RTN             7
     C     #1MECN        PARM      #1MECN        WQ0003           10            Component Name
     C     #1MECS        PARM      #1MECS        WQ0004            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0402S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        983637    *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VBEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1MECN        IFEQ      *BLANK                                       Component Name
     C     #1MECS        ANDEQ     *BLANK                                       Component Seque
     C                   GOTO      VBEXIT
     C                   END
      *
     C     KLVBDH        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1MECN        DHCOTT                         Component Name
     C                   MOVEL     #1MECS        DHCSEQ                         Component Seque
     C*****KLVBDH        CHAIN     @CMPNGY                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1MECN and DHCSEQ = :#1MECS                                         MD055891
     C+ and DHCMEF = 'Y'                                                                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'Components           NF'
     C                   MOVEL     'USR0497'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR0497'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
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
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
      *
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
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUJ8ST            1
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Mut exc unique no numeric
     C                   Z-ADD     *ZERO         WUMEXN            2 0
      * Define work field Mutually Excl. Unique No
     C                   MOVEL     *BLANK        WUMEUN            2
      * Define work field Mut. exc. uniq no numeric
     C                   Z-ADD     *ZERO         WUMENN            2 0
      * Define work field Mut. excl. unique No.
     C                   MOVEL     *BLANK        WUWMEN            2
      * Define work field Successful Update Made
     C                   MOVEL     *BLANK        WUSUPD            1
      * Define work field Saved unique number
     C                   MOVEL     *BLANK        WUSAVU            2
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   OPEN      CB0430M#
     C**********         OPEN      CBMEXCL1                                                 MD055891
     C**********         OPEN      CBCMPNL3                                                 MD055891
     C**********         OPEN      CBMEXCL2                                                 MD055891
     C**********         OPEN      CBMEXCL0                                                 MD055891
     C**********         OPEN      CBCMPNL0                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     12            ##SFPG            3 0          SFLPAG
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
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of S01459
      * CB0430M precompiler - Mutually Exclusive Compnt  *
      * End of S01459
      * Copyright Statement 1988 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,CB0430MPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0430MPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0430MPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
