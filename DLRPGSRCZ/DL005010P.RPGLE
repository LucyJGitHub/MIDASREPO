     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Daily Witholding Tax Report')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL005010P - Midas DL Daily Witholding Tax Reporting          *
      *                                                               *
      *  Function:  This program generates Daily Witholding Tax Report*
      *                                                               *
      *                                                               *
      *  Called By: DLC005010 - Daily Withholding Tax Reporting Ctl Pgm*
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD056940           Date 19Oct20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056940 - Incorrect Details Reflected in Secondary Tax      *
      *             Amount column of DL005010P1 and RE005010P1        *
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
      *      12          CHAIN Fail on DLAWTXPD                       *
      *                                                               *
      *      20          The account currency has no decimal place    *
      *      21          The account currency has 1 decimal place     *
      *      22          The account currency has 2 decimal places    *
      *      23          The account currency has 3 decimal places    *
      *      24          The Daily Withholding Tax file is empty      *
      *                                                               *
      *                                                               *
      *         U7+U8    Set on if Database error occurs              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     FDLDWTXPD  IF   E           K DISK
      *
      ** Daily Withholding Tax File    Retrieval Index
      *
     FDLAWTXPD  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Monthly/Yearly Withholding Tax File
      *
     FSDWTRCL0  IF   E           K DISK
      *
      ** Withholding Tax Rate Code File
      *
     FDL005010P1O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN01)
      ** Tax Rate Codes List
      *
      /EJECT
      ****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      /EJECT
      ****************************************************************
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
     D LDA            UDS           256
     D**  Local data area
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D SPOOL           DS
     D** File information data structure - P1
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D*
     D SPOOLU          DS
     D** File information data structure - Audit
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D*
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
     I*
     I*
      *
      *
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
      *            *PSSR  - Database Error Handling : Terminates prog *
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
      *          MAIN      BEGSR                             ** MAIN **
      *
      ** Initial processing
      *
     C                   EXSR      FIRST
      *
      ** Initial read daily Withholding tax file
      *
     C                   READ      DLDWTXD0                               LR
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
     C                   READ      DLDWTXD0                               LR
      *
     C                   END                                                    ** DO END
      *
      ** If no. of records counter is equal to zero, print 'NO DETAILS
      ** TO REPORT' otherwise, print 'END OF REPORT'
      *
     C     CNOR          COMP      0                                      24
      *
     C                   WRITE     TOTPRT
     C** Ensure Report Spool File Recorded by RCF
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   OUT       LDA
     C                   CALL      'ZSFILE'
     C                   PARM                    @SEQ              5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
     C     *LOCK         IN        LDA
     C*
     C** Error During ZSFILE Processing, Return to Calling Program
     C*
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   END
     C*
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
      *
      ** Initialize field for pgm name
      *
     C                   MOVE      @PGM          DBPGM                                      *
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
     C*****SDCURR        PARM      SDCURR        DSFDY                                      MD056940
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD056940
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                          *************
     C                   MOVEL     '09'          DBASE                           *DBERROR 009*
     C                   MOVEL     BJLCCY        DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Store local currency decimal places.
     C     *LIKE         DEFINE    A6NBDP        BCCDP
     C                   Z-ADD     A6NBDP        BCCDP
      *
      ** Key List for chaining to the DLAWTXPD
      *
     C     @KEY1         KLIST
     C                   KFLD                    CCY
     C                   KFLD                    @TXRC
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
      *
      ** Get currency decimal places
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      CCY           @DCCY             3
     C*****SDCURR        PARM      SDCURR        DSFDY                                      MD056940
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD056940
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
     C*****SDCUST        PARM      SDCUST        DSFDY                                      MD056940
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD056940
     C*
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE                          *************
     C                   MOVEL     '03'          DBASE                           *DBERROR 003*
     C                   MOVEL     CNUM          DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
     C                   MOVEL     BBCNA1        CNA1
      *
      ** Format Tax Amounts if Main tax rate code 1 is not Blanks
      *
     C     TTXC1         IFNE      *BLANKS                                      ** IF 02
      *
      ** Chain to tax rate file to get rate for tax rate code 1
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
     C                   EXSR      *PSSR
      *
     C                   ELSE                                                   ** ELSE 03
      *
     C                   MOVE      TTXC1         NTRC
     C                   MOVE      WTRT          NTRT
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
      ** Format Main Tax Amount in Local ccy using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC1L        ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      BCCDP         ZDECS
      *
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
      *                                                                                     MD056940
     C                   ELSE                                                               MD056940
      * Tax Code not defined                                                                MD056940
      ** Format Main Tax Amount using ZFRPED                                                MD056940
     C                   MOVE      *BLANKS       @ENUM                                      MD056940
     C                   Z-ADD     0             ZFLD15                                     MD056940
     C                   MOVE      'J'           ZECODE                                     MD056940
     C                   MOVE      A6NBDP        ZDECS                                      MD056940
      *                                                                                     MD056940
     C                   CALLB     'ZFRPED'                                                 MD056940
     C                   PARM                    ZFLD15                                     MD056940
     C                   PARM                    ZDECS                                      MD056940
     C                   PARM                    ZECODE                                     MD056940
     C                   PARM                    ZOUT22                                     MD056940
     C                   PARM                    ZWRK25                                     MD056940
      *                                                                                     MD056940
     C                   MOVE      ZOUT22        @ENUM                                      MD056940
     C                   MOVE      @EN           NTDLAT                                     MD056940
      *                                                                                     MD056940
      ** Format Main Tax Amount in Local ccy using ZFRPED                                   MD056940
     C                   MOVE      *BLANKS       @ENUM                                      MD056940
     C                   Z-ADD     0             ZFLD15                                     MD056940
     C                   MOVE      'J'           ZECODE                                     MD056940
     C                   MOVE      BCCDP         ZDECS                                      MD056940
      *                                                                                     MD056940
     C                   CALLB     'ZFRPED'                                                 MD056940
     C                   PARM                    ZFLD15                                     MD056940
     C                   PARM                    ZDECS                                      MD056940
     C                   PARM                    ZECODE                                     MD056940
     C                   PARM                    ZOUT22                                     MD056940
     C                   PARM                    ZWRK25                                     MD056940
      *                                                                                     MD056940
     C                   MOVE      ZOUT22        @ENUM                                      MD056940
     C                   MOVE      @EN           NTBSAT                                     MD056940
      *
     C                   END                                                    ** END 02
      *
      ** Format Tax Amounts if Secondary tax rate code is not Blanks
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
     C                   MOVEL     'SDWTRCPD'    DBFILE                         ***************
     C                   MOVEL     TTXC2         DBKEY
     C                   EXSR      *PSSR
      *
     C                   ELSE                                                   ** ELSE 06
      *
     C                   MOVE      TTXC2         LTRC
     C                   MOVE      WTRT          LTRT
      *
      ** Format Secondary Tax Amount using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC2A        ZFLD15
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
     C                   MOVE      @EN           LTDLAT
      *
      ** Format Secondary Tax Amount in base ccy using ZFRPED
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      TTXC2L        ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      BCCDP         ZDECS
      *
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
      *                                                                                     MD056940
     C                   ELSE                                                               MD056940
      * Tax Code not defined                                                                MD056940
      ** Format Secondary Tax Amount using ZFRPED                                           MD056940
     C                   MOVE      *BLANKS       @ENUM                                      MD056940
     C                   Z-ADD     0             ZFLD15                                     MD056940
     C                   MOVE      'J'           ZECODE                                     MD056940
     C                   MOVE      A6NBDP        ZDECS                                      MD056940
      *                                                                                     MD056940
     C                   CALLB     'ZFRPED'                                                 MD056940
     C                   PARM                    ZFLD15                                     MD056940
     C                   PARM                    ZDECS                                      MD056940
     C                   PARM                    ZECODE                                     MD056940
     C                   PARM                    ZOUT22                                     MD056940
     C                   PARM                    ZWRK25                                     MD056940
      *                                                                                     MD056940
     C                   MOVE      ZOUT22        @ENUM                                      MD056940
     C                   MOVE      @EN           LTDLAT                                     MD056940
      *                                                                                     MD056940
      ** Format Secondary Tax Amount in base ccy using ZFRPED                               MD056940
     C                   MOVE      *BLANKS       @ENUM                                      MD056940
     C                   Z-ADD     0             ZFLD15                                     MD056940
     C                   MOVE      'J'           ZECODE                                     MD056940
     C                   MOVE      BCCDP         ZDECS                                      MD056940
      *                                                                                     MD056940
     C                   CALLB     'ZFRPED'                                                 MD056940
     C                   PARM                    ZFLD15                                     MD056940
     C                   PARM                    ZDECS                                      MD056940
     C                   PARM                    ZECODE                                     MD056940
     C                   PARM                    ZOUT22                                     MD056940
     C                   PARM                    ZWRK25                                     MD056940
      *                                                                                     MD056940
     C                   MOVE      ZOUT22        @ENUM                                      MD056940
     C                   MOVE      @EN           LTBSAT                                     MD056940
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
      *
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
      *
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
      ** Format Principal Amount
      *
     C     PCPL          IFNE      0                                            ** IF 07
     C                   MOVE      *BLANKS       @ENUM
     C                   MOVE      PCPL          ZFLD15
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
     C                   MOVE      @EN           PCPLAT
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
     C                   MOVE      TTXC1         @TXRC             2
      *
     C     @KEY1         CHAIN     DLAWTXPD                           12
      *
      ** If record found but record id is not equal to D
      *
     C     *IN12         IFEQ      '0'                                          ** IF 02
     C     RECI          ANDNE     'D'
      *
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     '06'          DBASE                          ** DB ERR 06 **
     C                   MOVEL     'DLAWTXPD'    DBFILE                         ***************
     C                   MOVE      TTXC1         @WRK5             5
     C                   MOVEL     CCY           @WRK5
     C                   MOVEL     @WRK5         DBKEY
     C                   EXSR      *PSSR
      *
     C                   END                                                    ** END 02
      *
      ** If record not found, write new record for that tax rate code
      *
     C     *IN12         IFEQ      '1'                                          ** IF 03
     C                   MOVE      TTXC1         TXRC
     C                   Z-ADD     TTXC1A        MTXA
     C                   Z-ADD     TTXC1A        YTXA
     C                   Z-ADD     TTXC1L        MTXL
     C                   Z-ADD     TTXC1L        YTXL
     C                   WRITE     DLAWTXD0
      *
     C                   ELSE                                                   ** ELSE 03
      *
      ** If record found, update the existing amounts
      *
     C                   ADD       TTXC1A        MTXA
     C                   ADD       TTXC1A        YTXA
     C                   ADD       TTXC1L        MTXL
     C                   ADD       TTXC1L        YTXL
     C                   UPDATE    DLAWTXD0
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
     C                   MOVE      TTXC2         @TXRC                                       **
      *
     C     @KEY1         CHAIN     DLAWTXD0                           12
      *
      ** If record found but record id is not equal to D
      *
     C     *IN12         IFEQ      '0'                                          ** IF 05
     C     RECI          ANDNE     'D'
      *
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     '07'          DBASE                          ** DB ERR 07 **
     C                   MOVEL     'DLAWTXPD'    DBFILE                         ***************
     C                   MOVE      TTXC2         @WRK5             5
     C                   MOVEL     CCY           @WRK5
     C                   MOVEL     @WRK5         DBKEY
     C                   EXSR      *PSSR
      *
     C                   END                                                    ** END 05
      *
      ** If record not found, write new record for that tax rate code
      *
     C     *IN12         IFEQ      '1'                                          ** IF 06
     C                   MOVE      TTXC2         TXRC
     C                   Z-ADD     TTXC2A        MTXA
     C                   Z-ADD     TTXC2A        YTXA
     C                   Z-ADD     TTXC2L        MTXL
     C                   Z-ADD     TTXC2L        YTXL
     C                   WRITE     DLAWTXD0
      *
     C                   ELSE                                                   ** ELSE 06
      *
      ** If record found, update the existing amounts
      *
     C                   ADD       TTXC2A        MTXA
     C                   ADD       TTXC2A        YTXA
     C                   ADD       TTXC2L        MTXL
     C                   ADD       TTXC2L        YTXL
     C                   UPDATE    DLAWTXD0
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
     C                   MOVEL     @PGM          DBPGM
     C                   WRITE     DBERRP
      *
     C                   OUT       LDA
     C                   DUMP
     C                   SETON                                        U7U8LR
     C                   RETURN
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
      *
**  CPY@
(c) Finastra International Limited 2015
