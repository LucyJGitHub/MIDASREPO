     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Read')            *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  SDACUDRED - Additional Customer Details Read                 *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Additional Customer Details File      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13883           Date 07May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10069           Date 25Jan06               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (recompiled)                                        *
      *  BUG13883 - Customer field was validated to numeric.          *
      *             Apply changes when validating Customer field      *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction Details File - by transaction Number
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
                                                                                            BUG10069
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Country Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for *Entry
     D DDACTN          S              1A
     D DDCUST          S              6A
     D PRDFWD          S              1A
     D PRDBCK          S              1A
     D PERRMS          S              7A
     D PTRRED          S              6A
 
      ** Parameter for Access Objects
     D PRtcd           S              7A
     D POptn           S              7A
     D PKey1           S             10A
     D PKySt           S              7A
 
      ** Variables Used
     D WKCUST          S              6A
     D WKTEST          S              1A
     D PERR            S              1P 0
     D ZACTN           S              1A
                                                                                            BUG13883
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                 BUG13883
     D PRetCode        S              7A                                                    BUG13883
     D PSysValK1       S             20A                                                    BUG13883
     D PSysVal1        S            200A                                                    BUG13883
     D PSysValK2       S             20A                                                    BUG13883
     D PSysVal2        S            200A                                                    BUG13883
     D PSysValK3       S             20A                                                    BUG13883
     D PSysVal3        S            200A                                                    BUG13883
     D PSysValK4       S             20A                                                    BUG13883
     D PSysVal4        S            200A                                                    BUG13883
     D PSysValK5       S             20A                                                    BUG13883
     D PSysVal5        S            200A                                                    BUG13883
     D PSysValK6       S             20A                                                    BUG13883
     D PSysVal6        S            200A                                                    BUG13883
     D PSysValK7       S             20A                                                    BUG13883
     D PSysVal7        S            200A                                                    BUG13883
     D PSysValK8       S             20A                                                    BUG13883
     D PSysVal8        S            200A                                                    BUG13883
     D PSysValK9       S             20A                                                    BUG13883
     D PSysVal9        S            200A                                                    BUG13883
     D PSysValK10      S             20A                                                    BUG13883
     D PSysVal10       S            200A                                                    BUG13883
      *                                                                                     BUG13883
      * For holding the system values                                                       BUG13883
     DWCusAlphaAllow   S            200A                                                    BUG13883
     DWCusAlphChksum   S            200A                                                    BUG13883
     DWCusAlphaSupNum  S            200A                                                    BUG13883
      *                                                                                     BUG13883
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                        BUG13883
     D PCust           S              6A                                                    BUG13883
     D PValid          S              6A                                                    BUG13883
     D PCheckDigit     S              1A                                                    BUG13883
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialize outputs
 
     C                   EVAL      PERRMS = *Blanks
     C                   EVAL      PTRRED = *Blanks
 
      ** Check for user authority to browse if not multi-branching
 
     C                   IF        BJSBRC <> *Blanks
     C                   EXSR      SRChAutn
     C                   ENDIF
 
      ** Validate Customer Number (for pointer)
 
     C                   EXSR      SRValTrn
 
      ** Read forwards
 
     C                   IF        PRDFWD = 'Y'
     C                   EXSR      SRRdFwd
     C                   ELSE
 
      ** Read backwards
 
     C                   IF        PRDBCK = 'Y'
     C                   EXSR      SRRdBck
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdFwd - Read Forwards Through Transactions Details File
      *****************************************************************
     C     SRRdFwd       BEGSR
 
      ** Position to current record on file
 
     C     WKCUST        SETGT     SDACUSL1
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN99 = *ON or
     C                             E5CUST <> *Blanks and
     C                             PERR  = *Zeros and
     C                             E5TYLC <> 'D'
 
      ** Read next transaction
 
     C                   READ      SDACUSL1                               99
 
      ** Validate Record
 
     C                   IF        *IN99 = *OFF
     C                   EXSR      SRValidRec
     C                   ENDIF
 
     C                   ENDDO
 
      ** If end of file was encountered, report this fact
 
     C                   IF        *IN99 = *ON
     C                   EVAL      PERRMS = 'MMM1002'
 
      ** Else, return the transaction reference read
 
     C                   ELSE
     C                   EVAL      PTRRED = E5CUST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdBck - Read Backwards Through Transactions Details File
      *****************************************************************
     C     SRRdBck       BEGSR
 
      ** Position to current record on file
 
     C     WKCUST        SETLL     SDACUSL1
 
      ** Read until end of file or a valid record is found or an error
 
     C                   DOU       *IN99 = *ON or
     C                             E5CUST <> *Blanks and
     C                             PERR  = *Zeros and
     C                             E5TYLC <> 'D'
 
      ** Read previous transaction
 
     C                   READP     SDACUSL1                               99
 
      ** Validate Record
 
     C                   IF        *IN99 =*OFF
     C                   EXSR      SRValidRec
     C                   ENDIF
 
     C                   ENDDO
 
      ** If start of file was encountered, report this fact
 
     C                   IF        *IN99 = *ON
     C                   EVAL      PERRMS = 'MMM1003'
 
      ** Else, return the transaction reference read
 
     C                   ELSE
 
     C                   EVAL      PTRRED = E5CUST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValidRec - Validate Record Read
      *****************************************************************
     C     SRValidRec    BEGSR
 
     C                   Eval      PKey1 = E5CUST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD = '*NRF   '
     C     E5CUST        CHAIN     SDCDSHL1                                                 BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C                   EVAL      E5CUST = *Blanks
     C                   ENDIF                                                              BUG10069
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChAutn - Check For User Authority If Not Multi-Branching
      *****************************************************************
     C     SRChAutn      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    PERR
 
      ** Return Error Message
 
     C                   IF        PERR = 1
     C                   EVAL      PERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValTrn - Validate Customer Number Pointer
      *****************************************************************
     C     SRValTrn      BEGSR
 
      **  Validate that the Customer Number is numeric or blank.
 
     C                   TESTN                   DDCUST               98
     C                   MOVE      DDCUST        WKTEST
     C                   TESTZ                   WKTEST                   99
     C                   If        WCusAlphaAllow = 'Y'                                     BUG13883
     C                   Eval      PCust = DDCUST                                           BUG13883
     C                   Eval      PValid = *BLANKS                                         BUG13883
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                BUG13883
      * If Error                                                                            BUG13883
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                  BUG13883
     C                   Eval      DBFILE = 'SDCUSTISO'                                     BUG13883
     C                   Eval      DBASE = 913                                              BUG13883
     C                   Eval      DBKEY = PCust                                            BUG13883
     C                   ExSr      *PSSR                                                    BUG13883
     C                   EndIf                                                              BUG13883
      *                                                                                     BUG13883
     C                   EndIf                                                              BUG13883
     C                   IF        (DDCUST = *Blanks or                                     BUG13883
     C                             *IN98 = *ON and
     C**********                   *IN99 = *ON                                              BUG13883
     C                             *IN99 = *ON and WCusAlphaAllow = 'N')                    BUG13883
     C                             Or                                                       BUG13883
     C                             (WCusAlphaAllow = 'Y' And                                BUG13883
     C                              PValid = *BLANKS)                                       BUG13883
     C                             Or                                                       BUG13883
     C                             (DDCUST = *Blanks or                                     BUG13883
     C                             *IN98 = *ON and                                          BUG13883
     C                             *IN99 = *ON and WCusAlphaAllow = 'Y' and                 BUG13883
     C                             WCusAlphaSupNum = 'Y')                                   BUG13883
     C                   EVAL      WKCUST = DDCUST
 
      ** Return error message
 
     C                   ELSE
     C                   EVAL      PERRMS = 'MMM0162'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters :
      ** Return Code
      ** Action Code
      ** Transaction reference pointer
      ** Read Forwards
      ** Read Backwards
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    DDCUST
     C                   PARM                    PRDFWD
     C                   PARM                    PRDBCK
 
      ** Output Parameters :
      ** Error meassage
      ** Transaction read
     C                   PARM                    PERRMS
     C                   PARM                    PTRRED
 
      ** Initialize program name
      **                                                                                    BUG13883
     C     P_SDCUSTISO   PList                                                              BUG13883
      ** Customer Number (Input)                                                            BUG13883
     C                   Parm                    PCust                                      BUG13883
      ** Validity Flags (Output)                                                            BUG13883
     C                   Parm                    PValid                                     BUG13883
      ** Check Digit (Output)                                                               BUG13883
     C                   Parm                    PCheckDigit                                BUG13883
 
      ** Parameter list for calling AOSVALR0                                                BUG13883
     C     P_AOSVALR0    PList                                                              BUG13883
      * Return Code (Output)                                                                BUG13883
     C                   Parm                    PRetCode                                   BUG13883
      * System Value to be retrieved (Input)                                                BUG13883
     C                   Parm                    PSysValK1                                  BUG13883
      * Value returned (Output)                                                             BUG13883
     C                   Parm                    PSysVal1                                   BUG13883
     C                   Parm                    PSysValK2                                  BUG13883
     C                   Parm                    PSysVal2                                   BUG13883
     C                   Parm                    PSysValK3                                  BUG13883
     C                   Parm                    PSysVal3                                   BUG13883
     C                   Parm                    PSysValK4                                  BUG13883
     C                   Parm                    PSysVal4                                   BUG13883
     C                   Parm                    PSysValK5                                  BUG13883
     C                   Parm                    PSysVal5                                   BUG13883
     C                   Parm                    PSysValK6                                  BUG13883
     C                   Parm                    PSysVal6                                   BUG13883
     C                   Parm                    PSysValK7                                  BUG13883
     C                   Parm                    PSysVal7                                   BUG13883
     C                   Parm                    PSysValK8                                  BUG13883
     C                   Parm                    PSysVal8                                   BUG13883
     C                   Parm                    PSysValK9                                  BUG13883
     C                   Parm                    PSysVal9                                   BUG13883
     C                   Parm                    PSysValK10                                 BUG13883
     C                   Parm                    PSysVal10                                  BUG13883
      *                                                                                     BUG13883
     C                   EVAL      DBPGM = 'SDACUDRED'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            BUG13883
     C                   Eval      PRetCode = *BLANKS                                       BUG13883
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                             BUG13883
     C                   Eval      PSysVal1 = *BLANKS                                       BUG13883
     C                   Eval      PSysValK2 = 'CustAlphaChecksum'                          BUG13883
     C                   Eval      PSysVal2 = *BLANKS                                       BUG13883
     C                   Eval      PSysValK3 = 'CustAlphaSupNumeric'                        BUG13883
     C                   Eval      PSysVal3 = *BLANKS                                       BUG13883
     C                   Call(E)   'AOSVALR0'    P_AOSVALR0                                 BUG13883
      *                                                                                     BUG13883
      * If Error retrieving the System value                                                BUG13883
     C                   If        %Error Or PRetCode <> *BLANKS                            BUG13883
     C                             Or (*INU7 = *ON And *INU8 = *ON)                         BUG13883
     C                   Eval      DBFILE = 'SDSVALPD'                                      BUG13883
     C                   Eval      DBASE = 914                                              BUG13883
     C                   Eval      DBKEY = 'CustAlpha(Allow/Chk/SupNum)'                    BUG13883
     C                   ExSr      *PSSR                                                    BUG13883
     C                   EndIf                                                              BUG13883
      *                                                                                     BUG13883
     C                   Eval      WCusAlphaAllow  = PSysVal1                               BUG13883
     C                   Eval      WCusAlphChksum  = PSysVal2                               BUG13883
     C                   Eval      WCusAlphaSupNum = PSysVal3                               BUG13883
      *                                                                                     BUG13883
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2004
