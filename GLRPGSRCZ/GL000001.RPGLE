     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Initialisation Program for CGL014')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000001 - Initialisation Program for Collaterals Processing *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE040             Date 05Jul04               *
      *                 CGL014  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  CGL014 - Collaterals Processing                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process files                                    *
      *  SRFacLoan - Update Facility/Loan file                        *
      *  SRGenRefNo - Generate Reference Number processing            *
      *  SRGenTrnNo - Generate Transaction Number processing          *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** LE Guarantees/Securities/Collaterals file
     FGTEES     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(GTEESHHF)
     F                                     IGNORE(GTEESZZF)

      ** SD Collateral Types Retrieval Index
     FSDCOTPL1  IF   E           K DISK    INFSR(*PSSR)

      ** GL Accounts file
     FACCNT     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F                                     PREFIX(AC_)
     F                                     USROPN

      ** LE Facilities File
     FFCLTYL1   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FC_)

      ** LE Loans file
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(CL_)

      ** GL Collateral details file
     FGLCOLLPD  O    E             DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRetCode        S              7
     D POption         S              7
     D PModule         S              2
     D PTType          S              1
     D PFrontID        S             20
     D PGenRef         S             10
     D PReturn         S             10
     D PTrnNo          S              5  0

     D WFCLN1          S              1
     D WFCLN5          S              5
     D WFound          S              1
     D WFirst          S              1
     D WRun            S              1
     D TimeStamp       S               Z

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Process files

     C                   EXSR      SRProcess

      ** End program

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process files                                    *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

      ** Read through the accounts file and initialise the
      ** Collateral flag and Collateral amounts

     C                   OPEN      ACCNT
     C                   READ      ACCNT

     C                   DOW       NOT %EOF(ACCNT)

     C                   EVAL      AC_COLF = 'N'
     C                   EVAL      AC_BCOA = 0
     C                   EVAL      AC_COLA = 0

     C                   UPDATE    ACCNTABF

     C                   READ      ACCNT
     C                   ENDDO
     C                   CLOSE     ACCNT

      ** Transfer all lending guarantees to the collateral details file

     C                   READ      GTEES

     C                   DOW       NOT %EOF(GTEES)

     C                   IF        RECI = 'D'

     C                   EVAL      CDRECI = RECI
     C                   EVAL      CDVDAT = STTD
     C                   EVAL      CDEDAT = EDDT
     C                   EVAL      CDRVDT = RVDT
     C                   EVAL      CDRFRQ = RVFR
     C                   EVAL      CDRDNO = RVDY
     C                   EVAL      CDCCY  = CCY
     C                   EVAL      CDNAMT = NOUN
     C                   EVAL      CDUPRC = 0
     C                   EVAL      CDDESC = NARR
     C                   EVAL      CDBRCA = BRCA
     C                   EVAL      CDSDAT = ORED
     C                   EVAL      CDCNUM = CNUM
     C                   EVAL      CDFCUS = CNUM
     C                   EVAL      CDPR01 = GBCN
     C                   EVAL      CDVAMT = TAMT

      ** Determine if record is a facility or loan, then
      ** set the affected fields accordingly

     C                   MOVEL     FCLN          WFCLN1
     C**********         IF        WFCLN1 = 'F'                                               CLE148
     C                   IF        WFCLN1 = *BLANK                                            CLE148
     C                   MOVE      FCLN          WFCLN5
     C                   MOVEL     WFCLN5        CDFTYP
     C                   MOVE      WFCLN5        CDFSEQ
     C**********         EVAL      CDLNLM = 0                                                 CLE148
     C                   EVAL      CDLNLM = *Blanks                                           CLE148
     C                   ELSE
     C                   EVAL      CDFTYP = 0
     C                   EVAL      CDFSEQ = 0
     C                   MOVE      FCLN          CDLNLM
     C                   ENDIF

      ** If first record, access collateral types details

     C                   IF        WFirst = 'Y'
     C                   EXSR      SRCollType
     C                   EVAL      WFirst = 'N'
     C                   ENDIF

      ** Retrieve reference number

     C                   EXSR      SRGenRefNo
     C                   EVAL      CDCREF = PGenRef

      ** Retrieve next available transaction number

     C                   EXSR      SRGenTrnNo
     C                   EVAL      CDTNLU = PTrnNo

      ** Set timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   MOVE      TimeStamp     CDTMST

      ** Set standard default values of other fields

     C                   EVAL      CDLCD  = BJRDNB
     C                   EVAL      CDTYLC = 'I'
     C                   EVAL      CDENTY = 'B'
     C                   EVAL      CDSTAT = 'I'
     C                   EVAL      CDMODS = 'LE'
     C                   EVAL      CDAUTH = 'C'
     C                   EVAL      CDGNSP = 'S'
     C                   EVAL      CDAPCT = 'A'
     C                   EVAL      CDRNEW = 'N'
     C                   EVAL      CDPCTA = 100
     C                   EVAL      CDLAMT = CDMARG * CDVAMT
     C                   EVAL      CDTOTA = CDLAMT

     C                   WRITE     GLCOLLD0

      ** Update facility/loan file accordingly

     C                   EXSR      SRFacLoan

     C                   ENDIF

     C                   READ      GTEES
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFacLoan - Update Facility/Loan file                        *
      *                                                               *
      *****************************************************************

     C     SRFacLoan     BEGSR

      ** If Secured Loan/Limit is zero, access facilities file
      ** and set Facility Secured Flag = 'Y'

     C**********         IF        CDLNLM = 0                                                 CLE148
     C                   IF        CDLNLM = *Blanks                                           CLE148

     C     KFCLTY        CHAIN     FCLTYL1

     C                   IF        %FOUND(FCLTYL1)
     C                   EVAL      FC_SECI = 'Y'
     C                   UPDATE    FCLTYFMF
     C                   ENDIF

      ** Else, access loans file and set Loan Secured Flag = 'Y'

     C                   ELSE

     C     CDLNLM        CHAIN     CLOAN

     C                   IF        %FOUND(CLOAN)
     C                   BITOFF    '0'           CL_RELI
     C                   UPDATE    CLOANCLF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCollType - Access Collateral Type details                  *
      *                                                               *
      *****************************************************************

     C     SRCollType    BEGSR

     C                   EVAL      WFound = 'N'

     C                   DOU       %EOF(SDCOTPL1)  OR  WFound = 'Y'
     C                   READ      SDCOTPL1
     C                   IF        CTCOPT = 'G'
     C                   EVAL      WFound = 'Y'
     C                   ENDIF
     C                   ENDDO

     C                   IF        WFound = 'Y'
     C                   EVAL      CDCOPT = 'G'
     C                   EVAL      CDCOLT = CTCOLT
     C                   EVAL      CDMARG = CTMPCT
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenRefNo - Generate Reference Number processing            *
      *                                                               *
      *****************************************************************

     C     SRGenRefNo    BEGSR

      ** Call generate reference module

     C                   CALLB     'GLCOLLGEN'

      ** INPUTS
      ** Return code
      ** Module
      ** Transaction Type
      ** Front Office Id

     C                   PARM      *BLANKS       PRetCode
     C                   PARM      'GL'          PModule
     C                   PARM      'C'           PTType
     C                   PARM      *BLANKS       PFrontID

      ** OUTPUTS
      ** Generated Reference

     C                   PARM      *BLANKS       PGenRef

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'GLCOLLGEN'
     C                   EVAL      DBKEY  = '*CALL'
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGenTrnNo - Generate Transaction Number process             *
      *                                                               *
      *****************************************************************

     C     SRGenTrnNo    BEGSR

      ** Get the next available transaction number

     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       PReturn
     C                   PARM      0             PTrnNo

     C                   IF        PReturn <> *BLANKS
     C                   EVAL      DBFILE = 'ZTNLU1'
     C                   EVAL      DBKEY  = '*CALL'
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Access bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Key list for LF/FCLTYL1

     C     KFCLTY        KLIST
     C                   KFLD                    CDBRCA
     C                   KFLD                    CDFCUS
     C                   KFLD                    CDFTYP
     C                   KFLD                    CDFSEQ

     C                   EVAL      WFirst = 'Y'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
