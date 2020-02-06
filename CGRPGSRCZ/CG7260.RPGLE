     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Extract')                      *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7260 - CG Interest Scale Retail extract                    *
      *                                                               *
      *  Function: Extracts and writes the interest scale details to  *
      *            work file CGISDRPD                                 *
      *                                                               *
      *  Called By: CGC7260 - CG Interest Scale Retail extract        *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD028899           Date 09Dec16               *
      *                 CRE095             Date 25Apr14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 CLE148             Date 23Jul12               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD028899 - Skip closed accounts.                             *
      *           - Applied for MD043097.
      *  CRE095 - Rate fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *****************************************************************
      *
      *  Indicators
      *
      *  89  General chain fail error
      *
      *****************************************************************
 
      ** Historic retail interest capitalisation records
     FREHISPS   IP   E           K DISK
 
      ** Account master file
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
 
      ** Account master file interest scale extension file
     FGLACNTL3  IF   E           K DISK
 
      ** Interest Scale daily report work file
     FCGISDRL0  UF A E           K DISK
 
      ** Working variables
     D @RTCD           S              7A
     D RTCD            S              7A
     D @OPTN           S              7A
     D OPTN            S              7A
      ** Parameters for called programs
     D @PINFD          S              5  0
     D @PINTD          S              5  0
     D @PDINA          S              9A
     D @PCINA          S              9A
     D @PFRLS          S              5A
     D @PRTCD          S              7A
     D @PBRCA          S              3A
     D @PCNUM          S              6A
     D @PCCY           S              3A
     D @PACOD          S             10  0
     D @PACSQ          S              2  0
     D @PREFN          S             10A
     D @PREFT          S              1A
     D @FIRST          S              3A
     D @CUST           S             10A
     D KYST            S              7A
      ** Data structure to allow the dr interest to be passed as alpha
     D @DDINA          DS
     D  @DDINN                 1      9P 0
 
      ** Data structure to allow the cr interest to be passed as alpha
     D @DCINA          DS
     D  @DCINN                 1      9P 0
 
      ** Data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program status data structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** Data structure for definition of customer master file fields
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Data structure for definition of bank specific details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** Redefine the fields in the historic file
     IREHISPSF
     I              BRCA                        H1BRCA
     I              CNUM                        H1CNUM
     I              CCY                         H1CCY
     I              ACOD                        H1ACOD
     I              ACSQ                        H1ACSQ
     I              HISD                        H1HISD
     I              DRIP                        H1DRIP
     I              DRIS                        H1DRIS
     I              CRIP                        H1CRIP
     I              CRIS                        H1CRIS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Main routine - main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  First  - Initial houskeeping
      *            :  Detail - Detail processing
      *            :  Last   - Final housekeeping
      *
      *****************************************************************
     C     @FIRST        IFNE      'YES'
     C                   EXSR      FIRST
     C                   ENDIF
 
      ** Detail processing
     C                   EXSR      DETAIL
 
      ** Perform the final housekeeping
     CLR                 EXSR      LAST
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Non-executable code, KLISTs, PLISTs, etc.
      *
      *  Key list for the account master file
      *
     C     ACCTKY        KLIST
     C                   KFLD                    H1CNUM
     C                   KFLD                    H1CCY
     C                   KFLD                    H1ACOD
     C                   KFLD                    H1ACSQ
     C                   KFLD                    H1BRCA
 
      ** Key list for the account master interest scale extension file
     C     GLACKY        KLIST
     C                   KFLD                    H1CNUM
     C                   KFLD                    H1CCY
     C                   KFLD                    H1ACOD
     C                   KFLD                    H1ACSQ
     C                   KFLD                    H1BRCA
 
      ** Key list for extracted interest scale details file
     C     @DRKEY        KLIST
     C                   KFLD                    Z5BRCA
     C                   KFLD                    Z5CNUM
     C                   KFLD                    Z5CCY
     C                   KFLD                    Z5ACOD
     C                   KFLD                    Z5ACSQ
     C                   KFLD                    Z5REFN
     C                   KFLD                    Z5REFT
     C                   KFLD                    Z5INCD
 
     C     *DTAARA       DEFINE                  LDA
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  FIRST SR. - Initial processing
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     FIRST         BEGSR
 
      ** Access bank details via an access program
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Error, record not found
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     PGM           DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call the interest from date program to open the files
     C                   CALL      'CGC7270'
     C                   PARM                    H1BRCA
     C                   PARM                    H1CNUM
     C                   PARM                    H1CCY
     C                   PARM                    H1ACOD
     C                   PARM                    H1ACSQ
     C                   PARM                    H1HISD
     C                   PARM                    DACO
     C                   PARM                    @PINFD
     C                   PARM      'FIRST'       @PFRLS
     C                   PARM                    @PRTCD
 
      ** Call the interest extract program to open the files
     C                   CALL      'CGC7280'
     C                   PARM                    @PBRCA
     C                   PARM                    @PCNUM
     C                   PARM                    @PCCY
     C                   PARM                    @PACOD
     C                   PARM                    @PACSQ
     C                   PARM                    @PREFN
     C                   PARM                    @PREFT
     C                   PARM                    @PINFD
     C                   PARM                    @PINTD
     C                   PARM                    @PDINA
     C                   PARM                    @PCINA
     C                   PARM      'FIRST'       @PFRLS
     C                   PARM                    @PRTCD
 
      ** Set the flag to say the routine has been run
     C                   MOVE      'YES'         @FIRST
      *
     C                   ENDSR
 
      ** End of initial housekeeping routine
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  DETAIl SR. - Detail processing
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     DETAIL        BEGSR
 
      ** Chain to the account master file for the retail account number
     C     ACCTKY        CHAIN     ACCNTABF                           89
 
      ** If the account is not found ignore
     C     *IN89         IFEQ      *OFF
     C     RECI          ANDNE     'C'                                                      MD028899
     C     ACST          ANDNE     'C'                                                      MD028899
 
      ** Ignore if interest frequency between debit and credit
     C     DRIF          ANDEQ     CRIF
     C     DRDY          ANDEQ     CRDY
     C     LDID          ANDEQ     LCID
 
      ** Find the customer details
     C                   MOVE      *BLANKS       RTCD
     C                   MOVEL     '*KEY   '     OPTN
     C                   MOVE      *BLANKS       @CUST
     C                   MOVEL     H1CNUM        @CUST
     C                   MOVE      *BLANKS       KYST
 
      ** Check for customer number or shortname
     C                   CALL      'AOCUSTR1'                           90
     C                   PARM                    RTCD
     C                   PARM                    OPTN
     C                   PARM                    @CUST
     C                   PARM                    KYST
     C     SDCUST        PARM      SDCUST        DSLDY
 
      ** If problem calling the program or not found
     C     *IN90         IFEQ      *ON
     C     RTCD          ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     PGM           DBPGM
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     @CUST         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Load the file fields
     C                   MOVE      H1BRCA        Z5BRCA
     C                   MOVEL     H1CNUM        Z5CNUM
     C                   MOVE      H1CCY         Z5CCY
     C                   Z-ADD     H1ACOD        Z5ACOD
     C                   Z-ADD     H1ACSQ        Z5ACSQ
     C**********         Z-ADD     ACNO          Z5REFN                                       CLE148
     C                   MOVE      ACNO          Z5REFN                                       CLE148
 
      ** Set reference type flag to R for a retail record
     C                   MOVE      'R'           Z5REFT
 
      ** Set the capitalisation date as the event date
     C                   Z-ADD     H1HISD        Z5INCD
 
      ** Check if the record is already on the extract file
     C     @DRKEY        CHAIN     CGISDRD0                           89
 
      ** If the record does not exist add it otherwise ignore
     C     *IN89         IFEQ      *ON
 
      ** Find the interest from date
     C                   CALL      'CGC7270'
     C                   PARM                    H1BRCA
     C                   PARM                    H1CNUM
     C                   PARM                    H1CCY
     C                   PARM                    H1ACOD
     C                   PARM                    H1ACSQ
     C                   PARM                    H1HISD
     C                   PARM                    DACO
     C                   PARM                    @PINFD
     C                   PARM      *BLANKS       @PFRLS
     C                   PARM                    @PRTCD
 
     C                   Z-ADD     @PINFD        Z5INFD
     C                   MOVE      BBCNA1        Z5CNA1
     C                   MOVE      BBCNA2        Z5CNA2
     C                   MOVE      BBCNA3        Z5CNA3
     C                   MOVE      BBCNA4        Z5CNA4
     C                   MOVE      BBCRTN        Z5CRTN
     C                   MOVE      BBCSID        Z5CSID
     C                   Z-ADD     BJRDNB        Z5RNDB
     C                   Z-ADD     H1CRIP        Z5TOCI
     C                   Z-SUB     H1DRIP        Z5TODI
     C     H1CRIP        SUB       H1DRIP        Z5NETI
 
      ** Chain to the account master interest scale extension file
     C     GLACKY        CHAIN     GLACNTL3                           89
 
      ** If the record is not found or the interest scale flag is not set
      ** to Y do not extract the record
     C     *IN89         IFEQ      *OFF
     C     F1ZINS        ANDEQ     'Y'
     C                   MOVE      Z5BRCA        @PBRCA
     C                   MOVEL     Z5CNUM        @PCNUM
     C                   MOVE      Z5CCY         @PCCY
     C                   Z-ADD     Z5ACOD        @PACOD
     C                   Z-ADD     Z5ACSQ        @PACSQ
     C                   MOVE      Z5REFN        @PREFN
     C                   MOVE      Z5REFT        @PREFT
     C                   Z-ADD     Z5INFD        @PINFD
     C                   Z-ADD     Z5INCD        @PINTD
     C                   Z-ADD     Z5TODI        @DDINN
     C                   MOVE      @DDINA        @PDINA
     C                   Z-ADD     Z5TOCI        @DCINN
     C                   MOVE      @DCINA        @PCINA
     C                   MOVE      *BLANKS       @PFRLS
     C                   MOVE      *BLANKS       @PRTCD
     C                   CALL      'CGC7280'
     C                   PARM                    @PBRCA
     C                   PARM                    @PCNUM
     C                   PARM                    @PCCY
     C                   PARM                    @PACOD
     C                   PARM                    @PACSQ
     C                   PARM                    @PREFN
     C                   PARM                    @PREFT
     C                   PARM                    @PINFD
     C                   PARM                    @PINTD
     C                   PARM                    @PDINA
     C                   PARM                    @PCINA
     C                   PARM                    @PFRLS
     C                   PARM                    @PRTCD
     C                   MOVE      @PDINA        @DDINA
     C                   MOVE      @PCINA        @DCINA
 
      ** If the calculated net interest is not within the tolerence
      ** of the posted net interest mark as error
     C     @DDINN        IFNE      Z5TODI
     C     @DCINN        ORNE      Z5TOCI
     C                   MOVE      'Y'           Z5ERRI
     C                   Z-ADD     1             Z5ERRC
     C                   ELSE
     C                   MOVE      *BLANKS       Z5ERRI
     C                   Z-ADD     0             Z5ERRC
     C                   ENDIF
 
      ** Write a record to the interest scale daily report work file
     C                   WRITE     CGISDRD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  LAST SR. - Final processing
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     LAST          BEGSR
 
      ** Call the interest from date program to open the files
     C                   CALL      'CGC7270'
     C                   PARM                    H1BRCA
     C                   PARM                    H1CNUM
     C                   PARM                    H1CCY
     C                   PARM                    H1ACOD
     C                   PARM                    H1ACSQ
     C                   PARM                    H1HISD
     C                   PARM                    DACO
     C                   PARM                    @PINFD
     C                   PARM      'LAST '       @PFRLS
     C                   PARM                    @PRTCD
 
      ** Call the interest extract program to close the files
     C                   CALL      'CGC7280'
     C                   PARM                    @PBRCA
     C                   PARM                    @PCNUM
     C                   PARM                    @PCCY
     C                   PARM                    @PACOD
     C                   PARM                    @PACSQ
     C                   PARM                    @PREFN
     C                   PARM                    @PREFT
     C                   PARM                    @PINFD
     C                   PARM                    @PINTD
     C                   PARM                    @PDINA
     C                   PARM                    @PCINA
     C                   PARM      'LAST '       @PFRLS
     C                   PARM                    @PRTCD
 
      ** Set the flag to say the routine has been run
     C                   MOVE      'YES'         @FIRST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * *PSSR  - File exception/ error subroutine
      *
      * Called by: Main routine - Main controlling subroutine
      * Calls:     None
      *
      *
      *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** If a database error set on u8
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
