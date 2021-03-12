     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Interest Statement of Deposit')               *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  XX000080 - Interest Statement of Deposit                     *
      *                                                               *
      *  Function:  This program generates Interest Statement of      *
      *             Deposit                                           *
      *                                                               *
      *  Called By: XXC000080 - Interest Statement of Deposit Ctl Pgm *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. LUC106             Date 21May15               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC106 - Dealing interest statement                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *      12          EOF of DLDWTXPD                              *
      *      13          Lookup on Array TABDT is OK                  *
      *                                                               *
      *      40          The account currency has no decimal place    *
      *      41          The account currency has 1 decimal place     *
      *      42          The account currency has 2 decimal places    *
      *      43          The account currency has 3 decimal places    *
      *                                                               *
      *      60          CHAIN Fail on SDWTRCL0 file                  *
      *      98          Date format indicator is 'M'                 *
      *                                                               *
      *         U7+U8    Set on if Database error occurs              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     FDLDWTXPD  IF   E           K DISK
      ** DL Daily Withholding Tax File
      *
     FSDWTRCL0  IF   E           K DISK
      ** Withholding Tax Rate Code File
      *
     FSDBRCHL0  IF   E             DISK
      ** Branch Codes File
      *
     FXX000080P1O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN01)
     F                                     USROPN
      ** Interest Statement of Deposit
      *
     D ZBRD            S              3    DIM(200)                             BRANCH CODE
     D ZAR1            S             35    DIM(200)                             BRCH ADDR LINE 1
     D ZAR2            S             35    DIM(200)                             BRCH ADDR LINE 2
     D ZAR3            S             35    DIM(200)                             BRCH ADDR LINE 3
     D ZAR4            S             35    DIM(200)                             BRCH ADDR LINE 4
     D TABDT           S              2    DIM(3) CTDATA PERRCD(1)              DEAL TYPE / DESC.
     D TABDTD          S             14    DIM(3) ALT(TABDT)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /EJECT
      ****************************************************************
     D*
     D** Output field of Currency
     D                 DS
     D  CCY                    1      3
     D  CCY0                   1      3
     D  CCY1                   1      3
     D  CCY2                   1      3
     D  CCY3                   1      3
     D  CCY4                   1      3
     D*
     D** Output field of Principal Amount for diff d.p.
     D                 DS
     D  PCPL                   1     13  0
     D  PCPL1                  1     13  1
     D  PCPL2                  1     13  2
     D  PCPL3                  1     13  3
     D*
     D** Output field of Interest Due Amount for diff d.p.
     D                 DS
     D  IDUE                   1     13  0
     D  IDUE1                  1     13  1
     D  IDUE2                  1     13  2
     D  IDUE3                  1     13  3
     D*
     D** Output field of Interest Paid (tax w/h) for diff d.p.
     D                 DS
     D  IPAD                   1     13  0
     D  IPAD1                  1     13  1
     D  IPAD2                  1     13  2
     D  IPAD3                  1     13  3
     D*
     D** Output field of Total Paid Amount for diff d.p.
     D                 DS
     D  PDAM                   1     13  0
     D  PDAM1                  1     13  1
     D  PDAM2                  1     13  2
     D  PDAM3                  1     13  3
     D*
     D** Output field of National Tax Amount for diff d.p.
     D                 DS
     D  NTXA                   1     13  0
     D  NTXA1                  1     13  1
     D  NTXA2                  1     13  2
     D  NTXA3                  1     13  3
     D*
     D** Output field of Local Tax Amount for diff d.p.
     D                 DS
     D  LTXA                   1     13  0
     D  LTXA1                  1     13  1
     D  LTXA2                  1     13  2
     D  LTXA3                  1     13  3
      *
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
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Index to subroutines                                         *
      *                                                               *
      *            MAIN   - Main Processing                           *
      *            PRINT  - Print Details                             *
      *                                                               *
      *            LAST   - Terminate                                 *
      *            DBERR  - Database Error Handling                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Main Processing                           *
      *                                                               *
      * CALLS      FIRST  - Initialize                                *
      *            LAST   - Terminate                                 *
      *            PRINT  - Print Details                             *
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
     C                   OPEN      XX000080P1
     C                   MOVE      SFILE         SavSFILE         10
      *
      ** Initial read daily Withholding tax file
      *
     C                   READ      DLDWTXD0                               12
      *
      ** Print Interest Statement of Deposit for each record
      *
     C     *IN12         DOWNE     '1'
     C                   EXSR      PRINT
     C                   READ      DLDWTXD0                               12
     C                   END
      *
     C** Ensure Report Spool File Recorded by RCF
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   OUT       LDA
     C                   CALL      'ZSFILE'
     C                   PARM                    @SEQ              5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SavSFILE
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
     C                   MOVE      @PGM          DBPGM
      *
      ** Access SDBANKPD for bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   EXSR      *PSSR
     C                   ELSE
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
     C                   MOVE      BJMRDT        PDATE
     C                   Z-ADD     BJRDNB        PRDNB             5 0
     C                   END
      **
      **   SET UP ARRAYS OF BRANCH CODES AGAINST THEIR NAMES & ADDRESSES
      **
     C                   Z-ADD     1             X                 3 0
      *
      ** Read first branch code record
      *
     C                   READ      SDBRCHL0                             7070
      *
     C     *IN70         DOWEQ     '0'
      *
      ** If live branch, access branch address and add to array
      *
     C     A8RECI        IFEQ      'D'
      *
      ** Get customer name & address for Branch Internal Customer
      *
     C                   MOVE      *BLANKS       CUSTA
     C                   MOVE      A8BICN        CUSTA            10
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
     C                   MOVEL     '02'          DBASE                           *DBERROR 002*
     C                   MOVEL     CNUM          DBKEY                           **************
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      A8BRCD        ZBRD(X)
     C                   MOVE      BBCNA1        ZAR1(X)
     C                   MOVE      BBCNA2        ZAR2(X)
     C                   MOVE      BBCNA3        ZAR3(X)
     C                   MOVE      BBCNA4        ZAR4(X)
     C                   ADD       1             X
      *
     C                   END
     C                   END
      *
      ** Access next branch code record
      *
     C                   READ      SDBRCHL0                             7070
      *
     C                   END
      *
      ** If branch code file contain no live records, DB error
      *
     C     X             IFLE      1
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *************
     C                   MOVEL     '09'          DBASE                          * DB ERR 09 *
     C                   MOVEL     *BLANKS       DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            PRINT  - Print Details                             *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     PRINT         BEGSR                                                  ** PRINT  **
      *
      ** Lookup deal type description
      *
     C     DTYP          LOOKUP    TABDT         TABDTD                   13
     C                   MOVEL     TABDTD        DPTY
      *
      ** Lookup name and address of the dealing branch
      *
     C                   Z-ADD     1             X
     C     BRCD          LOOKUP    ZBRD(X)                                13
     C                   MOVEL     ZAR1(X)       BADR1
     C                   MOVEL     ZAR2(X)       BADR2
     C                   MOVEL     ZAR3(X)       BADR3
     C                   MOVEL     ZAR4(X)       BADR4
      *
      ** Access national tax rate from tax rate code file
      *
     C                   Z-ADD     *ZERO         NTRT
     C     TTXC1         IFNE      *BLANKS                                      ** IF 02
     C     TTXC1         CHAIN     SDWTRCL0                           60
     C     *IN60         IFEQ      '1'
     C     *LOCK         IN        LDA                                          *************
     C                   MOVEL     '04'          DBASE                          * DB ERR 04 *
     C                   MOVEL     'SDWTRCPD'    DBFILE                         *************
     C                   MOVEL     TTXC1         DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     WTRT          NTRT
     C                   END
     C                   END                                                    ** END 02
      *
     C                   Z-ADD     *ZERO         LTRT
     C     TTXC2         IFNE      *BLANKS                                      ** IF 05
      *
      ** Access local tax rate from tax rate code file
      *
     C     TTXC2         CHAIN     SDWTRCL0                           60
     C     *IN60         IFEQ      '1'
     C     *LOCK         IN        LDA                                          *************
     C                   MOVEL     '05'          DBASE                          * DB ERR 05 *
     C                   MOVEL     'SDWTRCPD'    DBFILE                         *************
     C                   MOVEL     TTXC2         DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     WTRT          LTRT
     C                   END
     C                   END                                                    ** END 05
      *
     C** CALL ACCESS PROGRAM FOR CURRENCY DETAILS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      CCY           @DCCY             3
     C     SDCURR        PARM      SDCURR        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                          *************
     C                   MOVEL     '06'          DBASE                           *DBERROR 006*
     C                   MOVEL     BJCYCD        DBKEY                           *************
     C                   EXSR      *PSSR
     C                   ELSE
     C     A6NBDP        COMP      1                                    4041
     C     A6NBDP        COMP      2                                  43  42
      *
     C                   END
      *
      ** Get customer name & address from client file
      *
     C                   MOVE      *BLANKS       CUSTA
     C                   MOVE      CNUM          CUSTA
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
     C                   MOVEL     '07'          DBASE                           *DBERROR 007*
     C                   MOVEL     CNUM          DBKEY                           *************
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      BBCNA1        ADDR1
     C                   MOVE      BBCNA2        ADDR2
     C                   MOVE      BBCNA3        ADDR3
     C                   MOVE      BBCNA4        ADDR4
      *
     C                   END
      *
      ** Format Start Date
      *
     C                   Z-ADD     VDAT          ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        SDATE
      *
      ** Format End Date
      *
     C                   Z-ADD     MDAT          ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        MDATE
      *
      ** Calculate the term (from Start Date to End Date)
      *
     C                   Z-ADD     *ZEROS        TERM
     C     MDAT          IFNE      *ZEROS
     C     MDAT          SUB       VDAT          TERM
     C                   END
      *
      ** Output Interest Due
     C                   MOVE      TIDUE         IDUE
      ** Output National Tax
     C                   MOVE      TTXC1A        NTXA
      ** Output Local Tax
     C                   MOVE      TTXC2A        LTXA
      ** Output Net Interest
     C                   MOVE      TIPAD         IPAD
      ** Calculate the total paid amount
      *
     C                   Z-ADD     *ZEROS        PDAM
     C     PRDNB         IFGE      MDAT
     C     PCPL          ADD       TIPAD         PDAM
     C                   ELSE
     C                   Z-ADD     TIPAD         PDAM
     C                   END
      *
      ** Write Details
      *
     C                   WRITE     DETAIL
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
     C**
     C********************************************************************
**   DEAL TYPE/DEAL TYPE DESCRIPTION
TD TIME DEPOSIT
CD CALL DEPOSIT
CI C.D. ISSUED
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**  CPY@
(C) Copyright Midas-Kapiti International Ltd. 2001
