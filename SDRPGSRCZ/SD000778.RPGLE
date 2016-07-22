     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Ctry of Tax Set up for Priv Ind & Joint')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000778 - SD Country of Tax Set up for Private Individuals  *
      *             and Joint Accounts - Take On                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR762398           Date 27May11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22529           Date 09Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR762398 - CTCM error in CUSD when the customer is selected  *
      *             via Edit or Enquire mode                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************

      ** SD Country of Tax Codes - Retrieve
     FSDCTTXL2  IF   E           K DISK    INFSR(*PSSR)

      ** SD Additional Customer Details
     F*SDACUSL1  IF   E           K DISK    INFSR(*PSSR)                                      232543
     FSDACUSL1  UF   E           K DISK    INFSR(*PSSR)                                       232543

      ** SD Customer Details by Country of Tax - Retrieve Index
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACTXD0:SDACTXD1)

      ** SD Customer Details by Country of Tax
     FSDACTXPD  O    E           K DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Data Structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Customer Number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ***Second*DS*for access programs, long data structure                                   232543
     D*DSSDY****     E DS                  EXTNAME(DSSDY)                                     232543
      ** Long data structure                                                                  232543
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     232543

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A
     D PKey            S              7A
     D PCustNo         S             10A
     D PSard           S              6A

      ** Key Fields
     D KCust           S              6A
     D KCctx           S              2A

     D WPrevCTRT       S              2A
     D CSC011          S              1A
     D WUpdREPI        S              1A                                                      232543

      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************

      ** Set file pointer to first record and do initial read.

     C     *LOVAL        SETLL     SDACUSL1
     C                   READ      SDACUSL1

     C                   DOW       NOT %EOF(SDACUSL1)

     C                   IF        E5JATP = 'I' or E5JATP = 'Y'
     C                   EXSR      SRProcess
     C                   ENDIF

     C                   READ      SDACUSL1
     C                   ENDDO

     C                   EVAL      *INLR = *ON
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRProcess - Process Private Individual customers             *
      *                                                              *
      ****************************************************************
     C     SRProcess     BEGSR

     C                   EVAL      WUpdREPI = 'N'                                             232543
      ** Check if the customer is a Private Banking Customer

     C**********         CALL      'AOCUSTR0'                                                 232543
     C                   CALL      'AOCUSTR1'                                                 232543
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      E5CUST        PCustNo
     C                   PARM      *BLANKS       PKey
     C*****SDCUST        PARM      SDCUST        DSSDY                                        232543
     C     SDCUST        PARM      SDCUST        DSLDY                                        232543

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   ENDIF

     C**********         IF        BBPRBA <> 'Y'                                              232543

      ** Access Country of Tax file with Country of Location

     C     BBCOLC        SETLL     SDCTTXL2
     C     BBCOLC        READE     SDCTTXL2

      ** If no record found, blank out country of residence

     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EXSR      SRWrite
     C**********         READ      SDCTTXL2                                                 AR762398
     C     BBCOLC        READE     SDCTTXL2                                                 AR762398
     C                   ENDDO

      ** Access Country of Tax file without Country of Location

     C                   EVAL      BBCOLC = *Blanks
     C     BBCOLC        SETLL     SDCTTXL2
     C     BBCOLC        READE     SDCTTXL2

      ** If no record found, blank out country of residence

     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EXSR      SRWrite
     C**********         READ      SDCTTXL2                                                 AR762398
     C     BBCOLC        READE     SDCTTXL2                                                 AR762398
     C                   ENDDO

     C**********         ENDIF                                                                232543

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWrite  - Write details                                     *
      *                                                              *
      ****************************************************************
     C     SRWrite       BEGSR

     C                   EVAL      KCust = E5CUST
     C                   EVAL      KCctx = EWCTRT
     C     KACTX         CHAIN     SDACTXL1

      ** Write record to SDACTXPD

     C                   IF        NOT %FOUND(SDACTXL1)
     C                   EVAL      AXCUST = E5CUST
     C                   EVAL      AXCTTX = EWCTRT
     C                   EVAL      AXETXS = EWTXS1
     C                   EVAL      AXCERF = *BLANKS
     C                   EVAL      AXCEEX = *ZERO
     C                   EVAL      AXREPI = *BLANKS
     C                   EVAL      AXFRNT = *BLANKS
     C                   EVAL      AXREPA = *BLANKS
     C
      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.

     C                   IF        CSC011 = 'Y' And
     C                             AXFRNT = *BLANKS
     C                   EVAL      AXFRNT = 'MD' + AXCUST + AXCTTX
     C                   ENDIF

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     AXTMST

     C                   IF        BBPRBA = 'Y' AND WUpdREPI = 'N'                            232543
     C                   EVAL      WUPDREPI = 'Y'                                             232543
                                                                                              232543
     C                   IF        E5REPI = *BLANKS                                           232543
     C                   EVAL      E5REPI = 'Y'                                               232543
     C                   ELSE                                                                 232543
     C                   EVAL      E5REPI = ' '                                               232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   UPDATE    @ACUSL1                                                    232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   WRITE     SDACTXD0

     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Key List

     C     KACTX         KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCctx

      ** Check if CSC011 is installed

     C                   EVAL      CSC011 = 'N'

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ENDIF

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
