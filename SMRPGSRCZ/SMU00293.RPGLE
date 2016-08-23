     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT populate data to RE ICD files - ctl')         *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  SMU00293 - Currency not in Installation control data files.  *
      *                                                               *
      *  Function:  This program will be called from Bridge option    *
      *             It will check if Retail Module is ON.             *
      *             If the module is ON, it will scan through         *
      *             SDCURRPD and write those records to the           *
      *             Installation control data files.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. AR213428 *Create   Date 19May14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR213428 - Utility that will populate data to RECCYD,        *
      *             RECCYDXC from SDCURRPD if Retail Module is ON.    *
      *           - Applied for MD-26962                              *
      *                                                               *
      *****************************************************************
     FSMU00293AUO    F  132        PRINTER USROPN
     FSMU00293P1O    F  132        PRINTER USROPN
     F                                     oflind(*inof)
     FSDMMODL1  IF   E           K DISK
     FSDCURRPD  IF   E           K DISK
     FSDBANKPD  IF   E           K DISK
     FRECCY     UF A E           K DISK    USROPN
     F                                     IGNORE(RECCYAF)
     F                                     IGNORE(RECCYZF)
      ** UPD : Midas RE Installation control data update
      *
     FRECCYDXC  UF A E           K DISK    USROPN
      ** UPD : Midas RE Installation control extension file update
      *
     FRECCYZ    UF A E             DISK    USROPN
      ** UPD : Midas RE Installation control data trailer update
      *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT   - Initialisation                                    *
      *  SRREICD  - Insert a new record on Retail ICD file PF/RECCYD  *
      *  *PSSR    - Subroutine to handle error conditions             *
      *                                                               *
      *****************************************************************
      *
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     DSDMMOD         E DS                  EXTNAME(SDMMODPD)
      *
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     DDSFDY          E DS                  EXTNAME(DSFDY)
     DRUNDAT           DS
     DMRDT                     1      7
     DRDNB                     8     10P 0
     DSUC                     11     11
     DDFF                     12     12
     DMBIN                    13     13
     DRECKEY           DS            12
      *
      ** Key field for call to RECCY
      *
     DW#CYCD                   9     11
     DW#FILL                  12     12
      *
      ** Data structure for array totals in RECCYZ
      *
     DDNR              DS            15
     DNR                       1     15
     DNR1                      1      3P 0
     DNR2                      4      6P 0
     DNR3                      7      9P 0
     DNR4                     10     12P 0
     DNR5                     13     15P 0
      *
      ** Data structure to update Last Transaction No. data area
      *
     DDNATN            DS             5
     DFNATN                    1      5  0
      *****************************************************************
      *
      ** Entry parameter - 'A' for Audit; 'U' for Update
      *
     C     *ENTRY        PLIST
     C                   PARM                    #MODE             1
      *
      *****************************************************************
      *                                                               *
      *  MAINCR - Main processing                                     *
      *                                                               *
      *  Called By: *NONE                                             *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C                   EXSR      SRINIT
     C                   ADD       1             PAGCTR            5 0
     C                   MOVE      PAGCTR        PAGEN             5 0
     C                   OPEN      SMU00293AU
     C                   OPEN      SMU00293P1
     C                   EXCEPT    HEAD1
     C                   EXCEPT    HEAD2
     C                   EXCEPT    HEADP1
     C                   EXCEPT    HEADP2
     C     #MODE         IFEQ      'A'
     C     #MODE         OREQ      'a'
     C                   MOVE      '1'           *IN50
     C                   ELSE
     C                   MOVE      '0'           *IN50
     C                   ENDIF
     C                   EXCEPT    HEAD3
     C                   EXCEPT    HEADP3
     C                   EXCEPT    TITP1
     C                   EXCEPT    TITP2
     C     BGRTBN        IFEQ      'Y'
     C                   READ      SDCURRPD                               91
     C                   OPEN      RECCY
     C                   OPEN      RECCYDXC
     C                   OPEN      RECCYZ
     C                   MOVE      0             RECTR
     C                   MOVE      0             EXTCTR
     C     *IN91         DOWEQ     '0'
     C                   MOVEL     A6CYCD        #1CYCD            3
     C                   MOVEL     A6NBDP        #DNDPA            1
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN60
     C                   EXSR      SRREICD
     C                   READ      SDCURRPD                               91
     C                   ENDDO
     C                   ENDIF
     C     LINCTR        IFEQ      0
     C                   EXCEPT    NOREPORT
     C                   ENDIF
     C                   EXCEPT    AUDIT1
     C                   EXCEPT    AUDIT2
     C                   EXCEPT    TRAILER
     C                   EXCEPT    TRAILERP1
     C                   CLOSE     RECCY
     C                   CLOSE     RECCYDXC
     C                   CLOSE     RECCYZ
     C                   CLOSE     SMU00293AU
     C                   CLOSE     SMU00293P1
     C                   MOVE      *ON           *INLR
      *****************************************************************
      *                                                               *
      *  SRREICD - Insert a new record on Retail ICD file PF/RECCYD   *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SRREICD       BEGSR
      *
      ** Setup key for RECCY
      *
     C                   MOVEL     *BLANKS       RECKEY
     C                   MOVEL     #1CYCD        W#CYCD
     C                   MOVEL     'D'           W#FILL
      *
      ** Check if record already exists
      *
     C     RECKEY        CHAIN     RECCY                              90
     C     *IN90         IFEQ      '1'
      *
      ** Setup a record on RECCYD with default values
      *
     C                   MOVE      '1'           *IN20
     C                   MOVEL     'D'           RECI
     C                   MOVEL     RECKEY        KEY
     C                   MOVEL     *BLANKS       ZZ017
     C                   Z-ADD     WURDNB        ORED
     C                   Z-ADD     WURDNB        LCD
     C                   MOVEL     'I'           CHTP
     C                   Z-ADD     0             HASH
     C                   Z-ADD     0             MIDC
     C                   Z-ADD     *ALL'9'       MADC
     C                   Z-ADD     0             MICC
     C                   Z-ADD     *ALL'9'       MACC
     C                   MOVEL     *BLANKS       ZZ053
     C                   Z-ADD     0             HORT
     C                   Z-ADD     0             HOMN
     C                   Z-ADD     *ALL'9'       HOMX
     C                   Z-ADD     0             ACRT
     C                   Z-ADD     0             ACMN
     C                   Z-ADD     *ALL'9'       ACMX
     C                   Z-ADD     0             DIRT
     C                   Z-ADD     0             DIMN
     C                   Z-ADD     *ALL'9'       DIMX
     C                   Z-ADD     0             INFC
     C                   Z-ADD     0             MCFC
     C                   Z-ADD     0             AMBC
     C                   Z-ADD     0             MSFC
     C                   Z-ADD     0             AMBS
     C                   Z-ADD     0             DSFC
     C                   Z-ADD     0             DSMN
     C                   Z-ADD     0             DSMX
     C                   Z-ADD     0             FCFC
     C                   Z-ADD     0             AMO1
     C                   Z-ADD     0             AMO2
     C                   Z-ADD     0             AMO3
     C                   Z-ADD     0             AMO4
     C                   Z-ADD     0             AMO5
     C                   Z-ADD     0             AMO6
     C                   Z-ADD     0             AMO7
     C                   Z-ADD     0             AMO8
     C                   Z-ADD     0             CMNR
     C                   Z-ADD     0             CMNP
     C                   Z-ADD     0             CMNV
     C                   Z-ADD     0             CADR
     C                   Z-ADD     0             CADP
     C                   Z-ADD     0             CADV
     C                   MOVEL     *BLANKS       ZZ175
      *
      ** Obtain 'Transaction no. of last update'
      *
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         ZZWK05            5 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
     C                   Z-ADD     FNATN         TNLU
     C                   ADD       1             RECTR             5 0
      *
      ** Insert new record in RECCYD
      *
     C                   MOVEL     #1CYCD        CCY1              3
     C     #MODE         IFEQ      'U'
     C     #MODE         OREQ      'u'
     C                   MOVE      '1'           *IN60
     C                   WRITE     RECCYDF
     C                   ENDIF
     C                   ENDIF
     C     #1CYCD        CHAIN     RECCYDXC                           90
     C     *IN90         IFEQ      '1'
      *
      ** Setup record in extension file RECCYDX with default values
      *
     C                   MOVE      '1'           *IN21
     C                   MOVEL     #1CYCD        RYCCYD
     C                   Z-ADD     0             RYCHGC
     C                   Z-ADD     0             RYCHGD
     C                   Z-ADD     0             RYCHGW
     C                   Z-ADD     0             RYCHGF
     C                   Z-ADD     0             RYCHGS
     C                   Z-ADD     0             RYCHGM
     C                   Z-ADD     0             RYCHGT
     C                   Z-ADD     0             RYCHGB
     C                   Z-ADD     0             RYCHGL
     C                   Z-ADD     0             RYCHGA
     C                   Z-ADD     0             RYCHGQ
     C                   Z-ADD     0             RYCHGX
     C                   Z-ADD     0             RYCHGY
     C                   Z-ADD     0             RYACCH
     C                   MOVE      #DNDPA        RYNBDP
     C                   ADD       1             EXTCTR            5 0
     C                   MOVEL     #1CYCD        CCY2              3
     C     #MODE         IFEQ      'U'
     C     #MODE         OREQ      'u'
      *
      ** Update file RECCYDXC
      *
     C                   WRITE     RECCYDD0
     C                   ENDIF
     C                   ENDIF
      *
      ** Update file trailer file RECCYDZ
      *
     C     #MODE         IFEQ      'U'
     C     #MODE         OREQ      'u'
     C     *IN60         IFEQ      '1'
     C     1             SETLL     RECCYZF
     C                   READ      RECCYZF                                90
     C     *IN90         IFEQ      '0'
     C                   Z-ADD     FNATN         TNLU
     C                   ADD       1             NR1
     C                   ADD       1             NR3
     C                   UPDATE    RECCYZF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     *IN20         IFEQ      '1'
     C     *IN21         OREQ      '1'
     C                   ADD       1             LINCTR           16 0
     C     LINCTR        SUB       20            LINRST           16 0
     C     LINRST        IFGT      0
     C                   Z-ADD     0             LINCTR
     C                   ADD       1             PAGCTR
     C                   MOVE      PAGCTR        PAGEN
     C                   EXCEPT    HEADP1
     C                   EXCEPT    HEADP2
     C                   EXCEPT    HEADP3
     C                   EXCEPT    TITP1
     C                   EXCEPT    TITP2
     C                   ENDIF
     C                   EXCEPT    DETAILP1
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRINIT   - Initialisation                                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Define work field Retail Banking
      *
     C                   MOVEL     *BLANK        WURTBN            1
      *
      ** Define work field Run day number
      *
     C                   Z-ADD     *ZERO         WURDNB            5 0
      *
      ** Define work field Set Up Complete
      *
     C                   MOVEL     *BLANK        WUSUC             1
      *
      ** Define work field Midas Run Date
      *
     C                   MOVEL     *BLANK        WUMRDT            7
      *
      ** Define work field Date format flag
      *
     C                   MOVEL     *BLANK        WUDFF             1
      *
      ** Define work field Multi-branching Indicator
      *
     C                   MOVEL     *BLANK        WUMBIN            1
      *
      ** Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
      *
      ** Access SDBANKPD for Bank report Title
      *
     C                   READ      SDBANKPD                               92
     C     *IN92         IFEQ      '0'
     C                   MOVE      BJURPT        RTITLE           53
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE           10
     C                   MOVEL     '001'         DBASE             3
     C                   MOVEL     @OPTN         DBKEY             7
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
     C     RUN           IFEQ      *BLANKS
     C                   MOVE      'Y'           RUN               1
     C                   DUMP
     C                   ENDIF
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
     OSMU00293AUE            HEAD1             1
     O                                           13 'PAGE'
     O                       PAGEN         Z     18
     O                                            8 'SMU00293'
     O                       RTITLE             100
     O          E            HEAD2       3  2
     O                                           60 'SMU00293 List of Currency '
     O                                         +  0 'Records missing in files '
     O                                         +  0 'RECCYD and RECCYDXC'
     O          E            HEAD3          2
     O               50                          25 'Report Mode'
     O              N50                          25 'Update Mode'
     O          E            AUDIT1         2
     O               50                          40 'Total No. of Currencies '
     O                                         +  0 'to be added to RECCYD : '
     O              N50                          46 'Total No. of Currencies '
     O                                         +  0 'added to RECCYD : '
     O                       RECTR         Z     75
     O          E            AUDIT2         2
     O               50                          40 'Total No. of Currencies '
     O                                         +  0 'to be added to RECCYDXC : '
     O              N50                          46 'Total No. of Currencies '
     O                                         +  0 'added to RECCYDXC : '
     O                       EXTCTR        Z     75
     O          E            TRAILER        2
     O                                           77 '*** END OF REPORT ***'
     OSMU00293P1E            HEADP1            1
     O                                           13 'PAGE'
     O                       PAGEN         Z     18
     O                                            8 'SMU00293'
     O                       RTITLE             100
     O          E            HEADP2      3  2
     O                                           60 'SMU00293 List of Currency '
     O                                         +  0 'Records missing in files '
     O                                         +  0 'RECCYD and RECCYDXC'
     O          E            HEADP3         2
     O               50                          25 'Report Mode'
     O              N50                          25 'Update Mode'
     O          E            TITP1          2
     O               50                          40 'Currency to be Added'
     O              N50                          40 'Added Currency'
     O          E            TITP2          2
     O                                           30 'RECCYD'
     O                                           50 'RECCYDXC'
     O          E            DETAILP1       2
     O                       CCY1                27
     O                       CCY2                47
     O          E            NOREPORT       2
     O                                           78 '* NO DETAILS TO REPORT *'
     O          E            TRAILERP1      2
     O                                           77 '*** END OF REPORT ***'
