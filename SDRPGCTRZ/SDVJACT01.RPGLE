     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Joint Account Type')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVJACT01 - Validate Joint Account Type                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR739736           Date 01Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24250           Date 09Jun09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 BUG10069           Date 25Jan06               *
      *                 CSD029             Date 22Aug05               *
      *                 234834             Date 10Aug05               *
      *                 234577             Date 29Jun05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR739736 - USR4761: Joint Account Type cannot be "I"         *
      *             Customer is a Bank (Child:AR739761)               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24250 - A database error has occurred.                    *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  CSD029 - Customer Details Additional Fields (Recompile)      *
      *  234834 - If system setup flag is still 'N', joint account    *
      *           type should still be changed from blank or N to I   *
      *           or Y even if position exists for the customer.      *
      *  234577 - Joint account type cannot be changed from blank or  *
      *           N to I or Y when a Securities Trading position      *
      *           exists for the client                               *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
                                                                                            BUG10069
     FCPOSCS    IF   E           K DISK                                                       234577
      ** Midas SE Customer Positions by Customer                                              234577
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Country Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Additional Customer Details                                          234577
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                  234577
                                                                                              234577
      ** External DS for Rundat dataarea                                                      234834
     D RUNDAT        E DS                  EXTNAME(RUNDAT)                                    234834
                                                                                              234834
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CSD079
      * First DS for Access programs - short data structure                                   CSD079
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD079
                                                                                              CSD079
      ** EXTERNAL DS FOR SAR DETAILS                                                          CSD079
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD079
                                                                                              CSD079
     D PSARD           S              6                                                       CSD079
                                                                                              CSD079
     D CSD079          S              1A   INZ('N')                                           CSD079
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1A
     D DDCUST          S              6A
     D DDJATP          S              1A
     D DDBNBI          S              1A                                                    AR739736
     D DDOKJATP        S              1A
     D WrkJATP         S              1A                                                      234577
     D PosInd          S              1A                                                      234577
 
      ** Parameter for Access Object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKEY2           S              6A                                                      234577
     D*PKEY3****       S              6S 0                                            234577 CSD027A
     D PKEY3           S              6A                                                     CSD027A
     D PKYST           S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Validation
 
     C                   EXSR      SRVJATP
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKJATP = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVJATP - Validate Joint Account Type                         *
      *                                                               *
      *****************************************************************
 
     C     SRVJATP       BEGSR
 
      ** Valid values are 'Y', 'N' , 'I' or Blank
 
     C                   IF        DDJATP <> 'Y'  and
     C                             DDJATP <> 'N'  and
     C                             DDJATP <> 'I'  and
     C                             DDJATP <> *Blanks
     C                   EVAL      DDOKJATP = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDJATP'      FldNamXAr(Idx)
     C                   MOVEL     'USR4760'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If customer is a bank, joint account type cannot be 'I'
 
     C**********         IF        BBBNBI =  'Y'     and                                    AR739736
     C                   IF        DDBNBI = 'Y' AND                                         AR739736
     C                             DDJATP = 'I'
     C                   EVAL      DDOKJATP = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDJATP'      FldNamXAr(Idx)
     C                   MOVEL     'USR4761'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
                                                                                              234577
      ** If customer is not a private customer, joint account type                            234577
      ** cannot be 'I' or 'Y' when a Securities Trading position exists                       234577
      ** Do this check only when system setup flag is already complete                        234834
                                                                                              234577
     C                   IF        AGSUC = 'Y'                                                234834
     C                   IF        WrkJATP = 'N'                                              234577
     C                             AND DDJATP = 'I'                                           234577
     C                             AND PosInd = 'Y'                                           234577
     C                             OR WrkJATP = 'N'                                           234577
     C                             AND DDJATP = 'Y'                                           234577
     C                             AND PosInd = 'Y'                                           234577
     C                   EVAL      DDOKJATP = 'N'                                             234577
     C                   ADD       1             Idx                                          234577
     C                   MOVEL     'DDJATP'      FldNamXAr(Idx)                               234577
     C                   MOVEL     'USR4804'     MsgIDXAr(Idx)                                234577
     C                   GOTO      ENDVAL                                                     234577
     C                   ENDIF                                                                234577
     C                   ENDIF                                                                234834
 
      ** Set up Joint Account Type, default to 'N' if blank.
 
     C                   IF        DDJATP = *Blanks
     C                   EVAL      DDJATP = 'N'
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Check customer details
 
     C                   MOVEL     DDCUST        PKEY1
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *Blanks
                                                                                            BUG10069
      ** Check the shadow file.                                                             BUG10069
                                                                                            BUG10069
     C     DDCUST        CHAIN     SDCDSHL1                                                 BUG10069
                                                                                            BUG10069
     C**********         IF        NOT %FOUND                                        BUG10069 CSD079
     C                   IF        NOT %FOUND  AND                                            CSD079
     C                             CSD079 = 'N'                                               CSD079
     C     *LOCK         IN        LDA                                                      BUG10069
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = PKEY1
     C                   OUT       LDA                                                      BUG10069
     C                   EXSR      *PSSR
     C                   ENDIF                                                              BUG10069
                                                                                            BUG10069
     C                   ENDIF
                                                                                              234577
      ** Check additional customer details                                                    234577
                                                                                              234577
     C                   MOVEL     DDCUST        PKEY2                                        234577
                                                                                              234577
     C                   CALL      'AOACUSR0'                                                 234577
     C                   PARM      *Blanks       PRTCD                                        234577
     C                   PARM      '*KEY   '     POPTN                                        234577
     C                   PARM                    PKEY2                                        234577
     C     SDACUS        PARM      SDACUS        DSSDY                                        234577
                                                                                              234577
      ** Database Error                                                                       234577
                                                                                              234577
     C                   IF        PRTCD <> *Blanks                                           234577
     C                             AND PRTCD <> '*NRF   '                                     234577
     C                             AND PRTCD <> '*CUSDEL'                                   BUG24250
     C                   EVAL      DBFILE = 'AOACUSPD'                                        234577
     C                   EVAL      DBASE = 002                                                234577
     C                   EVAL      DBKEY = PKEY2                                              234577
     C                   EXSR      *PSSR                                                      234577
     C                   ENDIF                                                                234577
                                                                                              234577
      ** No record found                                                                      234577
                                                                                              234577
     C                   IF        PRTCD = '*NRF   '                                          234577
     C                   EVAL      WrkJATP = 'N'                                              234577
     C                   ELSE                                                                 234577
     C     E5JATP        IFNE      *Blank                                                     234577
     C                   EVAL      WrkJATP = E5JATP                                           234577
     C                   ELSE                                                                 234577
     C                   EVAL      WrkJATP = 'N'                                              234577
     C                   ENDIF                                                                234577
     C                   ENDIF                                                                234577
                                                                                              234577
      ** Check whether a Securities Trading position exists for the customer                  234577
                                                                                              234577
     C                   MOVEL     DDCUST        PKEY3                                        234577
                                                                                              234577
     C                   MOVE      'N'           PosInd                                       234577
     C     PKEY3         CHAIN     CPOSCS                             81                      234577
     C     *IN81         IFEQ      *OFF                                                       234577
     C     CSNV          ANDNE     *ZERO                                                      234577
     C                   MOVE      'Y'           PosInd                                       234577
     C                   ENDIF                                                                234577
                                                                                              234577
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Number
     C                   PARM                    DDCUST
 
      ** Joint Account Type
     C                   PARM                    DDJATP
                                                                                            AR739736
      ** Bank/non-bank Indicator                                                            AR739736
     C                   PARM                    DDBNBI                                     AR739736
 
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
     C                   PARM                    DDOKJATP
 
      ** Check if enhancement CSD079 is on                                                    CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CSD079'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CSD079'                                          CSD079
     C                   EVAL      DBASE  = 910                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD079 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD079 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      *                                                                                       234834
      ** Read data area RUNDAT                                                                234834
      *                                                                                       234834
     C     *DTAARA       DEFINE                  RUNDAT                                       234834
     C                   IN        RUNDAT                                                     234834
      *                                                                                       234834
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
