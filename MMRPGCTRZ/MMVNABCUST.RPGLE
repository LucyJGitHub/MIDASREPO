     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate NA bought Customer             ')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNABCUST - Validate NA's Bought Customer                   *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Customer short name and checks whether it has a   *
      *             valid value.                                      *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 12Nov97               *
      *                                    Date DDMmmYY               *
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
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
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
 
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error messages field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
      ** Bought From Customer - received as a parameter
     D DDCSNM          S             10A
      ** Deal Type                         - received as a parameter
     D DDMTYP          S              2A
      ** Bought From Cust.Number  (MMSTDBPP) received as a parameter
     D*IHCNUM***       S              6S 0                                                    CSD027
     D IHCNUM          S              6A                                                      CSD027
      ** Bought From Cust.Shortname (MMSTDBPP) received as a parameter
     D IHCSNM          S             10A
 
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
      ** ¦ Initial processing is performed automatically: the *INZ        ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *----------------------------------*
      *  * Validate Bought From Customer    *
      *  *----------------------------------*
      *
      **  If deal type is not C1, bought from customer must not be blank
      *
     C     DDMTYP        IFNE      'C1'
     C     DDCSNM        ANDEQ     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0504'     MSGID1
     C                   END
      *
      **  If the input is not blank, validate it.
      *
     C     DDCSNM        IFNE      *BLANKS
      *
      **  If deal type is C1, bought from customer must be blank
      *
     C     DDMTYP        IFEQ      'C1'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0208'     MSGID1
     C                   END
      *
      * Call Access Prog. for Customer Details.
     C                   CALLB     'AOCUSTR0'
      *
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCSNM        @CLKEY           10
     C                   PARM      '       '     @KYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C     @KYSTS        OREQ      '*ERROR'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0205'     MSGID1
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
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0206'     MSGID1
     C                   END
 
     C                   ENDIF
      *
      **  If the customer is valid, set up the outputs
      *
     C     ErrorFound    IFNE      'Y'
     C                   MOVE      BBCUST        IHCNUM
     C                   MOVE      BBCSSN        IHCSNM
     C                   ELSE
     C**********         Z-ADD     0             IHCNUM                                       CSD027
     C                   EVAL      IHCNUM = *BLANKS                                           CSD027
     C                   MOVE      *BLANKS       IHCSNM
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
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
      * customer format
      * N = customer number, else customer shortname
     C                   PARM                    CustFormat        1
      ** Bought From Customer
     C                   PARM                    DDCSNM           10
      ** Deal Type
     C                   PARM                    DDMTYP            2
      ** Bought From Customer Number
     C                   PARM                    IHCNUM
      ** Bought From Customer Shortname
     C                   PARM                    IHCSNM           10
 
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
