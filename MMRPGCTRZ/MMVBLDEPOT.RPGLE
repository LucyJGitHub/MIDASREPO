     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Bill Depot Id.')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBLDEPOT - Validate Bill Depot Id.                         *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Bill depot ID and confirms whether it has a       *
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
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191947             Date 14Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 28Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  191947 - Bill Depot ID reverts to a blank even after         *
      *           amendment. Entry only allowed when the future and   *
      *           options module is present. Display error msg when   *
      *           entry is made and FT module is setoff.              *
      *         - Bill Depot ID is not properly passed.               *
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
 
      ** FO CUSTOMER DETAILS ACCESSED VIA ACCESS PROGRAM
     D SDFOCS        E DS                  EXTNAME(SDFOCSPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Bill Depot Id. received as a parameter
     D DDBDID          S             10A
 
      ** DEAL TYPE received as a parameter
     D DDMTYP          S              2A
 
      ** FUTURES & OPTIONS received as a parameter
     D @FFID           S              1A
 
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *-------------------------------*
      *  * Validate Bill Depot ID        *
      *  *-------------------------------*
      *
     C     @FFID         IFEQ      'Y'
     C     DDBDID        ANDNE     *BLANKS
      *
      * Entry is only allowed if TB deal type is entered
     C     DDMTYP        IFNE      'TB'
     C                   MOVEL     'MMM0526'     MSGID1
     C                   MOVE      'Y'           ErrorFound
      *
     C                   ELSE
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBDID        @CLKEY           10
     C                   PARM      '       '     @KYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *  Error if not on file
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'MMM0527'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
     C                   MOVEL     BBCUST        @BDKY             6
     C                   MOVEL     BBCUST        IRBDID            6 0                        191947
     C                   END
      *
      ** Chain to find out if customer is an FF&O customer no.
     C                   CALLB     'AOFOCSR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @BDKY         @AEND             6
     C     SDFOCS        PARM      SDFOCS        DSFDY
      ** If record not found then error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'MMM0527'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
      *
      *  Else the customer must be a broker
     C     BHBKIN        IFNE      'Y'
     C                   MOVEL     'MMM0528'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   END
      *                                                                                       191947
     C                   ELSE                                                                 191947
      *                                                                                       191947
     C     @FFID         IFEQ      'N'                                                        191947
     C     DDBDID        ANDNE     *BLANKS                                                    191947
     C                   MOVEL     'MMM0529'     MSGID1                                       191947
     C                   MOVE      'Y'           ErrorFound                                   191947
     C                   END                                                                  191947
      *                                                                                       191947
     C                   END
      *
      ** If an error was found, set the return code appropriately
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
     C                   PARM                    DDBDID
     C                   PARM                    DDMTYP
     C                   PARM                    @FFID
     C                   PARM                    IRBDID                                       191947
 
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
