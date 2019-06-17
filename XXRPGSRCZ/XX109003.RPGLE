      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD G-AML Activity Type Maintenance Program')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ108*-*Midas SD G-AML Activity Type Maintenance Program*****
      *  XX109003 - Midas SD G-AML Activity Type Maintenance Program  *
      *                                                               *
      *  Function:  This program allows the user to maintain the      *
      *             Activity Types File.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109            Date 21May18                *
      *  Prev Amend No. JMI026  *CREATE   Date 17Sep08                *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  JMI109 - Extract for G-AML Interface.(Upgrade to FB Midas)   *
      *  JMI026 - Extract for G-AML Interface.                        *
      *                                                               *
      *****************************************************************
     F*SDJ108#   CF   E             WORKSTN USROPN                                            JMI109
     FXX109003# CF   E             WORKSTN USROPN                                             JMI109
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD G-AML Activity Type Display File
      *
     F*SDATYPY0  IF   E           K DISK    USROPN                                            JMI109
     FXXATYPL0  IF   E           K DISK    USROPN                                             JMI109
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
     F*SDATYPY2  IF   E           K DISK    USROPN                                            JMI109
     FXXATYPL2  IF   E           K DISK    USROPN                                             JMI109
     F                                     INFSR(*PSSR)
     F*SDATYPY3  IF   E           K DISK    USROPN                                            JMI109
     FXXATYPL3  IF   E           K DISK    USROPN                                             JMI109
     F                                     INFSR(*PSSR)
     F*SDATYPY4  IF   E           K DISK    USROPN                                            JMI109
     FXXATYPL4  IF   E           K DISK    USROPN                                             JMI109
     F                                     INFSR(*PSSR)
     F*SDATYPY5  IF   E           K DISK    USROPN                                            JMI109
     FXXATYPL5  IF   E           K DISK    USROPN                                             JMI109
     F                                     INFSR(*PSSR)
      * Midas SD Activity Type LF
      *
     F*SDATYPY1  UF A E           K DISK    USROPN                                            JMI109
     FXXATYPL1  UF A E           K DISK    USROPN                                             JMI109
     F                                     COMMIT
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * Midas SD Activity Type LF
      *
     FFDDTSTL1  IF   E           K DISK
      * Midas FD Deal type/subtype file
      *
     FGLJENHL0  IF   E           K DISK
      * Midas GL Journal entry header update file
      *
     D********************************************************************
     D*
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC********E DS                  EXTNAME(SDATYPY0)                                  JMI109
     D @1DBRC        E DS                  EXTNAME(XXATYPL0)                                  JMI109
      * UPD : Activity Type             Update index
      * Current/previous master file format fields for change control
      *
     D YCRDCS          DS            37
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D WUDSTT          DS
     D  WUPOS1                 1      2
     D ID0001          DS           528
      * File information data structure
     D                 DS
     D  ZAMSDA                 1    132
     D  ZA0001                 1      2
     D  ZA0002                 1     10
     D  ZA0003                 1      1
     D  ZA0004                 2     11
     D  ZA0005                 1      2
     D  ZA0006                 1      2
     D  ZA0007                 1      2
     D  ZA0008                 1     30
     D  ZA0009                 1      1
     D  ZA0010                 1     10
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
     C                   MOVEL     'N'           WUDELA                         Deletion Allowed
      * CASE: WRK.Set Up Complete is No
     C     WUSUC         IFEQ      'N'
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'
     C                   MOVEL     'Y'           WUDELA                         Deletion Allowed
     C                   END
     C                   END
      * Set up Edit File Footer - Standard Functions  *
     C*****************************************************************
     C*
     C*  Sets up the function key footer text for edit files in which
     C*  records may not be deleted after the system set up flag has
     C*  been set on
     C*
     C*****************************************************************
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C     'GB'          CAT       'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If program mode is ADD:
     C*
     C     W0PMD         IFEQ      'ADD'
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
     C                   MOVEL     'USR3349'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C*
     C*  If set up is not complete:
     C*
     C     WUSUC         IFEQ      'N'
     C* Setup footer text:
     C* D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'USR3348'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
     C* Setup footer text:
     C* F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
     C                   MOVEL     'USR3354'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   END
      *................................................................
      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    @GMOD         WZMOD
     C                   MOVEL     @GMOD         WZMOD
     C     *LIKE         DEFINE    @GTYP         WZTYP
     C                   MOVEL     @GTYP         WZTYP
     C     *LIKE         DEFINE    @GSTYP        WZSTYP
     C                   MOVEL     @GSTYP        WZSTYP
     C     *LIKE         DEFINE    @GSRNG        WZSRNG
     C                   MOVEL     @GSRNG        WZSRNG
     C     *LIKE         DEFINE    @GERNG        WZERNG
     C                   MOVEL     @GERNG        WZERNG
      *
     C     KPOS          KLIST
     C                   KFLD                    GMOD
     C                   KFLD                    GTYP
     C                   KFLD                    GSTYP
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
      *
     C     KPOS2         KLIST
     C                   KFLD                    GTYP
     C                   KFLD                    GSTYP
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
      *
     C     KPOS3         KLIST
     C                   KFLD                    GSTYP
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
      *
     C     KPOS4         KLIST
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
      *
     C     KPOS5         KLIST
     C                   KFLD                    GERNG
      * Setup key
     C                   MOVEL     @GMOD         GMOD
     C                   MOVEL     @GTYP         GTYP
     C                   MOVEL     @GSTYP        GSTYP
     C                   MOVEL     @GSRNG        GSRNG
     C                   MOVEL     @GERNG        GERNG
      *
      ** Sort the subfile depending on the entered selection fields
     C                   SELECT
     C     @GMOD         WHENNE    *BLANKS
     C     @GMOD         OREQ      *BLANKS
     C     @GTYP         ANDEQ     *BLANKS
     C     @GSTYP        ANDEQ     *BLANKS
     C     @GSRNG        ANDEQ     0
     C     @GERNG        ANDEQ     0
      * 82=EOF
     C     KPOS          SETLL     @ATYPY0                            82
      * 82=EOF
     C  N82              READ      @ATYPY0                              9182
      *
     C     @GTYP         WHENNE    *BLANKS
     C     KPOS2         SETLL     @ATYPY2                            82
      * 82=EOF
     C  N82              READ      @ATYPY2                              9182
      *
     C     @GSTYP        WHENNE    *BLANKS
     C     KPOS3         SETLL     @ATYPY3                            82
      * 82=EOF
     C  N82              READ      @ATYPY3                              9182
      *
     C     @GSRNG        WHENNE    0
     C     KPOS4         SETLL     @ATYPY4                            82
      * 82=EOF
     C  N82              READ      @ATYPY4                              9182
      *
     C     @GERNG        WHENNE    0
     C     KPOS5         SETLL     @ATYPY5                            82
      * 82=EOF
     C  N82              READ      @ATYPY5                              9182
      *
     C                   OTHER
     C                   SETOFF                                       82
     C                   ENDSL
      *
     C                   ENDIF
      * Load subfile page
     C                   EXSR      BBLDSF
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO
     C     W0PMD         ANDEQ     'CHG'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
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
     C                   SELECT
     C     @GMOD         WHENNE    *BLANKS
     C     @GMOD         OREQ      *BLANKS
     C     @GTYP         ANDEQ     *BLANKS
     C     @GSTYP        ANDEQ     *BLANKS
     C     @GSRNG        ANDEQ     0
     C     @GERNG        ANDEQ     0
     C  N82              READP     @ATYPY0                                90
     C  N82              READ      @ATYPY0                                90
      *
     C     @GTYP         WHENNE    *BLANKS
     C  N82              READP     @ATYPY2                                90
     C  N82              READ      @ATYPY2                                90
      *
     C     @GSTYP        WHENNE    *BLANKS
     C  N82              READP     @ATYPY3                                90
     C  N82              READ      @ATYPY3                                90
      *
     C     @GSRNG        WHENNE    0
     C  N82              READP     @ATYPY4                                90
     C  N82              READ      @ATYPY4                                90
      *
     C     @GERNG        WHENNE    0
     C  N82              READP     @ATYPY5                                90
     C  N82              READ      @ATYPY5                                90
     C                   ENDSL
     C                   ENDIF
      *
      * Setof record error indicators
     C                   MOVE      *ALL'0'       WKIND0            8
     C                   MOVE      *ALL'1'       WKIND1            7
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
     C     ##RROK        DOWLT     ##SFLN                                       DO
     C     *IN82         ANDEQ     *OFF
     C     ##RROK        ORLT      ##SFLN
     C     W0PMD         ANDEQ     'ADD'
     C     *IN82         ANDEQ     *ON
     C                   ADD       1             ##RR
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       87
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * If CHANGE mode, load subfile fields
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
     C                   END
      * Output to subfile
     C                   ADD       1             ##RROK               81
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     W0PMD         IFNE      'ADD'
      * 82=EOF
     C                   SELECT
     C     @GMOD         WHENNE    *BLANKS
     C     @GMOD         OREQ      *BLANKS
     C     @GTYP         ANDEQ     *BLANKS
     C     @GSTYP        ANDEQ     *BLANKS
     C     @GSRNG        ANDEQ     0
     C     @GERNG        ANDEQ     0
     C                   READ      @ATYPY0                                82
      *
     C     @GTYP         WHENNE    *BLANKS
     C                   READ      @ATYPY2                                82
      *
     C     @GSTYP        WHENNE    *BLANKS
     C                   READ      @ATYPY3                                82
      *
     C     @GSRNG        WHENNE    0
     C                   READ      @ATYPY4                                82
      *
     C     @GERNG        WHENNE    0
     C                   READ      @ATYPY5                                82
     C                   ENDSL
     C                   ENDIF
     C                   ENDDO
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
     C                   SETOFF                                       94
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
     C                   MOVEL     'Y'           ZAFSMS            1      99
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
     C     W0PMD         IFNE      'ADD'
      * Change of position specified
     C     WZMOD         CASNE     @GMOD         FBRQRL
     C     WZTYP         CASNE     @GTYP         FBRQRL
     C     WZSTYP        CASNE     @GSTYP        FBRQRL
     C     WZSRNG        CASNE     @GSRNG        FBRQRL
     C     WZERNG        CASNE     @GERNG        FBRQRL
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
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(32)
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
     CANN99              Z-ADD     ##RR          ##SFRC               99
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #GMOD         CABNE     *BLANK        DDEXIT
     C     #GTYP         CABNE     *BLANK        DDEXIT
     C     #GSTYP        CABNE     *BLANK        DDEXIT
     C     #GSRNG        CABNE     *BLANK        DDEXIT
     C     #GERNG        CABNE     *BLANK        DDEXIT
     C     #GASEQ        CABNE     *BLANK        DDEXIT
     C     #GATYP        CABNE     *BLANK        DDEXIT
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      *
      * Midas Module should not be blanks.
     C     #GMOD         IFEQ      *BLANKS
     C                   SETON                                        9833
     C                   MOVEL     'XXX1156'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * Midas Module should be equal to CE, TT, FT, and GL only.
     C     #GMOD         IFNE      *BLANKS
     C     #GMOD         ANDNE     'CE'
     C     #GMOD         ANDNE     'TT'
     C     #GMOD         ANDNE     'FT'
     C     #GMOD         ANDNE     'GL'
     C                   SETON                                        9833
     C                   MOVEL     'XXX1157'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * Midas Transaction Type should be blank if Midas Module is not FT.
     C     #GMOD         IFNE      *BLANKS
     C     #GMOD         IFNE      'FT'
     C     #GTYP         ANDNE     *BLANKS
     C                   SETON                                        9834
     C                   MOVEL     'XXX1158'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GTYP         ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      * Midas Transaction Type should be equal to IP, OP, CP and CC
      * for FT module.
     C     #GMOD         IFEQ      'FT'
     C     #GTYP         ANDNE     'IN'
     C     #GTYP         ANDNE     'OP'
     C     #GTYP         ANDNE     'CP'
     C     #GTYP         ANDNE     'CC'
     C     #GTYP         ANDNE     *BLANKS
     C                   SETON                                        9834
     C                   MOVEL     'XXX1160'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GTYP         ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * Midas Subtype should be blank if Midas Module is not FT.
     C     #GMOD         IFNE      *BLANKS
     C     #GMOD         IFNE      'FT'
     C     #GSTYP        ANDNE     *BLANKS
     C                   SETON                                        9835
     C                   MOVEL     'XXX1161'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GTYP         ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      * Midas Type should be enter if subtype is entered.
     C     #GMOD         IFNE      *BLANKS
     C     #GMOD         IFEQ      'FT'
     C     #GSTYP        ANDNE     *BLANKS
     C     #GTYP         ANDEQ     *BLANKS
     C                   SETON                                        9835
     C                   MOVEL     'XXX1162'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GTYP         ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      * Deal Type/Subtype should be checked only if the subtype is not
      * blank and module is equal to FT.
     C     #GMOD         IFEQ      'FT'
     C     #GTYP         ANDNE     *BLANKS
     C     #GSTYP        ANDNE     *BLANKS
     C                   MOVEL     #GTYP         KTYP              2
     C                   MOVEL     #GSTYP        KSTYP             2
      *
     C     KDTST         KLIST
     C                   KFLD                    KTYP
     C                   KFLD                    KSTYP
      *
     C     KDTST         CHAIN     FDDTSTPD                           55
      ** Record not found
     C     *IN55         IFEQ      '1'
     C                   SETON                                        9835
     C                   MOVEL     'XXX1162'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GTYP         ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      * Start and End Range Batch Number validation.
      **  Batch numbers should be blank for non-GL module.
     C     #GMOD         IFNE      *BLANKS
     C     #GMOD         ANDNE     'GL'
     C     #GSRNG        ANDNE     *BLANKS
     C                   SETON                                        9836
     C                   MOVEL     'XXX1163'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     #GMOD         IFNE      *BLANKS
     C     #GMOD         ANDNE     'GL'
     C     #GERNG        ANDNE     *BLANKS
     C                   SETON                                        9837
     C                   MOVEL     'XXX1163'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      **  Batch numbers should not be blank for GL module.
     C     #GMOD         IFEQ      'GL'
     C     #GSRNG        IFEQ      *BLANKS
     C                   SETON                                        9836
     C                   MOVEL     'XXX1164'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     #GERNG        IFEQ      *BLANKS
     C                   SETON                                        9837
     C                   MOVEL     'XXX1165'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      **  Batch numbers must be numeric.
     C     #GSRNG        IFNE      *BLANKS
     C                   SETOFF                                       40
     C                   MOVEL     *BLANKS       PFLDIN
     C                   MOVE      #GSRNG        PFLDIN
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRTN              7
     C                   PARM                    PFLDIN           16
     C                   PARM      0             PDEC              1 0
     C                   PARM      3             PDIGIT            2 0
     C                   PARM      *BLANKS       PFLDOT           16
      *
     C     PRTN          IFEQ      '*ERROR*'
     C                   SETON                                        9836
     C                   SETON                                        40
     C                   MOVEL     'XXX1166'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GSRNG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      PFLDOT        #GSRNG
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #GERNG        IFNE      *BLANKS
     C                   SETOFF                                       41
     C                   MOVEL     *BLANKS       PFLDIN
     C                   MOVE      #GERNG        PFLDIN
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRTN
     C                   PARM                    PFLDIN
     C                   PARM      0             PDEC
     C                   PARM      3             PDIGIT
     C                   PARM      *BLANKS       PFLDOT
      *
     C     PRTN          IFEQ      '*ERROR*'
     C                   SETON                                        9837
     C                   SETON                                        41
     C                   MOVEL     'XXX1166'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GSRNG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      PFLDOT        #GERNG
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Batch number should not overlap any range defined in
      **  GL batch entries table (GLJENHPD)
      *
      **  Check start batch range
     C     *IN40         IFEQ      '0'
     C     #GSRNG        CHAIN     @BRREAG                            55
      ** Record found, send error message
     C     *IN55         IFEQ      '0'
     C                   SETON                                        9836
     C                   SETON                                        40
     C                   MOVEL     'XXX1168'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      **  Check end batch range
     C     *IN41         IFEQ      '0'
     C     #GERNG        CHAIN     @BRREAG                            55
      ** Record found, send error message
     C     *IN55         IFEQ      '0'
     C                   SETON                                        9837
     C                   SETON                                        41
     C                   MOVEL     'XXX1168'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN40         IFEQ      '0'                                          Start Batch # is num
     C     *IN41         ANDEQ     '0'                                          End Batch # is numer
     C     #GSRNG        IFNE      *BLANKS
     C     #GERNG        ANDNE     *BLANKS
      *
     C                   MOVEL     #GSRNG        TSRNG             3 0
     C                   MOVEL     #GERNG        TERNG             3 0
      *
      **  End Batch number should be less than or equal to the start batch number.
     C     TERNG         IFLE      TSRNG
     C                   SETON                                        9837
     C                   MOVEL     'XXX1167'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      **  Check batch ranges in between start and end batch numbers
     C                   SETOFF                                       56
     C                   MOVE      TSRNG         BTNB              3 0
     C     BTNB          ADD       1             BTNB
     C     BTNB          DOWLT     TERNG
     C     *IN56         ANDEQ     '0'
     C                   MOVEL     BTNB          KBTNB             3
      *
     C     KBTNB         CHAIN     @BRREAG                            55
      ** Record found, send error message
     C     *IN55         IFEQ      '0'
     C                   SETON                                        98
     C                   SETON                                        36
     C                   SETON                                        37
     C                   SETON                                        56
      *
     C                   MOVEL     'XXX1168'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ELSE
     C     BTNB          ADD       1             BTNB
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
      ****Batch*ranges*entered*must*not*be*found*in*SDATYPY4*table.                           JMI109
      **  Batch ranges entered must not be found in XXATYPL4 table.                           JMI109
     C     *IN40         IFEQ      '0'                                          Start Batch # is num
     C     *IN41         ANDEQ     '0'                                          End Batch # is numer
     C     #GSRNG        ANDNE     *BLANKS
     C     #GERNG        ANDNE     *BLANKS
     C                   MOVEL     #GSRNG        WSRNG             3 0
     C                   MOVEL     #GERNG        WERNG             3 0
     C                   CALL      'XX109004'
     C                   PARM                    @RTCD             7
     C                   PARM                    WSRNG
     C                   PARM                    WERNG
      *
     C     @RTCD         IFEQ      'ERROR'
     C                   SETON                                        98
     C                   SETON                                        36
     C                   SETON                                        37
     C                   MOVEL     'XXX1168'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * G-AML sequence must be numeric.
     C     #GASEQ        IFEQ      *BLANKS
     C                   SETON                                        9838
     C                   MOVEL     'XXX1169'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     #GASEQ        IFNE      *BLANKS
     C                   MOVEL     *BLANK        PFLDIN
     C                   MOVE      #GASEQ        PFLDIN
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRTN              7
     C                   PARM                    PFLDIN           16
     C                   PARM      0             PDEC              1 0
     C                   PARM      3             PDIGIT            2 0
     C                   PARM      *BLANKS       PFLDOT           16
      *
     C     PRTN          IFEQ      '*ERROR*'
     C                   SETON                                        9838
     C                   MOVEL     'XXX1169'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GSRNG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      PFLDOT        #GASEQ
     C                   ENDIF
     C                   ENDIF
      *
      * G-AML Activity Type should not be blank.
     C     #GATYP        IFEQ      *BLANKS
     C                   SETON                                        9839
     C                   MOVEL     'XXX1170'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   MOVEL     #GMOD         ZA0003
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      *================================================================
     CSR                 ENDSR
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
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92
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
     C                   MOVEA     WKIND0        *IN(32)
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
     C                   Z-ADD     ##RR          ##SFRC               99
     C                   END
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create Activity Type Record
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98
      * Enable entry
     C                   SETOFF                                       87
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87
      * No SFLNXTCHG
     C                   SETOFF                                       84
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete Activity Type Record
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98
      * Enable entry
     C                   SETOFF                                       87
      * SFLNXTCHG
     C                   SETON                                        84
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87
      * No SFLNXTCHG
     C                   SETOFF                                       84
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
      * USER: Change Activity Type Record
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98
      * Enable entry
     C                   SETOFF                                       87
      * SFLNXTCHG
     C                   SETON                                        84
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * update successful
      * Enable entry
     C                   SETOFF                                       87
      * No SFLNXTCHG
     C                   SETOFF                                       84
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
     C     W0PMD         COMP      'ADD'                                  89
      * Protect keys if change mode or updated record
     C                   SETON                                        88
     C   89
     CANN87              SETOFF                                       88
     C                   MOVEL     *IN87         *IN78
     C     WUDELA        IFEQ      'N'
     C                   MOVEL     '1'           *IN78
     C                   END
     C                   MOVEL     *IN87         *IN77
     C     WUN3ST        IFEQ      'N'
     C                   MOVEL     '1'           *IN77
     C                   END
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89
     C                   MOVEL     '0'           *IN79
     C     WUN3ST        IFEQ      'N'
     C                   MOVEL     '1'           *IN79
     C                   END
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #GMOD
     C                   MOVEL     *BLANK        #GTYP
     C                   MOVEL     *BLANK        #GSTYP
     C                   MOVEL     *BLANK        #GSRNG
     C                   MOVEL     *BLANK        #GERNG
     C                   MOVEL     *BLANK        #GASEQ
     C                   MOVEL     *BLANK        #GATYP
     C                   MOVEL     *BLANK        #GADSC
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @ATYPY0 fields to subfile
      *================================================================
     C                   MOVEL     GMOD          #GMOD
     C                   MOVEL     GTYP          #GTYP
     C                   MOVEL     GSTYP         #GSTYP
     C     GSRNG         IFEQ      0
     C                   MOVE      *BLANKS       #GSRNG
     C                   ELSE
     C                   MOVEL     GSRNG         #GSRNG
     C                   ENDIF
     C     GERNG         IFEQ      0
     C                   MOVE      *BLANKS       #GERNG
     C                   ELSE
     C                   MOVEL     GERNG         #GERNG
     C                   ENDIF
     C                   MOVEL     GASEQ         #GASEQ
     C                   MOVEL     GATYP         #GATYP
     C                   MOVEL     GADSC         #GADSC
      * Hold current record image for change detection
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        @GMOD
     C                   MOVEL     *BLANK        @GTYP
     C                   MOVEL     *BLANK        @GSTYP
     C                   MOVEL     *ZERO         @GSRNG
     C                   MOVEL     *ZERO         @GERNG
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Activity Type Record
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @ATYPY1
     C                   MOVEL     #GMOD         GMOD
     C                   MOVEL     #GTYP         GTYP
     C                   MOVEL     #GSTYP        GSTYP
     C                   MOVEL     #GSRNG        GSRNG
     C                   MOVEL     #GERNG        GERNG
     C                   MOVE      #GASEQ        GASEQ
     C                   MOVEL     #GATYP        GATYP
     C                   MOVEL     #GADSC        GADSC
     C                   MOVEL     'I'           GLCHT                          Type of Last Ch
     C                   Z-ADD     WURDNB        GLCHD                          Last Change Dat
      *
     C     KLCRSA        KLIST
     C                   KFLD                    GMOD
     C                   KFLD                    GTYP
     C                   KFLD                    GSTYP
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @ATYPY1                                90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'XXX1149'     W0RTN             7
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
      * Send error message
     C                   MOVEL     'XXX1149'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @ATYPY1                              91
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Activity Type Record
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @ATYPY1
     C                   MOVEL     #GMOD         GMOD
     C                   MOVEL     #GTYP         GTYP
     C                   MOVEL     #GSTYP        GSTYP
     C                   MOVEL     #GSRNG        GSRNG
     C                   MOVEL     #GERNG        GERNG
      *
     C     KLDLSC        KLIST
     C                   KFLD                    GMOD
     C                   KFLD                    GTYP
     C                   KFLD                    GSTYP
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
     C     KLDLSC        CHAIN     @ATYPY1                            9091
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'XXX1150'     W0RTN             7
      * Send error message
     C                   MOVEL     'XXX1150'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     KLDLSC        SETLL     @ATYPY1                            9091
     C                   GOTO      SCEXIT
     C                   END
      *................................................................
     C                   DELETE    @ATYPY1                              91
     C     *IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
      *
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Activity Type record
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @ATYPY1
     C                   MOVEL     #GMOD         GMOD
     C                   MOVEL     #GTYP         GTYP
     C                   MOVEL     #GSTYP        GSTYP
     C                   MOVEL     #GSRNG        GSRNG
     C                   MOVEL     #GERNG        GERNG
      *
     C     KLCHSE        KLIST
     C                   KFLD                    GMOD
     C                   KFLD                    GTYP
     C                   KFLD                    GSTYP
     C                   KFLD                    GSRNG
     C                   KFLD                    GERNG
     C     KLCHSE        CHAIN     @ATYPY1                            9091
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C     'GB'          CAT       'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****              UNLOCK    SDATYPY1                             91                    JMI109
     C                   UNLOCK    XXATYPL1                             91                    JMI109
     C                   GOTO      SEEXIT
     C                   END
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @ATYPY1
     C                   MOVE      #GASEQ        GASEQ
     C                   MOVEL     #GATYP        GATYP
     C                   MOVEL     #GADSC        GADSC
     C                   Z-ADD     WURDNB        GLCHD                          Last Change Dat
     C                   MOVEL     'A'           GLCHT                          Type of Last Ch
      *
      * Set PGM.*Record Data Changed flag
     C     #1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C                   UPDATE    @ATYPY1                              91
     C                   ELSE
      * Release record lock
     C*****              UNLOCK    SDATYPY1                             91                    JMI109
     C                   UNLOCK    XXATYPL1                             91                    JMI109
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      *
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Check for blanks in key field
      *================================================================
     C                   MOVEL     #GMOD         WUDSTT                         data structure
      * CASE: WRK.Position One is Blank
     C     WUPOS1        IFEQ      *BLANK
      * Setup message data for message
     C                   MOVEL     #GMOD         ZA0005
      * Send error messge if Midas Module is blanks
     C                   MOVEL     'XXX1156'     ZAMSID
     C     'GB'          CAT       'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9833
     C                   END
      *================================================================
     CSR   UAEXIT        ENDSR
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
     C  N94              SETON                                        94
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
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
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
     C                   MOVEL     'Y'           W0ICL             1
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
      * Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field data structure
     C                   MOVEL     *BLANK        WUDSTT
      * Define work field Position One
     C                   MOVEL     *BLANK        WUPOS1            2
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Midas-Trade Innovation If
     C                   MOVEL     *BLANK        WUN3ST            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
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
     C*****              OPEN      SDJ108#                                                    JMI109
     C*****              OPEN      SDATYPY1                                                   JMI109
     C*****              OPEN      SDATYPY0                                                   JMI109
     C*****              OPEN      SDATYPY2                                                   JMI109
     C*****              OPEN      SDATYPY3                                                   JMI109
     C*****              OPEN      SDATYPY4                                                   JMI109
     C*****              OPEN      SDATYPY5                                                   JMI109
     C                   OPEN      XX109003#                                                  JMI109
     C                   OPEN      XXATYPL1                                                   JMI109
     C                   OPEN      XXATYPL0                                                   JMI109
     C                   OPEN      XXATYPL2                                                   JMI109
     C                   OPEN      XXATYPL3                                                   JMI109
     C                   OPEN      XXATYPL4                                                   JMI109
     C                   OPEN      XXATYPL5                                                   JMI109
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
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
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
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
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC*SDPSSRINT                                                                JMI109
     C/COPY SDCPYSRC,SDPSSRINTI                                                               JMI109
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2008
