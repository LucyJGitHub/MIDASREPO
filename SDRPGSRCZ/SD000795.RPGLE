     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Exemption Threshold Enquiry')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000795 - Midas SD Customer Exemption Threshold Enquiry.    *
      *                                                               *
      *  Function:  This new enquiry shows details of threshold       *
      *             allocated to the selected customer.               *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 MD025654A          Date 18Mar14               *
      *                 MD025654           Date 13Mar14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR746766A          Date 05May11               *
      *                 AR746766           Date 26Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD025654A - Exemption threshold enquiry not shown during     *
      *             IC and after COB                                  *
      *  MD025654 - Exemption threshold enquiry not shown during      *
      *             IC and after COB                                  *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR746766A - Exemption Threshold missing details ; cannot     *
      *              display non-account holder members               *
      *              (Child: AR746767)                                *
      *  AR746766 - Exemption Threshold missing details               *
      *             (Child: AR746767)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *  *IN80  : SFLCLR                                              *
      *  *IN81  : SFLDSP                                              *
      *  *IN82  : SFLEND                                              *
      *  *IN98  : Date format DDMMYY                                  *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInsfl - Initialise Subfile                                 *
      *  SRCustd - Load Customer details                              *
      *  SRJCusd - Load Join Customer details                         *
      *  SRWrite - Write Details                                      *
      *  SRWrite2 - Write Records for Non-Account Holder Members      *                    AR746766A
      *  SRDspl  - Display Subfile                                    *
      *  SRZfrPed - Subroutine to perform Editing                     *
      *  *PSSR  - Program exception error routine                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD Exemption Threshold History File by Customer &
      ** Date of Action
      *
     FSDTHRHL3  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Additional customer details update
      *
     FSDACUSL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Joint Account Member Details by Customer
      *
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)
     FSDJACCLB  IF   E           K DISK    INFSR(*PSSR)                                     AR746766
     F                                     RENAME(SDJACCD0:SDJACCD1)                        AR746766
      *
      ** Midas SD Cust Exempt Threshold Enquiry - Display
      *
     FSD000795DFCF   E             WORKSTN
     F                                     SFILE(SD000795S1:RRN)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PReturn         S              7A
     D PCust           S             10A
      *
     D PRtcd           S              7A
     D POptn           S              7A
      *
     D KWcust          S              6A
     D KJcust          S              6A
     D RRN             S              4P 0
      *
     D WWcext          S              6P 0
     D WWtrap          S              5P 0
     D WWtrvd          S              5P 0
     D WWtred          S              5P 0
     D WJointFound     S              1A                                                    AR746766
      *
      ** Parameters for ZFRPED
      *
     D PFld15          S             15P 0
     D PECode          S              1A
     D PDecs           S              1P 0
     D POut22          S             22A
     D POut25          S             25A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically. The *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      ** MAIN PROCEDURE                                               *
      *****************************************************************
      *
      ** Initialize subfile
      *
     C                   EXSR      SRInsfl
      *
      ** Load Customer details
      *
     C                   EXSR      SRCustd
      *
     C                   DOW       (*IN03 = *OFF)
     C                              AND (*IN12 = *OFF)
      *
      ** Display
      *
     C                   IF        PReturn = '*NRF'
     C                   LEAVE
     C                   ENDIF
      *
      ** Display subfile
      *
     C                   EXSR      SRDspl
      *
     C                   ENDDO
      *
     C                   IF        *IN03 = *ON
     C                   MOVEL     'Y2U9999'     PReturn
     C                   ENDIF
      *
     C                   IF        *IN12 = *ON
     C                   MOVEL     'F12'         PReturn
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial routine                                     *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Receive Parameters from calling pgm
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturn
     C                   PARM                    PCust
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Populate Screen Header Fields
      *
     C                   EVAL      DDJOB = PSJObName
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDMRDT = BJMRDT
      *
      ** DDMMYY indicator for ZDATE2
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ELSE
     C                   EVAL      *IN98 = *OFF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsfl - Initialise Subfile                                 *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInsfl       BEGSR
      *
      ** Clear SFL
      *
     C                   EVAL      *IN80 = '1'
     C                   EVAL      *IN81 = '1'
     C                   EVAL      *IN82 = '1'
      *
     C                   WRITE     SD000795C1
      *
     C                   EVAL      *IN80 = '0'
     C                   EVAL      RRN = 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustd - Load Customer details                              *
      *                                                               *
      *  Called by: MAIN processing                                   *
      *                                                               *
      *  Calls: SRJCusd                                               *
      *                                                               *
      *****************************************************************
     C     SRCustd       BEGSR
      *
      ** Error Indicator set
      *
     C                   EVAL      *IN20 = *OFF
      *
     C                   EVAL      KWcust = PCust
      *                                                                                     AR746766
      ** If customer has a joint account, use joint account                                 AR746766
      *                                                                                     AR746766
     C     KWcust        CHAIN     SDJACCL4                                                 AR746766
     C                   IF        %FOUND(SDJACCL4)                                         AR746766
     C                   EVAL      KWcust = JCJANO                                          AR746766
     C                   EVAL      WJointFound = 'Y'                                        AR746766
     C                   ENDIF                                                              AR746766
      ** If entered customer is not a joint account                                        AR746766A
     C                   IF        PCust <> KWcust                                         AR746766A
     C                   EVAL      KWcust = PCust                                          AR746766A
     C                   ENDIF                                                             AR746766A
      *
      ** Check the customer value in threshold file
      *
     C     KWcust        CHAIN     SDTHRHL3
      *
     C                   IF        %FOUND(SDTHRHL3)
     C                   EVAL      DDCUST1 = TECUST
      *
      ** Load header details
      *
     C                   EVAL      DDCUST = TECUST
      *
      ** Retrive and write the details of main customer
      *
     C                   EVAL      WWcext = TECEXT
     C                   EVAL      WWtrap = TETRAD
     C                   EVAL      WWtrvd = TETRVD
     C                   EVAL      WWtred = TETRMD
      *                                                                                     AR746766
      ** Use PCust if joint account was found                                               AR746766
      *                                                                                     AR746766
     C                   IF        WJointFound = 'Y'                                        AR746766
     C                   EVAL      KWcust = PCust                                           AR746766
     C                   EVAL      DDCUST1 = PCust                                          AR746766
     C                   EVAL      DDCUST = JCCUST                                          AR746766
     C                   EVAL      DDJCUS = JCJANO                                          AR746766
     C                   ENDIF                                                              AR746766
      *
     C                   EXSR      SRWrite
      *
     C     KWcust        CHAIN     SDACUSL0
     C                   IF        %FOUND(SDACUSL0)
      *
      ** Load Joint account Type header
      *
     C                   EVAL      DDJTYPE = E5JATP
      *
     C                   WRITE     SD000795C1
      *
      ** Check if Joint account customer is linked.
      *
     C                   IF        E5JATP = 'Y'
      *
      ** Load Join customer details
      *
     C                   EXSR      SRJCusd
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      PReturn = '*NRF'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJCusd - Load Join customer details                         *
      *                                                               *
      *  Called by: SRCustd                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRJCusd       BEGSR
      *
     C*****KWcust        SETLL     SDJACCL4                                                 AR746766
     C     KWcust        SETLL     SDJACCLB                                                 AR746766
     C*****KWcust        READE     SDJACCL4                                                 AR746766
     C     KWcust        READE     SDJACCLB                                                 AR746766
      *
     C**********         DOW       NOT %EOF(SDJACCL4)                                       AR746766
     C                   DOW       NOT %EOF(SDJACCLB)                                       AR746766
      *
     C                   EVAL      DDCUST = JCCUST
     C                   EVAL      DDJCUS = JCJANO
      *
     C                   EVAL      KJcust = JCJANO
      *
      ** Check if Joint customer is present in Threshold file
      *
     C*****KJcust        CHAIN     SDTHRHL3                                                 AR746766
     C**********         IF        WJointFound = 'Y'                              MD025654 MD025654A
     C     JCCUST        CHAIN     SDTHRHL3                                                 AR746766
     C**********         ELSEIF    WJointFound = 'N'                              MD025654 MD025654A
     C*****KJcust        CHAIN     SDTHRHL3                                       MD025654 MD025654A
     C**********         ENDIF                                                    MD025654 MD025654A
     C                   IF        %FOUND(SDTHRHL3)
      *
      ** Retrieve and load the details of Joint customer
      *
     C                   EVAL      WWcext = TECEXT
     C                   EVAL      WWtrap = TETRAD
     C                   EVAL      WWtrvd = TETRVD
     C                   EVAL      WWtred = TETRMD
      *
     C                   EXSR      SRWrite
      *
      ** Consider the Non-account holder members                                           AR746766A
      *                                                                                    AR746766A
     C                   ELSEIF    JCNAHO <> *BLANKS                                       AR746766A
     C                   EXSR      SRWrite2                                                AR746766A
      *                                                                                    AR746766A
     C                   ELSE
      *
     C**********         EVAL      PReturn = '*NRF'                                        MD025654A
     C                   EVAL      WWcext = 0                                              MD025654A
     C                   EVAL      WWtrap = 0                                              MD025654A
     C                   EVAL      WWtrvd = 0                                              MD025654A
     C                   EVAL      WWtred = 0                                              MD025654A
     C                   EXSR      SRWrite                                                 MD025654A
      *
     C                   ENDIF
      *
     C*****KWcust        READE     SDJACCL4                                                 AR746766
     C     KWcust        READE     SDJACCLB                                                 AR746766
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite  - Write Records                                     *
      *                                                               *
      *  Called by: SRCustd , SRJCusd                                 *
      *                                                               *
      *  Calls: SRZfrPed , ZDATE2                                     *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
      ** Threshold Amount
      *
     C                   EVAL      PECode = 'J'
     C                   EVAL      PFld15 = WWcext
     C                   EXSR      SRZfrPed
     C                   EVALR     DDCEXT = %TRIMR(POut22)
      *
      ** Threshold Approval Date
      *
     C                   EVAL      ZDAYNO = 0
     C                   EVAL      ZDAYNO = WWtrap
     C                   EXSR      ZDATE2
     C                   EVAL      DDTRAP = ZDATE
      *
      ** Threshold Value Date
      *
     C                   EVAL      ZDAYNO = 0
     C                   EVAL      ZDAYNO = WWtrvd
     C                   EXSR      ZDATE2
     C                   EVAL      DDTRVD = ZDATE
      *
      ** Threshold Expiry Date
      *
     C                   EVAL      ZDAYNO = 0
     C                   EVAL      ZDAYNO = WWtred
     C                   EXSR      ZDATE2
     C                   EVAL      DDTRED = ZDATE
      *
     C                   EVAL      RRN = RRN + 1
      *
      ** Write a Record
      *
     C                   WRITE     SD000795S1
      *
     C                   EVAL      *IN81 = *OFF
      *
     C                   ENDSR
      *****************************************************************                    AR746766A
      /EJECT                                                                               AR746766A
      *****************************************************************                    AR746766A
      *                                                               *                    AR746766A
      *  SRWrite2 - Write Records for Non-Account Holder Members      *                    AR746766A
      *                                                               *                    AR746766A
      *  Called by: SRJCusd                                           *                    AR746766A
      *                                                               *                    AR746766A
      *  Calls: SRZfrPed                                              *                    AR746766A
      *                                                               *                    AR746766A
      *****************************************************************                    AR746766A
     C     SRWrite2      BEGSR                                                             AR746766A
      *                                                                                    AR746766A
     C                   EVAL      DDCUST = JCNAHO                                         AR746766A
     C                   EVAL      PECode = 'J'                                            AR746766A
     C                   EVAL      PFld15 = 0                                              AR746766A
     C                   EXSR      SRZfrPed                                                AR746766A
     C                   EVALR     DDCEXT = %TRIMR(POut22)                                 AR746766A
      *                                                                                    AR746766A
     C                   EVAL      DDTRAP = *ZEROS                                         AR746766A
     C                   EVAL      DDTRVD = *ZEROS                                         AR746766A
     C                   EVAL      DDTRED = *ZEROS                                         AR746766A
     C                   EVAL      RRN = RRN + 1                                           AR746766A
      *                                                                                    AR746766A
      ** Write a record                                                                    AR746766A
      *                                                                                    AR746766A
     C                   WRITE     SD000795S1                                              AR746766A
      *                                                                                    AR746766A
     C                   EVAL      *IN81 = *OFF                                            AR746766A
      *                                                                                    AR746766A
     C                   ENDSR                                                             AR746766A
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspl - Display Screen                                      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDspl        BEGSR
      *
      ** Check if no record is written in the subfile
      *
     C                   IF        RRN = 0
     C                   LEAVESR
     C                   ENDIF
      *
      ** Display SFL
      *
     C                   WRITE     SD000795F0
     C                   EXFMT     SD000795C1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZfrPed : Subroutine to perform Editing                     *
      *                                                               *
      *  Called by : SRFormat                                         *
      *                                                               *
      *  Calls: Nones                                                 *
      *                                                               *
      *****************************************************************
     C     SRZfrPed      BEGSR
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    POut22
     C                   PARM                    POut25
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      /COPY ZSRSRC,ZDATE2Z2LE
      *****************************************************************
      /COPY ZSRSRC,ZDATE2Z3
**  CPY@
(c) Finastra International Limited 2008
