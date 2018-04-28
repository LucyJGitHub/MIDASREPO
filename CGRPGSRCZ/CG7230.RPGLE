     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Extract Lending Capitalised Accounts')           *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7230 - Interest Scale Lending Capitalised accounts extract *
      *                                                               *
      *  Function: Reads from HISTSHP and writes the Qualifying       *
      *            Lending details to CGISDRPD file                   *
      *                                                               *
      *  Called By: CGC7230 - CG Interest Scale Lending extract       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      *  Prev Amend No. AR1095876          Date 30Sep13               *
      *                 CLE148             Date 23Jul12               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Indicators
      *  ==========
      *  89  General chain fail error
      *  90  Error in called program
      *
      *****************************************************************
      ** Historic loans interest capitalisation records
     FHISTSHP   IP   E           K DISK
      ** Loans file by loan reference
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Account keys file
     FACKEY     IF   E           K DISK
 
      ** Account master file Interest Scale Extension file
     FGLACNTL3  IF   E           K DISK
 
      ** Interest Scale Daily Report Work file
     FCGISDRL0  UF A E           K DISK
 
      ** Copyright statement array
     D CPY             S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Working variables
     D @RTCD           S              7A
     D ##RTCD          S              7A
     D @OPTN           S              7A
     D ##OPTN          S              7A
     D @SARD           S              6A
 
      ** Parameters for called programs
     D PINFD           S              5  0
     D PFRLS           S              5A
     D PRTCD           S              7A
     D PBRCA           S              3A
     D PCNUM           S              6A
     D PCCY            S              3A
     D PACOD           S             10  0
     D PACSQ           S              2  0
     D PREFN           S             10A
     D PREFT           S              1A
     D*PLNRF****       S              6  0                                                    CLE148
     D PLNRF           S              6A                                                      CLE148
     D*PDLNO****       S              6  0                                                    CLE148
     D PDLNO           S              6A                                                      CLE148
     D PINTD           S              5  0
     D PINTA           S              9A
     D PADDI           S              1A
     D PRDFC           S              1A
     D @FIRST          S              3A
     D RTCD            S              7A
     D OPTN            S              7A
     D @CUST           S             10A
     D KYST            S              7A
      ** Data structure to define the account key
     D WACKEY          DS
     D  H1LTYP                 1      2
     D  @TYPE                  3      3    INZ('R')
     D  H1SUTP                 4      5
     D  @FILL                  6      6    INZ(' ')
     D  RCSI                   7      7
     D  @REST                  6     10    INZ('    C')
     D  H1CLAS                11     14
      ** Data structure to allow the interest to be passed as alpha
     D @DINTA          DS
     D  @DINTN                 1      9P 0
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
 
      ** Redefine the fields in the historic deals file
     IHISTSHPF
     I              BRCA                        H1BRCA
     I              CNUM                        H1CNUM
     I              LNRF                        H1LNRF
     I              VDAT                        H1VDAT
     I              CCY                         H1CCY
     I              INTA                        H1INTA
     I              LTYP                        H1LTYP
     I              SUTP                        H1SUTP
     I              CLAS                        H1CLAS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Main routine - Main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  SRFirst  - Initial houskeeping
      *            :  SRDetail - Detail processing
      *            :  SRLast   - Final housekeeping
      *
      *****************************************************************
 
      ** If not already done perform initial housekeeping
     C     @FIRST        IFNE      'YES'
     C                   EXSR      SRFIRST
     C                   ENDIF
 
      ** Detail processing
     C                   EXSR      SRDETAIL
 
      ** Perform the final housekeeping
     CLR                 EXSR      SRLAST
 
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
     C     SRFIRST       BEGSR
 
      ** Non-executable code, KLISTs, PLISTs, etc.
      ** Key list for the account master interest scale extension file
     C     ACCTKY        KLIST
     C                   KFLD                    Z5CNUM
     C                   KFLD                    Z5CCY
     C                   KFLD                    Z5ACOD
     C                   KFLD                    Z5ACSQ
     C                   KFLD                    Z5BRCA
 
      ** Key list for extracted interest scale details file
     C     CGDRKY        KLIST
     C                   KFLD                    Z5BRCA
     C                   KFLD                    Z5CNUM
     C                   KFLD                    Z5CCY
     C                   KFLD                    Z5ACOD
     C                   KFLD                    Z5ACSQ
     C                   KFLD                    Z5REFN
     C                   KFLD                    Z5REFT
     C                   KFLD                    Z5INCD
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Access bank details via an access program
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
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
     C                   CALL      'CGC7240'
     C                   PARM                    H1BRCA
     C                   PARM                    H1CNUM
     C                   PARM                    H1LNRF
     C                   PARM                    H1VDAT
     C                   PARM                    VDAT
     C                   PARM                    PINFD
     C                   PARM      'FIRST'       PFRLS
     C                   PARM                    PRTCD
 
      ** Call the interest extract program to open the files
     C                   CALL      'CGC7250'
     C                   PARM                    PBRCA
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PREFN
     C                   PARM                    PREFT
     C                   PARM                    PDLNO
     C                   PARM                    PINFD
     C                   PARM                    PINTD
     C                   PARM                    PINTA
     C                   PARM                    PADDI
     C                   PARM                    PRDFC
     C                   PARM      'FIRST'       PFRLS
     C                   PARM                    PRTCD
 
      ** Set the flag to say the routine has been run
     C                   MOVE      'YES'         @FIRST
 
     C                   ENDSR
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
     C     SRDETAIL      BEGSR
 
      ** Chain to loans file for the recourse indicator
     C     H1LNRF        CHAIN     CLOANCLF                           89
 
      ** If the loan is not found ignore
     C     *IN89         IFEQ      *OFF
 
      ** Chain to the account keys file for the account code
     C     WACKEY        CHAIN     ACKEYALF                           89
 
      ** If the account key is not found ignore
     C     *IN89         IFEQ      *OFF
 
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
     C                   Z-ADD     ACD1          Z5ACOD
     C                   Z-ADD     LASQ          Z5ACSQ
     C**********         Z-ADD     H1LNRF        Z5REFN                                       CLE148
     C                   MOVE      H1LNRF        Z5REFN                                       CLE148
 
      ** Set reference type flag to L for a lending record
     C                   MOVE      'L'           Z5REFT
 
      ** Set the capitalisation date as the value date
     C                   Z-ADD     H1VDAT        Z5INCD
 
      ** Check if the record is already on the extract file
     C     CGDRKY        CHAIN     CGISDRD0                           89
 
      ** If the record does not exist add it, otherwise ignore
     C     *IN89         IFEQ      *ON
 
      ** Find the interest from date
     C                   CALL      'CGC7240'
     C                   PARM                    H1BRCA
     C                   PARM                    H1CNUM
     C                   PARM                    H1LNRF
     C                   PARM                    H1VDAT
     C                   PARM                    VDAT
     C                   PARM                    PINFD
     C                   PARM      *BLANKS       PFRLS
     C                   PARM                    PRTCD
 
     C                   Z-ADD     PINFD         Z5INFD
     C                   MOVE      BBCNA1        Z5CNA1
     C                   MOVE      BBCNA2        Z5CNA2
     C                   MOVE      BBCNA3        Z5CNA3
     C                   MOVE      BBCNA4        Z5CNA4
     C                   MOVE      BBCRTN        Z5CRTN
     C                   MOVE      BBCSID        Z5CSID
     C                   Z-ADD     BJRDNB        Z5RNDB
     C                   Z-ADD     0             Z5TOCI
     C                   Z-SUB     H1INTA        Z5TODI
     C                   Z-SUB     H1INTA        Z5NETI
 
      ** Chain to the account master Interest Scale extension file
     C     ACCTKY        CHAIN     GLACNTL3                           89
 
      ** If the record is not found or the interest scale flag is not set
      ** to Y do not extract the record
     C     *IN89         IFEQ      *OFF
     C     F1ZINS        ANDEQ     'Y'
     C                   MOVE      Z5BRCA        PBRCA
     C                   MOVEL     Z5CNUM        PCNUM
     C                   MOVE      Z5CCY         PCCY
     C                   Z-ADD     Z5ACOD        PACOD
     C                   Z-ADD     Z5ACSQ        PACSQ
     C                   MOVE      Z5REFN        PREFN
     C                   MOVE      Z5REFT        PREFT
     C**********         Z-ADD     H1LNRF        PLNRF                                        CLE148
     C                   MOVE      H1LNRF        PLNRF                                        CLE148
     C                   Z-ADD     Z5INFD        PINFD
     C                   Z-ADD     Z5INCD        PINTD
     C                   Z-ADD     Z5NETI        @DINTN
     C                   MOVE      ADDI          PADDI
     C                   MOVE      RDFC          PRDFC
     C                   MOVE      @DINTA        PINTA
     C                   MOVE      *BLANKS       PFRLS
     C                   MOVE      *BLANKS       PRTCD
 
     C                   CALL      'CGC7250'
     C                   PARM                    PBRCA
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PREFN
     C                   PARM                    PREFT
     C                   PARM                    PLNRF
     C                   PARM                    PINFD
     C                   PARM                    PINTD
     C                   PARM                    PINTA
     C                   PARM                    PADDI
     C                   PARM                    PRDFC
     C                   PARM                    PFRLS
     C                   PARM                    PRTCD
     C                   MOVE      PINTA         @DINTA
     C                   MOVE      *BLANKS       Z5ERRI
     C                   Z-ADD     0             Z5ERRC
 
      ** Write a record to the interest scale daily report work file
     C                   WRITE     CGISDRD0
     C                   ENDIF
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
     C     SRLAST        BEGSR
 
      ** Call the interest from date program to open the files
     C                   CALL      'CGC7240'
     C                   PARM                    H1BRCA
     C                   PARM                    H1CNUM
     C                   PARM                    H1LNRF
     C                   PARM                    H1VDAT
     C                   PARM                    VDAT
     C                   PARM                    PINFD
     C                   PARM      'LAST '       PFRLS
     C                   PARM                    PRTCD
 
      ** Call the interest extract program to close the files
     C                   CALL      'CGC7250'
     C                   PARM                    PBRCA
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PREFN
     C                   PARM                    PREFT
     C                   PARM                    PDLNO
     C                   PARM                    PINFD
     C                   PARM                    PINTD
     C                   PARM                    PINTA
     C                   PARM                    PADDI
     C                   PARM                    PRDFC
     C                   PARM      'LAST '       PFRLS
     C                   PARM                    PRTCD
 
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
      *
     C                   ENDSR
** CPY
(c) Misys International Banking Systems Ltd. 2011
