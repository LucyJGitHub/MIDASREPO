     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Dealing Extract')              *
      ******************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7200 - Interest Scale Dealing Extract                      *
      *                                                               *
      *  Called By: CGC7200 - Interest Scale Dealing Extract          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 CLE148             Date 23Jul12               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CRE095 - Rate fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      /EJECT
      *****************************************************************
      *                                                               *
      *  Indicators                                                   *
      *  ==========                                                   *
      *  89  General chain fail error                                 *
      *  90  Error in called program                                  *
      *                                                               *
      *****************************************************************
 
      ** Historic deals interest capitalisation records
     FHISTSAA   IP   E           K DISK
 
      ** Account keys file
     FACKEY     IF   E           K DISK
 
      ** Deals file by deal number
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
 
      ** GL Account Extension file
     FGLACNTL3  IF   E           K DISK
 
      ** Interest Scale daily report work file
     FCGISDRL0  UF A E           K DISK
 
      ** Working variables
     D RTCD            S              7A
     D OPTN            S              7A
 
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
     D PDLNO           S              6  0
     D PINTD           S              5  0
     D PINTA           S              9A
     D PADDI           S              1A
     D PRDFC           S              1A
     D @FIRST          S              3A
     D @CUST           S             10A
     D KYST            S              7A
 
      ** Data structure to define the account key
     D @ACKEY          DS
     D  H1DTYP                 1      2
     D  TYPE                   3      3    INZ('I')
     D  H1DLST                 4      5
     D  REST                   6     10    INZ('    C')
     D  H1CLAS                11     14
 
      ** Data structure to allow the interest to be passed as alpha
     D DINTA           DS
     D  DINTN                  1      9P 0
 
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
 
      ** Data structure for definition of long retrieval data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **  Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Redefine the fields in the Historic Deals file
     IHISTSAAF
     I              CNUM                        H1CNUM
     I              EDAT                        H1EDAT
     I              DLNO                        H1DLNO
     I              PCPL                        H1PCPL
     I              DTYP                        H1DTYP
     I              DLST                        H1DLST
     I              BRCA                        H1BRCA
     I              CCY                         H1CCY
     I              EAMT                        H1EAMT
     I              ICBS                        H1ICBS
     I              CLAS                        H1CLAS
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Main routine - main controling subroutine                    *
      *                                                               *
      *  Called by :  none                                            *
      *  Calls     :  First  - Initial houskeeping                    *
      *            :  Detail - Detail processing                      *
      *            :  last   - Final housekeeping                     *
      *                                                               *
      *****************************************************************
      ** If not already done perform initial housekeeping
      *
     C                   IF        @FIRST <> 'YES'
     C                   EXSR      FIRST
     C                   ENDIF
 
      ** Detail processing
     C                   EXSR      DETAIL
 
      ** Perform the final housekeeping
     CLR                 EXSR      LAST
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Non-executable code, KLISTs, PLISTs, etc.                    *
      *                                                               *
      *****************************************************************
 
      ** Key list for the account master Interest Scale extention file
     C     ACCTKY        KLIST
     C                   KFLD                    Z5CNUM
     C                   KFLD                    Z5CCY
     C                   KFLD                    Z5ACOD
     C                   KFLD                    Z5ACSQ
     C                   KFLD                    Z5BRCA
 
      ** Key list for extracted Interest Scale details file
     C     DRKEY         KLIST
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
      *                                                               *
      *  FIRST SR. - Initial processing                               *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  CGC7210, CGC7220                                *
      *                                                               *
      *****************************************************************
     C     FIRST         BEGSR
 
      ** Access bank details via an access program
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     RTCD
     C                   PARM      '*FIRST '     OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Error, record not found
     C                   IF        RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     PGM           DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call the interest from date program to open the files
     C                   CALL      'CGC7210'
     C                   PARM                    H1DLNO
     C                   PARM                    H1EDAT
     C                   PARM                    VDAT
     C                   PARM                    PINFD
     C                   PARM      'FIRST'       PFRLS
     C                   PARM                    PRTCD
 
      ** Call the interest extract program to open the files
     C                   CALL      'CGC7220'
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
     C                   EVAL      @FIRST = 'YES'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETAIl SR. - Detail processing                               *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     DETAIL        BEGSR
 
      ** Chain to the account keys file for the account code
     C     @ACKEY        CHAIN     ACKEYALF                           89
 
      ** If the account key is not found ignore
     C                   IF        *IN89 = *OFF
 
      ** Chain to the deals file for the account sequence number
     C     H1DLNO        CHAIN     DEALSDCF                           89
 
      ** Find the customer details
     C                   MOVE      *BLANKS       RTCD
     C                   MOVEL     '*KEY   '     OPTN
     C                   MOVE      *BLANKS       @CUST
     C                   MOVEL     H1CNUM        @CUST
     C                   MOVE      *BLANKS       KYST
 
      ** Check for customer number or shortname
     C                   CALL      'AOCUSTR0'                           90
     C                   PARM                    RTCD
     C                   PARM                    OPTN
     C                   PARM                    @CUST
     C                   PARM                    KYST
     C     SDCUST        PARM      *BLANKS       DSSDY
 
      ** If problem calling the program or not found
     C                   IF        *IN90 = *ON OR
     C                             RTCD <> *BLANKS
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
 
      ** If the deal type is a taking use account code four
     C                   IF        H1DTYP = 'CD' OR
     C                             H1DTYP = 'CI' OR
     C                             H1DTYP = 'IT' OR
     C                             H1DTYP = 'TD'
     C                   Z-ADD     ACD4          Z5ACOD
 
      ** If the deal type is a placing use account code one
     C                   ELSE
     C                   Z-ADD     ACD1          Z5ACOD
     C                   ENDIF
     C                   Z-ADD     CDAS          Z5ACSQ
     C**********         Z-ADD     H1DLNO        Z5REFN                                       CLE148
     C                   MOVE      H1DLNO        Z5REFN                                       CLE148
 
      ** Set reference type flag to D for a dealing record
     C                   MOVE      'D'           Z5REFT
 
      ** Set the capitalisation date as the event date
     C                   Z-ADD     H1EDAT        Z5INCD
 
      ** Check if the record is already on the extract file
     C     DRKEY         CHAIN     CGISDRD0                           89
 
      ** If the record does not exist add it otherwise ignore
     C     *IN89         IFEQ      *ON
 
      ** Find the interest from date
     C                   CALL      'CGC7210'
     C                   PARM                    H1DLNO
     C                   PARM                    H1EDAT
     C                   PARM                    VDAT
     C                   PARM                    PINFD
     C                   PARM      *BLANKS       PFRLS
     C                   PARM                    PRTCD
      *
     C                   Z-ADD     PINFD         Z5INFD
     C                   MOVE      BBCNA1        Z5CNA1
     C                   MOVE      BBCNA2        Z5CNA2
     C                   MOVE      BBCNA3        Z5CNA3
     C                   MOVE      BBCNA4        Z5CNA4
     C                   MOVE      BBCRTN        Z5CRTN
     C                   MOVE      BBCSID        Z5CSID
     C                   Z-ADD     BJRDNB        Z5RNDB
 
      ** If the deal type is a taking credit interest
     C                   IF        H1DTYP = 'CD' OR
     C                             H1DTYP = 'CI' OR
     C                             H1DTYP = 'IT' OR
     C                             H1DTYP = 'TD'
     C                   Z-ADD     H1EAMT        Z5TOCI
     C                   Z-ADD     0             Z5TODI
     C                   Z-ADD     H1EAMT        Z5NETI
 
      ** If the deal type is a placing debit interest
     C                   ELSE
     C                   Z-ADD     0             Z5TOCI
     C                   Z-SUB     H1EAMT        Z5TODI
     C                   Z-SUB     H1EAMT        Z5NETI
     C                   ENDIF
 
      ** Chain to GL Account Extention for the interest scale flag
     C     ACCTKY        CHAIN     GLACNTL3                           89
 
      ** If the record is not found or the Interest Scale flag is not set
      ** to Y do not extract the record
     C                   IF        *IN89 = *OFF AND
     C                             F1ZINS = 'Y'
     C                   MOVE      Z5BRCA        PBRCA
     C                   MOVEL     Z5CNUM        PCNUM
     C                   MOVE      Z5CCY         PCCY
     C                   Z-ADD     Z5ACOD        PACOD
     C                   Z-ADD     Z5ACSQ        PACSQ
     C                   MOVE      Z5REFN        PREFN
     C                   MOVE      Z5REFT        PREFT
     C                   Z-ADD     H1DLNO        PDLNO
     C                   Z-ADD     Z5INFD        PINFD
     C                   Z-ADD     Z5INCD        PINTD
     C                   Z-ADD     Z5NETI        DINTN
     C                   MOVE      DINTA         PINTA
     C                   MOVE      JFLID         PADDI
     C                   MOVE      JRDFC         PRDFC
     C                   MOVE      *BLANKS       PFRLS
     C                   MOVE      *BLANKS       PRTCD
      *
     C                   CALL      'CGC7220'
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
     C                   PARM                    PFRLS
     C                   PARM                    PRTCD
      *
     C                   MOVE      PINTA         DINTA
     C                   MOVE      *BLANKS       Z5ERRI
     C                   Z-ADD     0             Z5ERRC
 
      ** Write a record to the Interest Scale daily report work file
     C                   WRITE     CGISDRD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LAST SR. - Final processing                                  *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR
      *
      ** Call the interest from date program to open the files
      *
     C                   CALL      'CGC7210'
     C                   PARM                    H1DLNO
     C                   PARM                    H1EDAT
     C                   PARM                    VDAT
     C                   PARM                    PINFD
     C                   PARM      'LAST '       PFRLS
     C                   PARM                    PRTCD
 
      ** Call the interest extract program to close the files
     C                   CALL      'CGC7220'
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
     C                   EVAL      @FIRST = 'YES'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - File exception/ error subroutine                     *
      *                                                               *
      * Called by: Main routine - Main controlling subroutine         *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** If a database error set on U8
     C                   IF        DBFILE <> *BLANK
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
