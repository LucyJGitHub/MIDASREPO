     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Customer number (Deal Amendmnts)')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMCUS - Validate Customer Shortname or number           *
      *               (for Deal Amendment processing)                 *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
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
 
      ** External data structure for Customer Details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
                                                                                              CSD025
      ** DS for Access Objects - short data structure                                         CSD025
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD025
                                                                                              CSD025
      ** DS for Access Objects - very long data structure                                     CSD025
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD025
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Customer Number/Shortname received as a paramaterr
     D DDCSNM          S             10A
 
      ** Output Customer Number passed as parameter
     D*IGCNUM***       S              6S 0                                                    CSD027
     D IGCNUM          S              6A                                                      CSD027
 
      ** Customer Number from related deal passed as parameter
     D*H@CNUM***       S              6  0                                                    CSD027
     D H@CNUM          S              6A                                                      CSD027
 
      ** Customer Shortname field passed as a parameter
     D IGCSNM          S             10A
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
     C     DDCSNM        IFEQ      *BLANKS                                      B1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0204'     Msgid1
     C                   END
      *
      **  If customer is not blank, validate it.
      *
     C     DDCSNM        IFNE      *BLANKS
      *
      * Call Access Prog. for Customer Details.
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
      *
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCSNM        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD025
     C*
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         OREQ      '*ERROR '
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0205'     Msgid1
     C                   ELSE
     C     CustFormat    IFEQ      'N'
     C                   MOVEL     *BLANKS       DDCSNM
     C                   MOVEL     BBCUST        DDCSNM
     C                   ELSE
     C                   MOVEL     BBCSSN        DDCSNM
     C                   END
     C                   END
      *
      **  If a record was found, check that the customer is not a
      **  parent.
     C     ErrorFound    IFNE      'Y'
     C     BBPAIN        ANDEQ     'P'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0206'     Msgid1
     C                   END
      *
      * Check for De-Activation if CSD025 is active                                           CSD025
                                                                                              CSD025
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
                                                                                              CSD025
     C                   MOVE      'Y'           ErrorFound                                   CSD025
     C                   MOVEL     'ABM0028'     Msgid1                                       CSD025
                                                                                              CSD025
     C                   ENDIF                                                                CSD025
                                                                                              CSD025
      **  If the customer is valid, update output fields
      *
     C     ErrorFound    IFNE      'Y'
     C                   MOVE      BBCUST        IGCNUM
     C                   MOVE      BBCSSN        IGCSNM
      *
      ** Compare customer number with that from related deal
      *
     C     IGCNUM        IFNE      H@CNUM                                       B**3
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0474'     Msgid1
     C                   END
 
     C                   ELSE
     C**********         Z-ADD     0             IGCNUM                                       CSD027
     C                   EVAL      IGCNUM = *BLANKS                                           CSD027
     C                   MOVE      *BLANKS       IGCSNM
     C                   END
 
     C                   END
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
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
     C                   PARM                    CustFormat        1
     C                   PARM                    DDCSNM
     C                   PARM                    IGCNUM
     C                   PARM                    IGCSNM
     C                   PARM                    H@CNUM
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
(c) Finastra International Limited 2001
