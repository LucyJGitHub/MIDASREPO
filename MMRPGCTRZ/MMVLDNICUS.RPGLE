     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
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
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
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
     C     DDTYPE        IFEQ      'TD'
     C     DDTYPE        OREQ      'TI'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1064'     Msgid2
     C                   END
     C*
     C                   ELSE
      *
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'IT'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1065'     Msgid2
     C                   END
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
(c) Misys International Banking Systems Ltd. 2001
