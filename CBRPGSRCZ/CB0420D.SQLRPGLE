     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Module conditions enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0420D -  Complex Module Conditions Enquiry Subfile         *
      *                                                               *
      *  Function:  This program allows the user to enquire on        *
      *             the module conditions data.                       *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 S01459             Date 12Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *                                                               *
      *****************************************************************
     FCB0420D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB Complex module conditions enquiry subfile
      *
     F*CBMDCNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Module Conditions         Retrieval index
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
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
      * Outward parameters
     D PARC            DS            17
      * KEY : Module Conditions         Retrieval index
      * I : MAP Component Name
     D  PACOTT                 1     10
      * I : MAP Component Sequence Number
     D  PACSEQ                11     15
      * I : MAP Module Conds Unique No
     D  PAMCUN                16     17
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D CBMDCN        E DS                  EXTNAME(CBMDCJW0)                                MD055891
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
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
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    DJCOTT                         Component Name
     C                   KFLD                    DJCSEQ                         Component Seque
     C                   KFLD                    DJMCUN                         Module Conds Un
      * Setup key
     C                   MOVEL     #2COTT        DJCOTT                         Component Name
     C                   MOVEL     #2CSEQ        DJCSEQ                         Component Seque
     C                   MOVEL     #2MCUN        DJMCUN                         Module Conds Un
     C*****KPOS*         SETLL     @DJREGN                                                  MD055891
     C**********         READ      @DJREGN                              8782    *82=EOF     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT >= :DJCOTT and DJCSEQ >= :DJCSEQ                                       MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
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
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   SETOFF                                       82                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        82                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
      * Save previous selector values
     C     *LIKE         DEFINE    #2MD01        WZMD01
     C                   MOVEL     #2MD01        WZMD01                         Module 01
     C     *LIKE         DEFINE    #2MP01        WZMP01
     C                   MOVEL     #2MP01        WZMP01                         Module be/not b
     C     *LIKE         DEFINE    #2MD02        WZMD02
     C                   MOVEL     #2MD02        WZMD02                         Module 02
     C     *LIKE         DEFINE    #2MP02        WZMP02
     C                   MOVEL     #2MP02        WZMP02                         Mod 02 be/not b
     C     *LIKE         DEFINE    #2MD03        WZMD03
     C                   MOVEL     #2MD03        WZMD03                         Module 03
     C     *LIKE         DEFINE    #2MP03        WZMP03
     C                   MOVEL     #2MP03        WZMP03                         Mod 03 be/not b
     C     *LIKE         DEFINE    #2MD04        WZMD04
     C                   MOVEL     #2MD04        WZMD04                         Module 04
     C     *LIKE         DEFINE    #2MP04        WZMP04
     C                   MOVEL     #2MP04        WZMP04                         Mod 04 be/not b
     C     *LIKE         DEFINE    #2MD05        WZMD05
     C                   MOVEL     #2MD05        WZMD05                         Module 05
     C     *LIKE         DEFINE    #2MP05        WZMP05
     C                   MOVEL     #2MP05        WZMP05                         Mod 05 be/not b
     C     *LIKE         DEFINE    #2MD06        WZMD06
     C                   MOVEL     #2MD06        WZMD06                         Module 06
     C     *LIKE         DEFINE    #2MP06        WZMP06
     C                   MOVEL     #2MP06        WZMP06                         Mod 06 be/not b
     C     *LIKE         DEFINE    #2MD07        WZMD07
     C                   MOVEL     #2MD07        WZMD07                         Module 07
     C     *LIKE         DEFINE    #2MP07        WZMP07
     C                   MOVEL     #2MP07        WZMP07                         Mod 07 be/not b
     C     *LIKE         DEFINE    #2MD08        WZMD08
     C                   MOVEL     #2MD08        WZMD08                         Module 08
     C     *LIKE         DEFINE    #2MP08        WZMP08
     C                   MOVEL     #2MP08        WZMP08                         Mod 08 be/not b
     C     *LIKE         DEFINE    #2MD09        WZMD09
     C                   MOVEL     #2MD09        WZMD09                         Module 09
     C     *LIKE         DEFINE    #2MP09        WZMP09
     C                   MOVEL     #2MP09        WZMP09                         Mod 09 be/not b
     C     *LIKE         DEFINE    #2MD10        WZMD10
     C                   MOVEL     #2MD10        WZMD10                         Module 10
     C     *LIKE         DEFINE    #2MP10        WZMP10
     C                   MOVEL     #2MP10        WZMP10                         Mod 10 be/not b
     C     *LIKE         DEFINE    #2COTT        WZCOTT
     C                   MOVEL     #2COTT        WZCOTT                         Component Name
     C     *LIKE         DEFINE    #2CSEQ        WZCSEQ
     C                   MOVEL     #2CSEQ        WZCSEQ                         Component Seque
     C     *LIKE         DEFINE    #2MCUN        WZMCUN
     C                   MOVEL     #2MCUN        WZMCUN                         Module Conds Un
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
     C**N82*****         READP     @DJREGN                                90    *           MD055891
     C**N82*****         READ      @DJREGN                                90    *           MD055891
     C     *IN82         IFEQ      '0'                                                      MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch prior from ACursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(34)
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
     C******IN82         DOWEQ     '0'                                          DO          MD055891
     C     SQLCODE       DOWEQ     0                                            DO          MD055891
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2MD01        IFNE      *BLANK                                       Module 01
     C     DJMD01        CABNE     #2MD01        BB020                          Module 01
     C                   END
     C     #2MP01        IFNE      *BLANK                                       Module be/not b
     C     DJMP01        CABNE     #2MP01        BB020                          Module be/not b
     C                   END
     C     #2MD02        IFNE      *BLANK                                       Module 02
     C     DJMD02        CABNE     #2MD02        BB020                          Module 02
     C                   END
     C     #2MP02        IFNE      *BLANK                                       Mod 02 be/not b
     C     DJMP02        CABNE     #2MP02        BB020                          Mod 02 be/not b
     C                   END
     C     #2MD03        IFNE      *BLANK                                       Module 03
     C     DJMD03        CABNE     #2MD03        BB020                          Module 03
     C                   END
     C     #2MP03        IFNE      *BLANK                                       Mod 03 be/not b
     C     DJMP03        CABNE     #2MP03        BB020                          Mod 03 be/not b
     C                   END
     C     #2MD04        IFNE      *BLANK                                       Module 04
     C     DJMD04        CABNE     #2MD04        BB020                          Module 04
     C                   END
     C     #2MP04        IFNE      *BLANK                                       Mod 04 be/not b
     C     DJMP04        CABNE     #2MP04        BB020                          Mod 04 be/not b
     C                   END
     C     #2MD05        IFNE      *BLANK                                       Module 05
     C     DJMD05        CABNE     #2MD05        BB020                          Module 05
     C                   END
     C     #2MP05        IFNE      *BLANK                                       Mod 05 be/not b
     C     DJMP05        CABNE     #2MP05        BB020                          Mod 05 be/not b
     C                   END
     C     #2MD06        IFNE      *BLANK                                       Module 06
     C     DJMD06        CABNE     #2MD06        BB020                          Module 06
     C                   END
     C     #2MP06        IFNE      *BLANK                                       Mod 06 be/not b
     C     DJMP06        CABNE     #2MP06        BB020                          Mod 06 be/not b
     C                   END
     C     #2MD07        IFNE      *BLANK                                       Module 07
     C     DJMD07        CABNE     #2MD07        BB020                          Module 07
     C                   END
     C     #2MP07        IFNE      *BLANK                                       Mod 07 be/not b
     C     DJMP07        CABNE     #2MP07        BB020                          Mod 07 be/not b
     C                   END
     C     #2MD08        IFNE      *BLANK                                       Module 08
     C     DJMD08        CABNE     #2MD08        BB020                          Module 08
     C                   END
     C     #2MP08        IFNE      *BLANK                                       Mod 08 be/not b
     C     DJMP08        CABNE     #2MP08        BB020                          Mod 08 be/not b
     C                   END
     C     #2MD09        IFNE      *BLANK                                       Module 09
     C     DJMD09        CABNE     #2MD09        BB020                          Module 09
     C                   END
     C     #2MP09        IFNE      *BLANK                                       Mod 09 be/not b
     C     DJMP09        CABNE     #2MP09        BB020                          Mod 09 be/not b
     C                   END
     C     #2MD10        IFNE      *BLANK                                       Module 10
     C     DJMD10        CABNE     #2MD10        BB020                          Module 10
     C                   END
     C     #2MP10        IFNE      *BLANK                                       Mod 10 be/not b
     C     DJMP10        CABNE     #2MP10        BB020                          Mod 10 be/not b
     C                   END
     C     #2COTT        IFEQ      *BLANK                                       Component Name
     C     #2CSEQ        IFNE      *BLANK                                       Component Seque
     C     DJCSEQ        CABNE     #2CSEQ        BB020                          Component Seque
     C                   END
     C                   END
     C     #2COTT        IFEQ      *BLANK                                       Component Name
     C     #2CSEQ        OREQ      *BLANK                                       Component Seque
     C     #2MCUN        IFNE      *BLANK                                       Module Conds Un
     C     DJMCUN        CABNE     #2MCUN        BB020                          Module Conds Un
     C                   END
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
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
     C***********        READ      @DJREGN                                82    *82=EOF     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
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
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
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
     C                   SETOFF                                         8392    *
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
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Change of position specified
     C     WZCOTT        CASNE     #2COTT        FBRQRL
     C     WZCSEQ        CASNE     #2CSEQ        FBRQRL
     C     WZMCUN        CASNE     #2MCUN        FBRQRL
     C                   END
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process subfile record
     C                   EXSR      DCPRSR
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
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(34)
     C                   SETOFF                                       98        *
      * USER: Process subfile record (Pre-confirm)
      * CASE: RCD.*SFLSEL is *Enquire
     C     #1SEL         IFEQ      'E'                                          *IF
      * Display Mod Cons Record - Module Conditions  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1COTT        PACOTT                         Component Name
     C                   MOVEL     #1CSEQ        PACSEQ                         Component Seque
     C                   MOVEL     #1MCUN        PAMCUN                         Module Conds Un
      *
     C                   CALL      'CB0420E'                            90      Display Mod Con
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: Module Con
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0420E'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
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
      * Move @DJREGN fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     DJMD01        #1MD01                         Module 01
     C                   MOVEL     DJMP01        #1MP01                         Module be/not b
     C                   MOVEL     DJMD02        #1MD02                         Module 02
     C                   MOVEL     DJMP02        #1MP02                         Mod 02 be/not b
     C                   MOVEL     DJMD03        #1MD03                         Module 03
     C                   MOVEL     DJMP03        #1MP03                         Mod 03 be/not b
     C                   MOVEL     DJMD04        #1MD04                         Module 04
     C                   MOVEL     DJMP04        #1MP04                         Mod 04 be/not b
     C                   MOVEL     DJMD05        #1MD05                         Module 05
     C                   MOVEL     DJMP05        #1MP05                         Mod 05 be/not b
     C                   MOVEL     DJMD06        #1MD06                         Module 06
     C                   MOVEL     DJMP06        #1MP06                         Mod 06 be/not b
     C                   MOVEL     DJMD07        #1MD07                         Module 07
     C                   MOVEL     DJMP07        #1MP07                         Mod 07 be/not b
     C                   MOVEL     DJMD08        #1MD08                         Module 08
     C                   MOVEL     DJMP08        #1MP08                         Mod 08 be/not b
     C                   MOVEL     DJMD09        #1MD09                         Module 09
     C                   MOVEL     DJMP09        #1MP09                         Mod 09 be/not b
     C                   MOVEL     DJMD10        #1MD10                         Module 10
     C                   MOVEL     DJMP10        #1MP10                         Mod 10 be/not b
     C                   MOVEL     DJCOTT        #1COTT                         Component Name
     C                   MOVEL     DJCSEQ        #1CSEQ                         Component Seque
     C                   MOVEL     DJMCUN        #1MCUN                         Module Conds Un
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2MD01                         Module 01
     C                   MOVEL     *BLANK        #2MP01                         Module be/not b
     C                   MOVEL     *BLANK        #2MD02                         Module 02
     C                   MOVEL     *BLANK        #2MP02                         Mod 02 be/not b
     C                   MOVEL     *BLANK        #2MD03                         Module 03
     C                   MOVEL     *BLANK        #2MP03                         Mod 03 be/not b
     C                   MOVEL     *BLANK        #2MD04                         Module 04
     C                   MOVEL     *BLANK        #2MP04                         Mod 04 be/not b
     C                   MOVEL     *BLANK        #2MD05                         Module 05
     C                   MOVEL     *BLANK        #2MP05                         Mod 05 be/not b
     C                   MOVEL     *BLANK        #2MD06                         Module 06
     C                   MOVEL     *BLANK        #2MP06                         Mod 06 be/not b
     C                   MOVEL     *BLANK        #2MD07                         Module 07
     C                   MOVEL     *BLANK        #2MP07                         Mod 07 be/not b
     C                   MOVEL     *BLANK        #2MD08                         Module 08
     C                   MOVEL     *BLANK        #2MP08                         Mod 08 be/not b
     C                   MOVEL     *BLANK        #2MD09                         Module 09
     C                   MOVEL     *BLANK        #2MP09                         Mod 09 be/not b
     C                   MOVEL     *BLANK        #2MD10                         Module 10
     C                   MOVEL     *BLANK        #2MP10                         Mod 10 be/not b
     C                   MOVEL     *BLANK        #2COTT                         Component Name
     C                   MOVEL     *BLANK        #2CSEQ                         Component Seque
     C                   MOVEL     *BLANK        #2MCUN                         Module Conds Un
      *================================================================
     CSR   MEEXIT        ENDSR
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
      * Cancel & exit program
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
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
     C                   OPEN      CB0420D#
     C**********         OPEN      CBMDCNL1                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
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
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * CB0420D Precompiler - Module Conditions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Copyright Statement 1988 - Standard functions  *
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
     C/COPY WNCPYSRC,CB0420DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0420DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0420DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
