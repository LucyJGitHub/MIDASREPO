     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS RE Daily Witholding Tax Report')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE005010P - Midas RE Daily Reporting Tax Reporting           *
      *                                                               *
      *  Function:  This program will produce a report showing the    *
      *  (phase(s)) the Tax Withheld Today, Tax Rates, and the        *
      *             Interest Amount of the corresponding retail a/c.  *
      *                                                               *
      *  Called By: REC005010 - Daily Withholding Tax Reporting Ctl Pgm*
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. HUT107             Date 27May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT107 - Additional 3rd Party Trust Indicator                *
      *           (Upgrade HUT016 to FM2.1 SP22)                      *
      *           Addition of hooks HUT107_007 to HUT107_010          *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *      01          Overflow Indicator                           *
      *      11          CHAIN Fail on SDWTRCPD                       *
      *      12          CHAIN Fail on REAWTXPD                       *
      *                                                               *
      *      20          The account currency has no decimal place    *
      *      21          The account currency has 1 decimal place     *
      *      22          The account currency has 2 decimal places    *
      *      23          The account currency has 3 decimal places    *
      *      24          The Daily Withholding Tax file is empty      *
      *                                                               *
      *         U7+U8    Set on if Database error occurs              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     FREDWTXPD  IF   E           K DISK
      *
      ** Daily Withholding Tax File    Retrieval Index
      *
     FREAWTXPD  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Monthly/Yearly Withholding Tax File
      *
     FSDWTRCL0  IF   E           K DISK
      *
      ** Withholding Tax Rate Code File
      *
      ** Customer Address file
      *
     FRE005010P1O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN01)
      ** Tax Rate Codes List
     F/COPY WNCPYSRC,HUT107_007                                                          HUT107
      *
      /EJECT
      ****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /EJECT
      ****************************************************************
      *
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      *
      **DETA STRUCTURE THAT ACQUIRE THE SPOOL FILE DETAILS
      *
     D @ENUM           DS            19
      ** Data structure for splitting the edited numeric which
      ** has a value with 2 spaces to the right (CR,-)
      *
     D  @EN                    1     17
     D  @FL                   18     19
     D PSDS           SDS
      *
      **  Program Status Data Structure
      *
      **                   Program name
     D  @PGM                   1     10
      *
     D LDA            UDS           256
      *
      **  Local data area for data base errors.
      *
      **  Group level field of the foll. other fields
     D  DBLOT                134    177
      *
      **  Name of database file in error
     D  DBFILE               134    141
      *
      **  Key value causing database error
     D  DBKEY                142    167
      *
      **  Name of program causing database error
     D  DBPGM                168    175
      *
      **  Number of database error
     D  DBASE                176    177
      *
     D/COPY WNCPYSRC,HUT107_008                                                          HUT107
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  MIDAS ABS Bank Details
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D**  MIDAS ABS Bank Details
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D**  MIDAS ABS Currency Details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure for access programs
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     I**  Long data structure for access programs
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Index to subroutines                                         *
      *                                                               *
      *            MAIN   - Main Processing                           *
      *            PRTDET - Print Details                             *
      *            UPDMYF - Update Monthly/Yearly Withholding Tax File*
      *                                                               *
      *            LAST   - Terminate                                 *
      *            DBERR  - Database Error Handling : Terminates prog *
      *                                                               *
      *            ZFRPED - Converts numeric fields to edited with    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Main Processing                           *
      *                                                               *
      * CALLS      FIRST  - Initialize                                *
      *            LAST   - Terminate                                 *
      *            PRTDET - Print Details                             *
      *            UPDMYF - Update Monthly/Yearly File                *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
      *
      ** Receive Parameter from CLP/REC005010
     C     *ENTRY        PLIST
     C                   PARM                    SEQ               5
      *
      ** Initial processing
     C                   EXSR      FIRST
      *          MAIN      BEGSR                             ** MAIN **
      *
      *
      ** Initial read daily Withholding tax file
      *
     C                   READ      REDWTXD0                               LR
      *
      ** Display message subfile control record
      *
     C                   WRITE     HEAD1
      *
      ** Move currency to temporary field for change of ccy checking
      *
     C                   MOVE      CCY           @CCY              3
      *
      ** Do while not end-of-file
      *
     C     *INLR         DOWEQ     '0'                                          ** DO
      *
      ** Print header if overflow
      *
     C     *IN01         IFEQ      '1'
     C     CCY           ORNE      @CCY
     C                   WRITE     HEAD1
     C                   MOVE      CCY           @CCY
     C                   SETOFF                                         01
     C                   END
      *
      ** Print Details
      *
     C                   EXSR      PRTDET
      *
      ** Update Monthly/Yearly Withholding Tax File
      *
     C                   EXSR      UPDMYF
      *
      ** Read Daily Withholding tax file
      *
     C                   READ      REDWTXD0                               LR
      *
     C                   END                                                    ** DO END
      *
      ** If no. of records counter is equal to zero, print 'NO DETAILS
      ** TO REPORT' otherwise, print 'END OF REPORT'
      *
     C     CNOR          COMP      0                                      24
      *
     C                   WRITE     TOTPRT
      *
      **  Final Processing
      *
     C                   EXSR      LAST
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            FIRST  - Initialize                                *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     FIRST         BEGSR                                                  ** FIRST  **
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialization of LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *
      ** Initialize field for pgm name
      *
     C                   MOVE      @PGM          DBPGM
      *
      ** Initialize calculated no. of records
      *
     C                   Z-ADD     0             CNOR
      *
      ** Access SDBANKPD for bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   EXSR      *PSSR
     C                   END
      *
      * Set up Header Fields
     C                   MOVEL     BJURPT        TITL
     C                   MOVEL     BJMRDT        RUNA
      *
      ** CALL ACCESS PROGRAM FOR CURRENCY DETAILS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      BJLCCY        @DCCY             3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                          *************
     C                   MOVEL     '09'          DBASE                           *DBERROR 009*
     C                   MOVEL     BJLCCY        DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Store base currency decimal places.
     C     *LIKE         DEFINE    A6NBDP        BCCDP
     C                   Z-ADD     A6NBDP        BCCDP
      *
      ** Key List for chaining to the REAWTXPD
      *
     C     @KEY1         KLIST
     C                   KFLD                    CCY
     C                   KFLD                    @TTXRC
     C/COPY WNCPYSRC,HUT107_009                                                          HUT107
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            PRTDET - Print Details                             *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     PRTDET        BEGSR                                                  ** PRTDET **
      *
      ** Initialize Tax Amounts fields in printer file
      *
     C                   MOVE      *BLANKS       NTDLAT
     C                   MOVE      *BLANKS       LTDLAT
     C                   MOVE      *BLANKS       NTBSAT
     C                   MOVE      *BLANKS       LTBSAT
     C                   MOVE      *BLANKS       INTDUE
     C                   MOVE      *BLANKS       INTPAD
     C                   MOVE      '0'           NTDLAT
     C                   MOVE      '0'           LTDLAT
     C                   MOVE      '0'           NTBSAT
     C                   MOVE      '0'           LTBSAT
     C                   MOVE      '0'           INTDUE
     C                   MOVE      '0'           INTPAD
     C                   Z-ADD     0             NTRC
     C                   Z-ADD     0             NTRT
     C                   Z-ADD     0             LTRC
     C                   Z-ADD     0             LTRT
      *
      ** Get currency decimal places
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      CCY           @DCCY             3
     C     SDCURR        PARM      SDCURR        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                          *************
     C                   MOVEL     '02'          DBASE                           *DBERROR 002*
     C                   MOVEL     CCY           DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Get customer address 1 from client file
      *
     C                   MOVEL     CNUM          CUSTA            10
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      CUSTA         @DCST            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE                          *************
     C                   MOVEL     '03'          DBASE                           *DBERROR 003*
     C                   MOVEL     CNUM          DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
     C                   MOVEL     BBCNA1        CNA1
     C/COPY WNCPYSRC,HUT107_010                                                          HUT107
      *
      ** Format Tax Amounts if main tax rate code is not blanks
      *
     C     TTXC1         IFNE      *BLANKS
      *
      ** Chain to tax rate file to get rate for Main tax rate code
      *
     C     TTXC1         CHAIN     SDWTRCL0                           11
      *
      ** If record not found.
      *
     C     *IN11         IFEQ      '1'                                          ** IF 03
      *
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     '04'          DBASE                          ** DB ERR 04 **
     C                   MOVEL     'SDWTRCPD'    DBFILE                         ***************
     C                   MOVEL     TTXC1         DBKEY
     C                   EXSR      DBERR
      *
     C                   ELSE                                                   ** ELSE 03
      *
     C                   Z-ADD     WTRT          NTRT
     C                   MOVE      TTXC1         NTRC
      *
      ** Format Main Tax Amount using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC1A        ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      A6NBDP        ZDECS
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        @ENUM
     C                   MOVE      @EN           NTDLAT
      *
      ** Format Main Tax Amount in Local Ccy using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC1L        ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      BCCDP         ZDECS
     C*
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        @ENUM
     C                   MOVE      @EN           NTBSAT
      *
     C                   END                                                    ** END 03
      *
     C                   END                                                    ** END 02
      *
      ** Format Tax Amounts if Secondary tax rate code is not blanks
      *
     C     TTXC2         IFNE      *BLANKS                                      ** IF 05
      *
      ** Chain to tax rate file to get rate for Secondary tax rate code
      *
     C     TTXC2         CHAIN     SDWTRCL0                           11
      *
      ** If record not found.
      *
     C     *IN11         IFEQ      '1'                                          ** IF 06
      *
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     '05'          DBASE                          ** DB ERR 05 **
     C                   MOVEL     'SDWTRCPD'    DBFILE
     C                   MOVEL     TTXC2         DBKEY
     C                   EXSR      DBERR
      *
     C                   ELSE                                                   ** ELSE 06
      *
     C                   Z-ADD     WTRT          LTRT
     C                   MOVE      TTXC2         LTRC
      *
      ** Format Secondary Tax Amount using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC2A        ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      A6NBDP        ZDECS
     C*
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        @ENUM
     C                   MOVE      @EN           LTDLAT
      *
      ** Format Secondary Tax Amount in Local Ccy using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC2L        ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      BCCDP         ZDECS
     C*
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        @ENUM
     C                   MOVE      @EN           LTBSAT
      *
     C                   END                                                    ** END 06
      *
     C                   END                                                    ** END 05
      *
      ** Format Interest Due
      *
     C     TIDUE         IFNE      0                                            ** IF 07
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TIDUE         ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      A6NBDP        ZDECS
     C*
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        @ENUM
     C                   MOVE      @EN           INTDUE
     C                   END                                                    ** END 07
      *
      *
      ** Format Interest Paid
      *
     C     TIPAD         IFNE      0                                            ** IF 07
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TIPAD         ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      A6NBDP        ZDECS
     C*
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        @ENUM
     C                   MOVE      @EN           INTPAD
     C                   END                                                    ** END 07
      *
      ** Write Details
      *
     C                   WRITE     DETAIL
      *
      ** Increment the number of records field
      *
     C                   ADD       1             CNOR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            UPDMYF - Update Monthly/Yearly Withholding Tax     *
      *                     File                                      *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     UPDMYF        BEGSR                                                  ** UPDMYF **
      *
      ** Process Main Tax Amount
      *
     C     TTXC1         IFNE      *BLANKS                                      ** IF 01
      *
      ** Set-up Key
      *
     C                   MOVE      TTXC1         @TTXRC            2
      *
     C     @KEY1         CHAIN     REAWTXPD                           12
      *
      ** If record found but record id is not equal to D
      *
     C     *IN12         IFEQ      '0'                                          ** IF 02
     C     RECI          ANDNE     'D'
      *
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     '06'          DBASE                          ** DB ERR 06 **
     C                   MOVEL     'REAWTXPD'    DBFILE                         ***************
     C                   MOVE      TTXC1         @WRK5             5
     C                   MOVEL     CCY           @WRK5
     C                   MOVEL     @WRK5         DBKEY
     C                   EXSR      DBERR
      *
     C                   END                                                    ** END 02
      *
      ** If record not found, write new record for that tax rate code
      *
     C     *IN12         IFEQ      '1'                                          ** IF 03
     C                   MOVE      TTXC1         TTXRC
     C                   Z-ADD     TTXC1A        TMTXA
     C                   Z-ADD     TTXC1A        TYTXA
     C                   Z-ADD     TTXC1L        TMTXL
     C                   Z-ADD     TTXC1L        TYTXL
     C                   WRITE     REAWTXD0
      *
     C                   ELSE                                                   ** ELSE 03
      *
      ** If record found, update the existing amounts
      *
     C                   ADD       TTXC1A        TMTXA
     C                   ADD       TTXC1A        TYTXA
     C                   ADD       TTXC1L        TMTXL
     C                   ADD       TTXC1L        TYTXL
     C                   UPDATE    REAWTXD0
      *
     C                   END                                                    ** END 03
      *
     C                   END                                                    ** END 01
      *
      ** Process Secondary Tax Amount
      *
     C     TTXC2         IFNE      *BLANKS                                      ** IF 04
      *
      ** Set-up Key
      *
     C                   MOVE      TTXC2         @TTXRC
      *
     C     @KEY1         CHAIN     REAWTXD0                           12
      *
      ** If record found but record id is not equal to D
      *
     C     *IN12         IFEQ      '0'                                          ** IF 05
     C     RECI          ANDNE     'D'
      *
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     '07'          DBASE                          ** DB ERR 07 **
     C                   MOVEL     'UPDAWHTX'    DBFILE                         ***************
     C                   MOVE      TTXC2         @WRK5             5
     C                   MOVEL     CCY           @WRK5
     C                   MOVEL     @WRK5         DBKEY
     C                   EXSR      DBERR
      *
     C                   END                                                    ** END 05
      *
      ** If record not found, write new record for that tax rate code
      *
     C     *IN12         IFEQ      '1'                                          ** IF 06
     C                   MOVE      TTXC2         TTXRC
     C                   Z-ADD     TTXC2A        TMTXA
     C                   Z-ADD     TTXC2A        TYTXA
     C                   Z-ADD     TTXC2L        TMTXL
     C                   Z-ADD     TTXC2L        TYTXL
     C                   WRITE     REAWTXD0
      *
     C                   ELSE                                                   ** ELSE 06
      *
      ** If record found, update the existing amounts
      *
     C                   ADD       TTXC2A        TMTXA
     C                   ADD       TTXC2A        TYTXA
     C                   ADD       TTXC2L        TMTXL
     C                   ADD       TTXC2L        TYTXL
     C                   UPDATE    REAWTXD0
      *
     C                   END                                                    ** END 06
      *
     C                   END                                                    ** END 04
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            LAST   - Terminate                                 *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR                                                  ** LAST   **
      *
     C                   MOVE      '1'           *INLR
      *
      ** Ensure report spool file is recorded by RCF
      *
     C                   Z-ADD     SFNUM         SFNUM1            6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       @PARM             3
     C                   PARM                    SFILE
     C                   PARM                    SFNUM1
     C                   PARM                    ZSERR             1
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *PSSR  -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR  **
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            INFSR  -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     INFSR         BEGSR                                                  ** INFSR  **
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling : Terminates prog *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  FIRST  - Initital Processing                       *
      *            PRTDET - Print Details                             *
      *            UPDMYF - Update Monthly/Yearly Withholding Tax File*
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR                                                  ** DBERR  **
      *
     C                   MOVEL     @PGM          DBPGM
     C                   WRITE     DBERRP
      *
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
**  CPY@
(c) Finastra International Limited 2015
