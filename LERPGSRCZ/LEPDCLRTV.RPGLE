     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - retrieve + act/cust val')   *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEPDCLRTV - Past Due Call Loan Conversion: retrieve &        *
      *              validation                                       *
      *                                                               *
      *  Function:  This module retrieves a PDCL record from the      *
      *             database. As it does, it validates the Action     *
      *             Code and the keys.                                *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1094242          Date 03Mar13               *
      *                 AR1076968          Date 07Feb13               *
      *                 AR1078092          Date 20Jan13               *
      *                 AR1078443          Date 17Jan12               *
      *                 AR783785           Date 14Oct12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR693137           Date 01Aug12               *
      *                 AR634877           Date 01Aug12               *
      *                 AR402732           Date 01Aug12               *
      *                 AR321628           Date 01Aug12               *
      *                 264044             Date 01Aug12               *
      *                 263415             Date 01Aug12               *
      *                 263627             Date 01Aug12               *
      *                 263289             Date 01Aug12               *
      *                 262870             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1094242 - Event code not found                             *
      *  AR1076968A - System did not generate PDCL fees for unpaid    *
      *               portion of Fee due                              *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  AR1078443 - LEC000456 component failed during Day 2 COB      *
      *  AR783785 - During creation of PDCL in input cycle, when ori- *
      *             ginal loan has no settlement details on pay side, *
      *             error message LER5596 was shown. Removed part of  *
      *             AR693137 that validates pay settlement of the loan*
      *             (Child: AR783786)                                 *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR693137 - A PDCL cannot be generated for a Loan/Fee with    *
      *             Pay/Receipt settlement not equal to 01, 05, 08    *
      *             and 14. Enhancement of AR634877/A.                *
      *             (Child: AR693138)                                 *
      *  AR634877 - Component LEC0459 failed in COB.                  *
      *           - A PDCL cannot be generated for a Loan with both   *
      *             settlement methods = '00'.                        *
      *             (Child: AR634878)                                 *
      *  AR402732 - Unable to create specific PDCL for fee            *
      *             (Child: AR402733)                                 *
      *  AR321628 - Unable to create specific PDCL                    *
      *             (Child: AR321629)                                 *
      *  264044 - The SOAP PDCL API does not map all the fields       *
      *  263415 - Impossible to manually create PDCL for int only     *
      *  263627 - Unable to generate PDCL for Loan Fee in I/C         *
      *  263289 - Unable to insert PDCL for fee via Take-on option    *
      *  262870 - Matured original Loan causes manual                 *
      *           PDCL creation error                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Past Due & Original Loan Link File Format
 
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X_)
 
      ** Past Due & Original Loan Link File Format - FOID
 
     FLEPDUEL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUED0:LEPDUED3)
     F                                     PREFIX(X_)
 
      ** Past Due & Original Loan Link File Format
 
     FLEPDUEL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUED0:LEPDUED6)
     F                                     PREFIX(X_)
 
      ** Past Due & Original Fees Link File Format
 
     FLEPDUFL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Z_)
 
      ** Past Due & Original Fees Link File Format - FOID
 
     FLEPDUFL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUFD0:LEPDUFD3)
     F                                     PREFIX(Z_)
 
      ** Past Due & Original Fees Link File Format
 
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEPDUFD0:LEPDUFD1)
     F                                     PREFIX(Z_)
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(C_)
 
      ** Loans file
 
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(K_)
 
      ** Loans File Format
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
 
      ** Fees File Format
 
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYFNF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(M_)
 
      ** Facilities File Format
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
 
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D OKTrnDets     E DS                  EXTNAME(LEEPDCLPD)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
     D SDFEE         E DS                  EXTNAME(SDFEEPD )
 
      ** Loans File Format
 
     D PDCLFilFmtLoanE DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
 
      ** Loans File Format 2
 
     D PDCLFilFmtLoaKE DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
 
      ** Fees File Format
 
     D PDCLFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Facilities File Format
 
     D PDCLFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
      ** Loan Link File Format
 
     D PDCLFilFmtLnkLE DS                  EXTNAME(LEPDUEPD)
     D                                     PREFIX(X_)
 
      ** Fee Link File Format
 
     D PDCLFilFmtLnkFE DS                  EXTNAME(LEPDUFPD)
     D                                     PREFIX(Z_)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  IUSR                   1     10
     D  DBRN                  11     13
     D  BANK                  17     17
                                                                                              CLE148
      ** Switchable Feature Details Data Structure                                            CLE148
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE148
                                                                                              CLE148
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Ix              S              3P 0
 
      ** Index for arrays of of error message ids etc
 
     D ZACTN           S              1A
     D ZBR             S              3A
     D ERR             S              1P 0
 
     D WCUSN           S              6A
     D WAREF           S             10A
     D WC              S              2P 0
     D WADTYP          S              1A
     D W@ADRC          S              1A
 
     D ModeofOp        S              6A
     D RespMode        S              1A
     D DDACTN          S              1A
     D FOTRID          S             20A
 
     D WFECU           S              6A
     D WFFAC           S              3  0
     D WFCSQ           S              2  0                                                    263289
     D WFSEQ           S              2  0
     D WRCTYP          S              1A   inz('A')
     D WORLN           S              6
     D WORLNT          S              6
     D WFCTY           S              5  0
     D WFLNO           S              6
 
      ** Key fields ofr LEPDUxPD files
 
     D WRECI           S              1A   inz('D')
     D WPLON           S              6A
     D WPIIN           S              1
     D WVDAT           S              5  0
 
     D WPDINT          S             15  0
     D WTKIACL         S              6
     D WTKIABR         S              3
     D WTKIAAC         S             10  0
     D WTKIASE         S              2  0
     D WTKIACY         S              3
 
      ** Parameters for Access Objects
 
     D @CCY            s              3
 
      ** Establish the transaction type
 
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
 
     DNPLO2            S              6
     DNPLON            S              6
     DDDFLNO           S              6
     DDDFSEQ           S              2
     DDDFFAC           S              5
     DDDFECU           S              6
     DDDORLN           S              6
     DWUSR             S             10
     DPFeeCode         S              2
     DPLClass          S              4
     DPLSubType        S              2
     DPLoanType        S              2
     DDDSEIN           S              1
      *                                                                                       CLE148
      ** Parameters for calling AOSVALR0 (System Value Access Object)                         CLE148
      *                                                                                       CLE148
     D PRetCode        S              7A                                                      CLE148
     D PSysValK1       S             20A                                                      CLE148
     D PSysVal1        S            200A                                                      CLE148
     D PSysValK2       S             20A                                                      CLE148
     D PSysVal2        S            200A                                                      CLE148
     D PSysValK3       S             20A                                                      CLE148
     D PSysVal3        S            200A                                                      CLE148
     D PSysValK4       S             20A                                                      CLE148
     D PSysVal4        S            200A                                                      CLE148
     D PSysValK5       S             20A                                                      CLE148
     D PSysVal5        S            200A                                                      CLE148
     D PSysValK6       S             20A                                                      CLE148
     D PSysVal6        S            200A                                                      CLE148
     D PSysValK7       S             20A                                                      CLE148
     D PSysVal7        S            200A                                                      CLE148
     D PSysValK8       S             20A                                                      CLE148
     D PSysVal8        S            200A                                                      CLE148
     D PSysValK9       S             20A                                                      CLE148
     D PSysVal9        S            200A                                                      CLE148
     D PSysValK10      S             20A                                                      CLE148
     D PSysVal10       S            200A                                                      CLE148
      *                                                                                       CLE148
      ** Parameters for calling LELOANISO (Validate Loan Number)                              CLE148
      *                                                                                       CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
      ** Access Object Parameters                                                             CLE148
     D PRtcd           S              7A                                                      CLE148
     D POptn           S              7A                                                      CLE148
     D PSARD           S              6A                                                      CLE148
      *                                                                                       CLE148
     D LoanAlphaAllow  S              1A                                                      CLE148
     D CSD031          S              1A                                                      CLE148
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C                   EVAL      *IN98 = *OFF
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** If the mode is 'Front Office Transaction Interface'
      ** Do (Extra) Validation for Front Office Transaction Interface
 
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
 
      ** Carry out no further validation if errors have occurred.
 
     C                   IF        DDACTNOK = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Action Code & Transaction Number
 
     C                   IF        DDACTN <> ' '                                              CLE134
     C                   EXSR      VAL
     C                   ENDIF                                                                CLE134
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        Ix <> 0
     C                   RETURN
     C                   ENDIF
 
      ** Access Security Checking
 
     C                   IF        DDACTN <> ' '                                              CLE134
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
 
      ** If single branching
      ** Access Security Checking - Single Branching
 
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
 
      ** If multibranching
      ** Access Security Checking - Multi-Branching
 
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CLE134
 
      ** Carry out no further validation if errors have occurred
 
     C                   IF        DDACTNOK = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Carry out no further validation if errors occurred.
 
     C                   IF        ( DDACTNOK  = 'N'
     C                             OR DDORLNOK = 'N'
     C                             OR DDFECUOK = 'N'
     C                             OR DDFFACOK = 'N'
     C                             OR DDFSEQOK = 'N'
     C                             OR DDFLNOOK = 'N' )
     C                   RETURN
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
 
      ** Check user's authority for the action
 
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN
     C                   PARM                    ERR
 
      ** If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   IF        DDACTN = 'E'
     C                             OR DDACTN = 'I'
     C                             OR DDACTN = 'A'
     C                             OR DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVEL     'LEL0302'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
 
      ** Check user's authority for the action & Booking Branch
 
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN
     C                   PARM      DBRN          ZBR
     C                   PARM                    ERR
 
      ** If action invalid for user
 
     C                   IF        ERR = 1
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   IF        DDACTN = 'E'
     C                             OR DDACTN = 'I'
     C                             OR DDACTN = 'A'
     C                             OR DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C                   MOVEL     'LEL0302'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
 
      ** ERROR IF ACTION CODE IS NOT 'I'
 
     C                   IF        DDACTN <> 'I'
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        FOTRID = *BLANK
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Access Transaction with Front Office Transaction ID
 
     C     FOTRID        CHAIN     LEPDUEL3                           99
     C  N99FOTRID        CHAIN     LEPDUFL3                           99
 
      ** If Insert
 
     C                   IF        DDACTN = 'I'
 
      ** Front Office Transaction ID can't be Present already
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID Must be Present
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DDACTNOK = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   ENDIF
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRANSACTION NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      ** Action Code
      ** .. must be 'I' or 'E', if retrieving the data for the confo
      ** page
 
     C                   IF        DDACTN <> 'I'
     C                             AND DDACTN <> 'E'
     C                             AND DDACTN <> 'X'
     C                   MOVEL     'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     '5045648'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** If Enquiry, retrieve the data for the existing LEPDUxPD
      ** records
 
     C                   IF        DDACTN = 'E'
     C                             OR DDACTN = 'X'
 
     C                   IF        DDORLN  <> *BLANKS
 
      ** If the second PDCL has been created
 
     C                   IF        NPLO2 <> *BLANKS
     C                   EVAL      WPLON = NPLO2
     C                   EVAL      WPIIN = 'I'
     C     KPDUE2        CHAIN     LEPDUEL6                           9999
     C                   IF        *IN99 = *OFF
     C                   Z-ADD     X_YPDINT      WPDINT
     C                   MOVE      X_YTKIACL     WTKIACL
     C                   MOVE      X_YTKIABR     WTKIABR
     C                   MOVE      X_YTKIAAC     WTKIAAC
     C                   MOVE      X_YTKIASE     WTKIASE
     C                   MOVE      X_YTKIACY     WTKIACY
     C                   ENDIF
     C                   ENDIF
 
      ** If first PDCL has been created
 
     C                   IF        NPLON <> *BLANKS
     C                   EVAL      WPLON = NPLON
     C                   EVAL      WPIIN = 'T'
     C     KPDUE2        CHAIN     LEPDUEL6                           9999
 
      ** If not found, need to check P record
 
     C                   IF        *IN99 = *ON
     C                   EVAL      WPIIN = 'P'
     C     KPDUE2        CHAIN     LEPDUEL6                           9999
     C                   ENDIF
     C                   ENDIF
 
      ** Overwrite some fields if both P and I records exist
 
     C                   IF        NPLON <> *BLANKS AND NPLO2 <> *BLANKS
     C                   Z-ADD     WPDINT        X_YPDINT
     C                   MOVE      WTKIACL       X_YTKIACL
     C                   MOVE      WTKIABR       X_YTKIABR
     C                   MOVE      WTKIAAC       X_YTKIAAC
     C                   MOVE      WTKIASE       X_YTKIASE
     C                   MOVE      WTKIACY       X_YTKIACY
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WPLON = NPLON
     C**********         EVAL      WVDAT = BJRDNB                                             264044
     C*****KPDUF2        CHAIN     LEPDUFL1                           9999                    264044
     C     KPDUF2        SETLL     LEPDUFL1                           9999                    264044
     C     KPDUF2        READE     LEPDUFL1                             9999                  264044
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Retrieve original data
 
     C                   IF        DDORLN  <> *BLANKS
     C                             and ( DDFECU <> *BLANKS or
     C                                   DDFFAC <> *BLANKS or
     C                                   DDFSEQ <> *BLANKS or
     C                                   DDFLNO <> *BLANKS )
     C                   MOVEL     'N'           DDORLNOK
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045619'     MsgIdArr(Ix)
     C**********         ADD       1             Ix                                           263627
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C**********         MOVEL     '5045619'     MsgIdArr(Ix)                                 263627
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** Loan and Fee / Facility details, one has to be entered
 
     C                   IF        DDORLN  = *BLANKS
     C                             and DDFECU = *BLANKS
     C                             and DDFFAC = *BLANKS
     C                             and DDFSEQ = *BLANKS
     C                             and DDFLNO = *BLANKS
     C                   MOVEL     'N'           DDORLNOK
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045620'     MsgIdArr(Ix)
     C**********         ADD       1             Ix                                           263627
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C**********         MOVEL     '5045620'     MsgIdArr(Ix)                                 263627
     C                   GOTO      EVAL
     C                   ENDIF
 
      ** Retrieve Loan details, if original loan is OK
 
     C                   IF        DDORLN  <> *BLANKS
     C                   EVALR     DDORLN = %trim(DDORLN)
     C                   TESTN                   DDORLN               9798
                                                                                              CLE148
     C                   IF        LoanAlphaAllow = 'Y'                                       CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   Eval      PLNRF = DDORLN                                             CLE148
     C                   Eval      PValid = *BLANKS                                           CLE148
     C                   Eval      PChkDigit = *BLANK                                         CLE148
     C                   Eval      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   Call(E)   'LELOANISO'   P_LELOANISO                                  CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C**********         IF        *IN97 = *OFF                                               CLE148
     C**********                   AND *IN98 = *OFF                                           CLE148
     C**********         MOVEL     'N'           DDPLONOK                                     263627
     C**********         MOVEL     'N'           DDORLNOK                              263627 CLE148
     C**********         ADD       1             Ix                                           CLE148
     C**********         MOVEL     'DDORLN'      FldNameArr(Ix)                               CLE148
     C**********         MOVEL     'LEL0038'     MsgIdArr(Ix)                                 CLE148
     C**********         ELSE                                                                 CLE148
                                                                                              CLE148
     C                   IF        (LoanAlphaAllow = 'N' AND *IN97 = *OFF                     CLE148
     C                              AND *IN98 = *OFF) OR (LoanAlphaAllow = 'Y'                CLE148
     C                              AND PValid <> *BLANKS)                                    CLE148
     C                   MOVEL     'N'           DDORLNOK                                     CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)                               CLE148
                                                                                              CLE148
     C                   IF        LoanAlphaAllow = 'N'                                       CLE148
     C**********         MOVEL     'LEL0824'     MsgIdArr(Ix)                       CLE148 AR1094242
     C                   MOVEL     '5045902'     MsgIdArr(Ix)                              AR1094242
     C                   ELSE                                                                 CLE148
     C**********         MOVEL     'LEL0822'     MsgIdArr(Ix)                       CLE148 AR1094242
     C                   MOVEL     '5045901'     MsgIdArr(Ix)                              AR1094242
     C                   MOVEL     PData         MsgDtaArr(Ix)                                CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   ELSE                                                                 CLE148
                                                                                              CLE148
     C                   MOVE      DDORLN        WORLN
     C                   MOVE      WORLN         DDORLN
     C                   EVAL      C_RECI = *BLANKS                                         AR321628
     C     WORLN         CHAIN     CLOAN
     C                   IF        NOT %FOUND
     C                             or C_RECI <> 'D'                                         AR321628
     C                             AND COBMode <> 'Y'                                     AR1076968A
     C**********         MOVEL     'N'           DDPLONOK                                     263627
     C                   MOVEL     'N'           DDORLNOK                                     263627
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045650'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ( %SubST(C_LTYP: 1: 1) <> 'H'
     C                              and %SubST(C_LTYP: 1: 1) <> 'J'
     C                              and %SubST(C_LTYP: 1: 1) <> 'K' )
     C                             or C_MDAT < BJRDNB
     C                             and C_MDAT <> 0
     C                             and C_CPAM = *ZEROS                                        262870
     C                             and C_AIPD = *ZEROS                                        262870
     C                             or C_PTYP = 66
     C                             or C_PTYP = 69
     C**********         MOVEL     'N'           DDPLONOK                                     263627
     C                   MOVEL     'N'           DDORLNOK                                     263627
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045621'     MsgIdArr(Ix)
     C                   ELSE
     C**********         IF        C_RSTM = 00                                     AR634877 AR693137
     C**********                   and C_PSTM = 00                                 AR634877 AR693137
     C**********         MOVEL     'N'           DDORLNOK                          AR634877 AR693137
     C**********         ADD       1             Ix                                AR634877 AR693137
     C**********         MOVEL     'DDORLN'      FldNameArr(Ix)                    AR634877 AR693137
     C**********         MOVEL     'LER5593'     MsgIdArr(Ix)                      AR634877 AR693137
                                                                                            AR693137
      ** PDCL cannot be defined if Receipt/Pay settlement is not equal                      AR693137
      ** to 01, 05, 08 and 14                                                               AR693137
                                                                                            AR693137
     C**********         IF        (C_PSTM <> 01 AND C_PSTM <> 05 AND              AR693137 AR783785
     C**********                   C_PSTM <> 08 AND C_PSTM <> 14) OR               AR693137 AR783785
     C**********                   (C_RSTM <> 01 AND C_RSTM <> 05 AND              AR693137 AR783785
     C                   IF        (C_RSTM <> 01 AND C_RSTM <> 05 AND              AR693137 AR783785
     C                             C_RSTM <> 08 AND C_RSTM <> 14)                           AR693137
     C                   MOVEL     'N'           DDORLNOK                                   AR693137
     C                   ADD       1             Ix                                         AR693137
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)                             AR693137
     C                   MOVEL     '5045687'     MsgIdArr(Ix)                               AR693137
      *                                                                                     AR693137
     C                   ELSE                                                               AR634877
     C                   EVAL      K_RECI = *BLANKS                                         AR321628
     C     WORLN         CHAIN     CLOANC
     C                   IF        NOT %FOUND
     C                             or K_RECI <> 'D'                                         AR321628
     C                             AND COBMode <> 'Y'                                     AR1076968A
     C**********         MOVEL     'N'           DDPLONOK                                     263627
     C                   MOVEL     'N'           DDORLNOK                                     263627
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045650'     MsgIdArr(Ix)
     C                   ELSE
 
      ** Find type/subtype info
 
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      C_LTYP        PLoanType
     C                   PARM      C_SUTP        PLSubType
     C                   PARM      C_CLAS        PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                             OR AYPPLT = *BLANKS
     C                             OR AYPPLS = *BLANKS
     C                             AND (DDSEIN = 'Y'
     C                             OR AYIPLT = *BLANKS
     C                             OR AYIPLS = *BLANKS)
     C**********         MOVEL     'N'           DDPLONOK                                     263627
     C                   MOVEL     'N'           DDORLNOK                                     263627
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045654'     MsgIdArr(Ix)
     C                   ELSE
     C                   EVAL      RecordType = Loan
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                              AR634877
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Retrieve Fee details, if fee info are OK
 
     C                   IF        DDORLN  = *BLANKS
     C                             and ( DDFECU <> *BLANKS or
     C                                   DDFFAC <> *BLANKS or
     C                                   DDFSEQ <> *BLANKS or
     C                                   DDFLNO <> *BLANKS )
     C
     C                   MOVE      DDFECU        WFECU
     C                   MOVE      DDFFAC        WFCTY
     C                   MOVE      DDFLNO        WFLNO
     C                   MOVE      DDFSEQ        WFSEQ
     C
     C                   CLEAR                   E_FEPEND                                   AR402732
     C     KFEE          CHAIN     LEFEEDL1
     C                   IF        NOT %FOUND
     C**********                   or E_FEPEND < BJRDNB                                     AR402732
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C**********         MOVEL     'N'           DDFFACOK                                     263627
     C                   MOVEL     'N'           DDFSEQOK
     C**********         MOVEL     'N'           DDFLNOOK                                     263627
     C                   ADD       1             Ix
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                               263627
     C                   MOVEL     '5045622'     MsgIdArr(Ix)
     C                   ENDIF
                                                                                            AR402732
     C                   IF        %FOUND                                                   AR402732
     C                   IF        E_FEPEND = 0  and E_FECALT = *BLANKS AND                 AR402732
     C                             E_FEPSTD > 0                                             AR402732
     C                   MOVEL     'N'           DDFSEQOK                                   AR402732
     C                   ADD       1             Ix                                         AR402732
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                             AR402732
     C                   MOVEL     '5045684'     MsgIdArr(Ix)                               AR402732
     C                   ENDIF                                                              AR402732
     C                   ENDIF                                                              AR402732
                                                                                            AR402732
     C                   IF        %FOUND                                                   AR402732
     C**********         IF        E_FEPEND < BJRDNB and E_FEPEND > 0             AR402732 AR1078443
     C**********         MOVEL     'N'           DDFSEQOK                         AR402732 AR1078443
     C**********         ADD       1             Ix                               AR402732 AR1078443
     C**********         MOVEL     'DDFSEQ'      FldNameArr(Ix)                   AR402732 AR1078443
     C**********         MOVEL     '5045681'     MsgIdArr(Ix)                     AR402732 AR1078443
     C**********         ENDIF                                                    AR402732 AR1078443
     C                   ENDIF                                                    AR402732 AR1078443
 
      ** Fee must be FEAUTO = Y
 
     C**********         IF        E_FEAUTO <> 'Y'                                            263415
     C                   IF        E_FEAUTO = 'N'                                             263415
     C**********                   and DDFECUOK = 'Y'                                         263627
     C                             and DDFSEQOK = 'Y'                                         263627
     C                             and DDACTN = 'I'
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   MOVEL     'N'           DDFSEQOK                                     263627
     C                   ADD       1             Ix
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                               263627
     C                   MOVEL     '5045624'     MsgIdArr(Ix)
     C                   ENDIF
                                                                                            AR693137
      ** PDCL cannot be defined if Receipt/Pay settlement is not equal                      AR693137
      ** to 01, 05, 08 and 14                                                               AR693137
                                                                                            AR693137
     C                   IF        E_FEAUTO = 'C'                                           AR693137
     C                   IF        (E_RSTM <> 01 AND E_RSTM <> 05 AND                       AR693137
     C                             E_RSTM <> 08 AND E_RSTM <> 14)                           AR693137
     C                   MOVEL     'N'           DDFSEQOK                                   AR693137
     C                   ADD       1             Ix                                         AR693137
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                             AR693137
     C                   MOVEL     '5045688'     MsgIdArr(Ix)                               AR693137
     C                   ENDIF                                                              AR693137
     C                   ENDIF                                                              AR693137
 
      ** Fee must not be suspended
 
     C                   IF        E_FEFSFA = 'Y'
     C**********                   and DDFECUOK = 'Y'                                         263627
     C                             and DDFSEQOK = 'Y'                                         263627
     C                             and DDACTN = 'I'
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   MOVEL     'N'           DDFSEQOK                                     263627
     C                   ADD       1             Ix
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                               263627
     C                   MOVEL     '5045649'     MsgIdArr(Ix)
     C                   ENDIF
 
      ** Find type/subtype info
 
     C**********         IF        DDFECUOK = 'Y'                                             263627
     C                   IF        DDFSEQOK = 'Y'                                             263627
     C                             and DDACTN = 'I'
     C                   MOVE      E_FEFCOD      PFeeCode
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PFeeCode
     C     SDFEE         PARM      SDFEE         DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                             OR AUCLTY = *BLANKS
     C                             OR AUCLST = *BLANKS
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   MOVEL     'N'           DDFSEQOK                                     263627
     C                   ADD       1             Ix
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                               263627
     C                   MOVEL     '5045655'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Retrieve Facility Details, if entered
 
     C                   IF        DDORLN  = *BLANKS
     C                             and ( DDFECU <> *BLANKS or
     C                                   DDFFAC <> *BLANKS or
     C                                   DDFSEQ <> *BLANKS or
     C                                   DDFLNO <> *BLANKS )
     C**********                   and DDFECUOK = 'Y'                                         263627
     C                             and DDFSEQOK = 'Y'                                         263627
 
     C                   EVAL      WFECU = DDFECU
     C                   MOVEL     DDFFAC        WFFAC
     C**********         MOVE      DDFFAC        WFSEQ                                        263289
     C                   MOVE      DDFFAC        WFCSQ                                        263289
 
      ** Retrieve Loan details, if Loan fee
 
     C                   IF        DDFLNO <> *BLANKS
     C                   MOVE      DDFLNO        WFLNO
     C     WFLNO         CHAIN     CLOAN
     C                   IF        %FOUND
     C                   EVAL      WFECU = C_FCUS
     C                   MOVE      C_FTYP        WFFAC
     C**********         MOVE      C_FSEQ        WFSEQ                                        263289
     C                   MOVE      C_FSEQ        WFCSQ                                        263289
     C     WFLNO         CHAIN     CLOANC
     C                   EVAL      RecordType = FeeLoan
     C                   ENDIF
     C                   ENDIF
 
     C     KFCLTY        CHAIN     FCLTY
     C                   IF        NOT %FOUND
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   MOVEL     'N'           DDFLNOOK                                     263627
     C                   ADD       1             Ix
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C                   MOVEL     'DDFLNO'      FldNameArr(Ix)                               263627
     C                   MOVEL     '5045623'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        DDFLNO = *BLANKS
     C                   EVAL      RecordType = FeeFacility
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Loan or Fee PDCLs cannot already exist on input
 
     C                   IF        DDACTN = 'I'
     C                             and DDORLNOK  = 'Y'
     C                             and DDFECUOK  = 'Y'
     C                             and DDFFACOK  = 'Y'
     C                             and DDFSEQOK  = 'Y'
     C                             and DDFLNOOK  = 'Y'
 
      ** It is ok if only a 'P' or an 'I' exists                                              263415
                                                                                              263415
     C                   IF        DDORLN  <> *BLANKS
     C                             AND DDFECU =*BLANKS                                        CLE134
     C                             AND DDFFAC =*BLANKS                                        CLE134
     C                             AND DDFSEQ =*BLANKS                                        CLE134
     C                             AND COBMode <> 'Y'                                      AR1078092
     C*****KPDUE         SETLL     LEPDUEL2                               99                  263415
     C**********         IF        *IN99 = *ON                                                263415
     C     KPDUE         SETLL     LEPDUEL2                                                   263415
     C     KPDUE         READE     LEPDUEL2                               99                  263415
     C     *IN99         IFEQ      *OFF                                                       263415
     C     X_YPDCT       ANDNE     'T'                                                        263415
     C     KPDUE         READE     LEPDUEL2                               99                  263415
     C                   ENDIF                                                                263415
     C                   IF        *IN99 = *OFF                                               263415
     C                   MOVE      'N'           DDORLNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDORLN'      FldNameArr(Ix)
     C                   MOVEL     '5045643'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ELSE
     C     KPDUF         SETLL     LEPDUFL2                               99
     C                   IF        *IN99 = *ON
     C                             AND COBMode <> 'Y'                                     AR1076968A
     C**********         MOVEL     'N'           DDFECUOK                                     263627
     C                   MOVEL     'N'           DDFSEQOK                                     263627
     C                   ADD       1             Ix
     C**********         MOVEL     'DDFECU'      FldNameArr(Ix)                               263627
     C                   MOVEL     'DDFSEQ'      FldNameArr(Ix)                               263627
     C                   MOVEL     '5045644'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
 
     C                   GOTO      EVAL
     C                   ENDIF
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      ** Clear Outputs
 
     C                   CLEAR                   PDCLFilFmtLoan
     C                   CLEAR                   PDCLFilFmtLoaK
     C                   CLEAR                   PDCLFilFmtFee
     C                   CLEAR                   PDCLFilFmtFcty
 
     C                   EVAL      DDACTNOK    = 'Y'
     C                   EVAL      DDORLNOK    = 'Y'
     C                   EVAL      DDFECUOK    = 'Y'
     C                   EVAL      DDFFACOK    = 'Y'
     C                   EVAL      DDFSEQOK    = 'Y'
     C                   EVAL      DDFLNOOK    = 'Y'
 
     C                   MOVE      IUSR          WUSR
 
     C                   CLEAR                   RecordType
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Front Office Transaction ID
 
     C                   PARM                    FOTRID
 
      ** User ID
 
     C                   PARM                    WUSR
 
      ** Keys
 
     C                   PARM                    DDORLN
     C                   PARM                    DDFECU
     C                   PARM                    DDFFAC
     C                   PARM                    DDFSEQ
     C                   PARM                    DDFLNO
 
     C                   PARM                    NPLON
     C                   PARM                    NPLO2
     C                   PARM                    DDSEIN
      ** COB Mode                                                                          AR1078092
                                                                                           AR1078092
     C                   PARM                    COBMode           1                       AR1078092
 
      ** Outputs
 
      ** Transaction Type
 
     C                   PARM                    RecordType
 
      ** Transaction Details in File Format: Loan 1
 
     C                   PARM                    PDCLFilFmtLoan
 
      ** Transaction Details in File Format: Loan 2
 
     C                   PARM                    PDCLFilFmtLoaK
 
      ** Transaction Details in File Format: Fee
 
     C                   PARM                    PDCLFilFmtFee
 
      ** Transaction Details in File Format: Facility
 
     C                   PARM                    PDCLFilFmtFcty
 
      ** Transaction Details in File Format: Loan Link
 
     C                   PARM                    PDCLFilFmtLnkL
 
      ** Transaction Details in File Format: Fee Link
 
     C                   PARM                    PDCLFilFmtLnkF
 
      ** PDCL Details OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
 
      ** Key Lists
 
     C     KFEE          KLIST
     C                   KFLD                    WFECU
     C                   KFLD                    WFCTY
     C                   KFLD                    WFLNO
     C                   KFLD                    WFSEQ
 
     C     KFCLTY        KLIST
     C                   KFLD                    WFECU
     C                   KFLD                    WFFAC
     C**********         KFLD                    WFSEQ                                        263289
     C                   KFLD                    WFCSQ                                        263289
     C                   KFLD                    WRCTYP
 
      ** Keys for LEPDUEPD files
 
     C     KPDUE         KLIST
     C                   KFLD                    WORLN
 
     C     KPDUE2        KLIST
     C                   KFLD                    WRECI
     C                   KFLD                    WPLON
     C                   KFLD                    WPIIN
 
      ** Keys for LEPDUFPD files
 
     C     KPDUF         KLIST
     C                   KFLD                    WFLNO
     C                   KFLD                    WFECU
     C                   KFLD                    WFCTY
     C                   KFLD                    WFSEQ
 
     C     KPDUF2        KLIST
     C                   KFLD                    WPLON
     C**********         KFLD                    WVDAT                                        264044
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'LEPDCLRTV'
 
      ** GET RUNDAT to access MULTI-BRANCHING flag.
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PList                                                                CLE148
      ** Loan Number (Input)                                                                  CLE148
     C                   Parm                    PLNRF                                        CLE148
      ** Validity Flags (Output)                                                              CLE148
     C                   Parm                    PValid                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
     C                   Parm                    PChkDigit                                    CLE148
     C                   Parm                    PData                                        CLE148
      *                                                                                       CLE148
      ** Parameter list for calling AOSVALR0                                                  CLE148
      *                                                                                       CLE148
     C     P_AOSVALR0    PList                                                                CLE148
                                                                                              CLE148
      ** Return Code (Output)                                                                 CLE148
                                                                                              CLE148
     C                   Parm                    PRetCode                                     CLE148
                                                                                              CLE148
      ** System Value to be retrieved (Input)                                                 CLE148
                                                                                              CLE148
     C                   Parm                    PSysValK1                                    CLE148
                                                                                              CLE148
      ** Value returned (Output)                                                              CLE148
                                                                                              CLE148
     C                   Parm                    PSysVal1                                     CLE148
     C                   Parm                    PSysValK2                                    CLE148
     C                   Parm                    PSysVal2                                     CLE148
     C                   Parm                    PSysValK3                                    CLE148
     C                   Parm                    PSysVal3                                     CLE148
     C                   Parm                    PSysValK4                                    CLE148
     C                   Parm                    PSysVal4                                     CLE148
     C                   Parm                    PSysValK5                                    CLE148
     C                   Parm                    PSysVal5                                     CLE148
     C                   Parm                    PSysValK6                                    CLE148
     C                   Parm                    PSysVal6                                     CLE148
     C                   Parm                    PSysValK7                                    CLE148
     C                   Parm                    PSysVal7                                     CLE148
     C                   Parm                    PSysValK8                                    CLE148
     C                   Parm                    PSysVal8                                     CLE148
     C                   Parm                    PSysValK9                                    CLE148
     C                   Parm                    PSysVal9                                     CLE148
     C                   Parm                    PSysValK10                                   CLE148
     C                   Parm                    PSysVal10                                    CLE148
      *                                                                                       CLE148
      ** Check if CSD031 is on.                                                               CLE148
      *                                                                                       CLE148
     C                   CALL      'AOSARDR0'                                                 CLE148
     C                   PARM      *BLANKS       PRtCd                                        CLE148
     C                   PARM      '*VERIFY'     POptn                                        CLE148
     C                   PARM      'CSD031'      PSARD                                        CLE148
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE148
                                                                                              CLE148
     C                   IF        PRtCd = *BLANKS                                            CLE148
     C                   EVAL      CSD031 = 'Y'                                               CLE148
     C                   ELSE                                                                 CLE148
                                                                                              CLE148
     C                   IF        PRtCd <> '*NRF   '                                         CLE148
     C     *LOCK         IN        LDA                                                        CLE148
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE148
     C                   EVAL      DBKey = POptn                                              CLE148
     C                   EVAL      DBase = 101                                                CLE148
     C                   OUT       LDA                                                        CLE148
     C                   EXSR      *PSSR                                                      CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
      ** Retrieve System Value 'LoanAlphaAllow'                                               CLE148
      *                                                                                       CLE148
     C                   Eval      PRetCode = *BLANKS                                         CLE148
     C                   Eval      PSysValK1 = 'LoanAlphaAllow'                               CLE148
     C                   Eval      PSysVal1 = *BLANKS                                         CLE148
                                                                                              CLE148
     C                   IF        CSD031 = 'Y'                                               CLE148
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                   CLE148
     C                   ELSE                                                                 CLE148
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                   CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
      ** If Error retrieving the System values                                                CLE148
                                                                                              CLE148
     C                   If        %Error Or PRetCode <> *BLANKS                              CLE148
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CLE148
     C     *LOCK         In        LDA                                                        CLE148
     C                   Eval      DBFILE = 'AOSVALR0'                                        CLE148
     C                   Eval      DBASE = 1                                                  CLE148
     C                   Eval      DBKEY = 'LoanAlpha(Allow/Chksum)'                          CLE148
     C                   Eval      DBPGM = PsProcPgm                                          CLE148
     C                   Out       LDA                                                        CLE148
     C                   ExSr      *PSSR                                                      CLE148
     C                   EndIf                                                                CLE148
                                                                                              CLE148
     C                   MOVEL     PSysVal1      LoanAlphaAllow                               CLE148
 
      ** Program, module and procedure names for dbase error processing
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
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
 
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
 
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2011
