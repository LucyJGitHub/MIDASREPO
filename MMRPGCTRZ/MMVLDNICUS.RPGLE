     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Customer number (Loans/Deposits)')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVLDNICUS - Validate Customer Shortname or number           *
      *               (Loans and Deposits)
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             customer shortname or number and confirms if      *
      *             valid. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD061665           Date 28Nov23               *
      *  Prev Amend No. CDL101             Date 01Dec22               *            
      *                 MD060528           Date 16Sep22               *
      *                 CDL063             Date 02Nov21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061665 - Correct the validatio on Bank/NonBank Ind. for    *
      *             IP/IT Deal Types.                                 *
      *  CDL101   - Remove validation on Bank/NonBank Ind. for IP/IT  *
      *             Deal Types                                        *      
      *  MD060528 - CDL063 fix - Split system value AllowBankNBankCpty*
      *             into two - AllowBankForTDTIDeal and               *
      *             AllowNonBankForIPIT                               *
      *           - CDL063 became non-switchable feature. It is       *
      *             replaced by system value.                         *
      *  CDL063 - Allow non-bank/bank counterparty on certain         *
      *           deal types                                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CPB001 - 'Private Banking' Module                            *
      *           (Just Recompile)                                    *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program, procedure and module names for parameters
      ** ==================================================

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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                CDL006
      ** External data structure for access programs (2000 chars long)          CDL006
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CDL006

      ** External data structure for Customer Details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
                                                                                              CSD025
      ** External data structure for access programs (short)                                  CSD025
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD025

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** Constant paramater for AOSVALR0                                                    MD060528
     D NBankIPIT       S              1A                                                    MD060528
     D BankTDTI        S              1A                                                    MD060528
                                                                                            MD060528
     D P@RTCD          S              7A                                                    MD060528
     D P@OP01          S             20A                                                    MD060528
     D P@VL01          S            200A                                                    MD060528
     D P@OP02          S             20A                                                    MD060528
     D P@VL02          S            200A                                                    MD060528
     D P@OP03          S             20A                                                    MD060528
     D P@VL03          S            200A                                                    MD060528
     D P@OP04          S             20A                                                    MD060528
     D P@VL04          S            200A                                                    MD060528
     D P@OP05          S             20A                                                    MD060528
     D P@VL05          S            200A                                                    MD060528
     D P@OP06          S             20A                                                    MD060528
     D P@VL06          S            200A                                                    MD060528
     D P@OP07          S             20A                                                    MD060528
     D P@VL07          S            200A                                                    MD060528
     D P@OP08          S             20A                                                    MD060528
     D P@VL08          S            200A                                                    MD060528
     D P@OP09          S             20A                                                    MD060528
     D P@VL09          S            200A                                                    MD060528
     D P@OP10          S             20A                                                    MD060528
     D P@VL10          S            200A                                                    MD060528
                                                                                            MD060528
     D W#NBnkDeal      C                   CONST('AllowNonBankForIPIT')                     MD060528
     D W#BankDeal      C                   CONST('AllowBankForTDTIDeal')                    MD060528

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#Msgid)

      ** Error Message code 2 received as a parameter
     D Msgid2          S                   LIKE(#Msgid)

      ** Customer Number/Shortname received as a paramaterr
     D DDCUST          S             10A

      ** Deal Type received as a paramater
     D DDTYPE          S              2A

      ** Output Customer Number passed as parameter
     D*IKCNUM***       S              6S 0                                                    CSD027
     D IKCNUM          S              6A                                                      CSD027

      ** Customer Shortname field passed as a parameter
     D IKCSNM          S             10A
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      **  Customer must not be blank
      *
     C     DDCUST        IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0204'     Msgid1
     C                   END
      *
      **  If customer is not blank, validate it.
      *
     C     DDCUST        IFNE      *BLANKS
      *
      * Call Access Prog. for Customer Details.
     C***********        CALL      'AOCUSTR0'                                   CDL006
     C                   CALL      'AOCUSTR1'                                   CDL006
      *
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCUST        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                          CDL006
     C     SDCUST        PARM      SDCUST        DSLDY                          CDL006
     C*
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         OREQ      '*ERROR '
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0205'     Msgid1
     C                   ELSE
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     *BLANKS       DDCUST
     C                   MOVEL     BBCUST        DDCUST
     C                   ELSE
     C                   MOVEL     BBCSSN        DDCUST
     C                   END
                                                                                              CSD025
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
                                                                                              CSD025
     C                   EVAL      ErrorFound = 'Y'                                           CSD025
     C                   MOVEL     'ABM0028'     MSGID1                                       CSD025
                                                                                              CSD025
     C                   ENDIF                                                                CSD025
     C                   END
      *
      **  If no errors so far
      *
     C     ErrorFound    IFNE      'Y'
      *
      **  Check that the customer is not a parent
      *
     C     BBPAIN        IFEQ      'P'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0206'     Msgid1
     C                   END
      *
      ** Check for bank/non bank and deal types
      *
     C     BBBNBI        IFEQ      'Y'
      *
      ** Customer is a bank
      *
      ***If*CDL063*is*on,*bypass*the*validation*for*bank                             CDL063 MD060528
      **********                                                                     CDL063 MD060528
     C*****CDL063        IFNE      'Y'                                               CDL063 MD060528
     C     BankTDTI      IFNE      'Y'                                                      MD060528
     C     DDTYPE        IFEQ      'TD'
     C     DDTYPE        OREQ      'TI'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1064'     Msgid2
     C                   END
     C                   ENDIF                                                                CDL063
     C*
     C                   ELSE
      *
      ***If*CDL063*is*on,*bypass*the*validation*for*non-bank                         CDL063 MD060528
      **********                                                                     CDL063 MD060528
     C*****CDL063        IFNE      'Y'                                               CDL063 MD060528
     C     NBankIPIT     IFNE      'Y'                                                      MD060528
     C*****CDL101        OREQ      'N'                                               CDL101 MD061665
     C     CDL101        ANDEQ     'N'                                                      MD061665     
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'IT'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1065'     Msgid2
     C                   END
     C                   ENDIF                                                                CDL063
     C                   END

     C                   END
      *
      **  If the customer is valid, update output fields
      *
     C     ErrorFound    IFNE      'Y'
     C                   MOVEL     BBCUST        IKCNUM
     C                   MOVE      BBCSSN        IKCSNM
     C                   ELSE
     C**********         Z-ADD     0             IKCNUM                                       CSD027
     C                   EVAL      IKCNUM = *BLANKS                                           CSD027
     C                   MOVE      *BLANKS       IKCSNM
     C                   END

     C                   END

     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    CustFormat        1
     C                   PARM                    DDCUST
     C                   PARM                    DDTYPE
     C                   PARM                    IKCNUM
     C                   PARM                    IKCSNM
     C                   PARM                    SDCUST
     C                   PARM                    DDACTN            1                          CSD025

      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd             7                          CSD025
     C                   PARM      '*VERIFY'     POptn             7                          CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
      ** Check if CDL101 (IP/IT deal types check) is active                                   CDL101
      *                                                                                       CDL101
     C                   CALLB     'AOSARDR0'                                                 CDL101
     C                   PARM      *BLANKS       PRtCd             7                          CDL101
     C                   PARM      '*VERIFY'     POptn             7                          CDL101
     C                   PARM      'CDL101'      PSARD             6                          CDL101
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL101
                                                                                              CDL101
     C                   MOVE      'N'           CDL101            1                          CDL101
     C                   IF        PRtCd = *Blanks                                            CDL101
     C                   EVAL      CDL101 = 'Y'                                               CDL101
     C                   ENDIF                                                                CDL101
                                                                                              CDL101                                                                                              
     C**********         CALLB     'AOSARDR0'                                        CDL063 MD060528
     C**********         PARM      *BLANKS       PRtCd             7                 CDL063 MD060528
     C**********         PARM      '*VERIFY'     POptn             7                 CDL063 MD060528
     C**********         PARM      'CDL063'      PSARD             6                 CDL063 MD060528
     C*****SCSARD        PARM      SCSARD        DSFDY                               CDL063 MD060528
      **********                                                                     CDL063 MD060528
     C**********         MOVE      'N'           CDL063            1                 CDL063 MD060528
     C**********         IF        PRtCd = *Blanks                                   CDL063 MD060528
     C**********         EVAL      CDL063 = 'Y'                                      CDL063 MD060528
     C**********         ENDIF                                                       CDL063 MD060528
      *                                                                                       CDL063
      ** Access Midas System values via access program                                      MD060528
      *                                                                                     MD060528
     C                   CALLB     'AOSVALR0'                                               MD060528
     C                   PARM                    @RTCD             7                        MD060528
     C                   PARM      W#NBnkDeal    P@OP01                                     MD060528
     C                   PARM                    P@VL01                                     MD060528
     C                   PARM      W#BankDeal    P@OP02                                     MD060528
     C                   PARM                    P@VL02                                     MD060528
     C                   PARM                    P@OP03                                     MD060528
     C                   PARM                    P@VL03                                     MD060528
     C                   PARM                    P@OP04                                     MD060528
     C                   PARM                    P@VL04                                     MD060528
     C                   PARM                    P@OP05                                     MD060528
     C                   PARM                    P@VL05                                     MD060528
     C                   PARM                    P@OP06                                     MD060528
     C                   PARM                    P@VL06                                     MD060528
     C                   PARM                    P@OP07                                     MD060528
     C                   PARM                    P@VL07                                     MD060528
     C                   PARM                    P@OP08                                     MD060528
     C                   PARM                    P@VL08                                     MD060528
     C                   PARM                    P@OP09                                     MD060528
     C                   PARM                    P@VL09                                     MD060528
     C                   PARM                    P@OP10                                     MD060528
     C                   PARM                    P@VL10                                     MD060528
      *                                                                                     MD060528
     C                   IF        P@RTCD <> *BLANKS                                        MD060528
     C     *LOCK         IN        LDA                                                      MD060528
     C                   IF        P@VL01 = '*NRF'                                          MD060528
     C                   EVAL      DBKEY  = P@OP01                                          MD060528
     C                   ENDIF                                                              MD060528
     C                   IF        P@VL02 = '*NRF'                                          MD060528
     C                   EVAL      DBKEY  = P@OP02                                          MD060528
     C                   ENDIF                                                              MD060528
     C                   EVAL      DBASE  = 001                                             MD060528
     C                   EVAL      DBFILE = 'SCSVLXTD'                                      MD060528
     C                   EVAL      DBPGM  = 'MMVLDNICUS'                                    MD060528
     C                   OUT       LDA                                                      MD060528
     C                   EXSR      *PSSR                                                    MD060528
     C                   ENDIF                                                              MD060528
                                                                                            MD060528
      ** Setup AllowBankForTDTIDeal and AllowNonBankForIPIT system values                   MD060528
                                                                                            MD060528
     C                   EVAL      NBankIPIT = P@VL01                                       MD060528
     C                   EVAL      BankTDTI  = P@VL02                                       MD060528

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
