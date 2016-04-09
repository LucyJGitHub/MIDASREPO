     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate book code')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBOOKCDE - Validate book code                              *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             book code and confirms whether it has a valid     *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: MMVALIDATE - MM validation service program     *
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
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CPB001 - 'Private Banking' Module                            *
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                CPB001
      ** External data structure for access programs (very Long)                CPB001
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
 
      ** External data structure for book codes file
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** Input parameters on call to AOPLCSR2
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR2
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
      ** External data structure for portfolio management details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
                                                                                              CPB001
      ** External data structure for customer details                                         CPB001
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CPB001
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Book code optional? field (ICD) received as a parameter
     D BNBcop          S              1A
      ** Book code from SDDEALPD received as a parameter
     D BNBkcd          S              2A
      ** Book code is received as a parameter
     D DDBokc          S              2A
      ** Booking branch
     D DDBRCA          S              3A
      ** Customer number received as a parameter
     D DDCUST          S             10A
     D DDPTFR          S              4A
      ** Bank portfolio supported flag received as a parameter
     D FCPors          S              1A
     D FCR997          S              4A
      ** Error code from SDPLCSPD (used by MMVPORTREF)
     D ERPLCS          S              7A
      ** O#PTFR from SDPLCSPD (used by MMVPORTREF)
     D PortRef         S              4A
      ** QBCUST from SDPLCSPD (used by MMVPORTREF)
     D PortCust        S              6A
      ** Portfolio managmenet indicator                                         CPB001
     D BGPFMG          S              1A                                        CPB001
      ** Private Banking indicator                                              CPB001
     D BGN4ST          S              1A                                        CPB001
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Error message IDs / data from AOPLCSR2
     D Msgid2          S                   LIKE(#MsgID)
     D Msgid3          S                   LIKE(#MsgID)
     D Msgid4          S                   LIKE(#MsgID)
 
     D MsgData2        S                   LIKE(#MsgData)
     D MsgData3        S                   LIKE(#MsgData)
     D MsgData4        S                   LIKE(#MsgData)
 
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
     C                   RESET                   Msgid2
     C                   RESET                   Msgid3
     C                   RESET                   Msgid4
     C                   RESET                   MsgData2
     C                   RESET                   MsgData3
     C                   RESET                   MsgData4
     C                   MOVEL     *BLANKS       SvDDCUST          1            CPB001
      *
      ** If Customer has been entered as '?' make it blank for the              CPB001
      ** purposes of this module.                                               CPB001
      *                                                                         CPB001
     C                   IF        DDCUST = '?'                                 CPB001
     C                   MOVEL     '?'           SvDDCUST                       CPB001
     C                   MOVEL     *BLANKS       DDCUST                         CPB001
     C                   ENDIF                                                  CPB001
      *
      ** Access Portfolio Management Customer Details
      **
      *
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C                   MOVEL     DDCUST        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     DDBOKC        I#BOOK
     C                   MOVEL     DDPTFR        I#PTFR
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     PSProcPgm     I#CPGM
      *
     C                   CALLB     'AOPLCSR2'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C                   PARM                    MsgID2
     C                   PARM                    MsgID3
     C                   PARM                    MsgID4
     C                   PARM                    MsgData2
     C                   PARM                    MsgData3
     C                   PARM                    MsgData4
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
     C                   MOVEL     I#CUST        DDCUST
     C                   MOVEL     P@RTCD        ERPLCS
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
      ***  Portfolio Reference must be entered if PB customer                   CPB001
      *                                                                         CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   CALLB     'AOCUSTR1'                                   CPB001
     C                   PARM      *BLANKS       WWRTCD            7            CPB001
     C                   PARM      '*KEY   '     WWOPTN            7            CPB001
     C                   PARM      DDCUST        WWCUST           10            CPB001
     C                   PARM                    WWKEY7            7            CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
      *                                                                         CPB001
      ***  Reset Error message If PB Customer                                   CPB001
      *                                                                         CPB001
     C     WWRTCD        IFEQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVE      *BLANKS       MsgID2                         CPB001
     C                   MOVE      *BLANKS       MsgID3                         CPB001
     C                   MOVE      *BLANKS       MsgID4                         CPB001
     C                   MOVE      *BLANKS       MsgData2                       CPB001
     C                   MOVE      *BLANKS       MsgData3                       CPB001
     C                   MOVE      *BLANKS       MsgData4                       CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *
      ** Book code defaulting:
      ** 1) If Book Code Optional from DL ICD is 'Y', default book
      **    code to SDDEALPD/BNBKCD
      ** 2) Else, if Bank Portfolio is supported default book code
      **    to output book code determined from AOPLCSR2 (added by
      **    CPM004)
      ** 3) Else, send error message, book code is mandatory.
      *
     C     DDBOKC        IFEQ      *BLANKS
      *
     C     BNBCOP        IFNE      'Y'
      *
     C     FCPORS        IFEQ      'B'
     C     ERPLCS        ANDEQ     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     O#BOOK        DDBOKC
     C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM1037'     Msgid1
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      BNBKCD        DDBOKC
     C                   END
      *
     C                   END
      *
     C     DDBOKC        IFNE      *BLANKS
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBOKC        @A1CD             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM1038'     Msgid1
 
     C                   ELSE                                                                  E70
     C                   MOVEL     BDBKCD        DDBOKC                                        E70
 
     C                   END
     C                   END
 
      ** Set up parameter to pass back O#PTFR which is needed by MMVPORTREF
     C                   MOVE      O#PTFR        PortRef
 
      ** Set up parameter to pass back QBCUST which is needed by MMVPORTREF
     C                   MOVE      QBCUST        PortCust
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** If Customer was entered as '?', reinstate this value to DDCUST         CPB001
      *                                                                         CPB001
     C                   IF        SvDDCUST = '?'                               CPB001
     C                   MOVEL     '?'           DDCUST                         CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
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
     C                   PARM                    Msgid3
     C                   PARM                    Msgid4
     C                   PARM                    MsgData2
     C                   PARM                    MsgData3
     C                   PARM                    MsgData4
     C                   PARM                    DDBokc
     C                   PARM                    BNBcop
     C                   PARM                    FCPors
     C                   PARM                    BNBkcd
     C                   PARM                    DDCust
     C                   PARM                    DDPtfr
     C                   PARM                    DDBrca
     C                   PARM                    FCR997
     C                   PARM                    ERPLCS
     C                   PARM                    PortRef
     C                   PARM                    PortCust
     C                   PARM                    BGPFMG                         CPB001
     C                   PARM                    BGN4ST                         CPB001
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
