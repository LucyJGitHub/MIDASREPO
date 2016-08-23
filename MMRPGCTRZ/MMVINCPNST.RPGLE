     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate interest counterparty nostro')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVINCPNST - Validate interest counterparty nostro           *
      *                                                               *
      *  Function:  This module validatea the interest counterparty   *
      *             nostro field of a Money Market transaction        *
      *                                                               *
      *  Component of: MMVALIDATE - Money Market validation service   *
      *                             program                           *
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
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP004 - API's Phase 3.                                      *
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
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** EXTERNAL DS FOR COUNTERPARTY NOSTRO DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
      **  Data structure for Interest Counterparty Nostro
     D  DDINOS                 1     10
     D  ICUSN                  1      6
     D  IZZ04                  7     10
     D  INOSN                  1      8
     D  IZZ02                  9     10
     D*
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Interest counterparty nostro
     D IntCPNost       S                   LIKE(DDINOS)
 
      ** Interest settlement method
     D DDIMET          S              2A
 
      ** Message ID
     D MSGID1          S                   LIKE(#MsgID)
 
      ** Enhanced rollovers processing feature flag
     D S01434          S              1A
 
      ** End of parameters
      ** =================
 
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
 
      ** Reset error found flag to prevent problems on later calls
     C                   RESET                   ErrorFound
 
      ** Copy received parameter to field used by module (this is done
      ** because DDINOS is a data-structure subfield, and so cannot
      ** be on the entry parameter list).
     C                   EVAL      DDINOS = IntCPNost
 
     C** Only validate if Enhanced Rollovers processing switched on
     C*
     C     S01434        IFEQ      'Y'
     C*
     C** Should only be input if Interest Settlement Method entered
     C*
     C     DDINOS        IFNE      *BLANKS
     C     DDIMET        IFEQ      *BLANKS
     C     DDIMET        OREQ      '00'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0647'     MsgID1
     C                   ELSE
     C*
     C** See if it is a customer number
     C*
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDINOS        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *                                                                         CAP004
      * If a valid customer has been selected from the prompt screen            CAP004
      * then set the screen field value accordingly                             CAP004
      *                                                                         CAP004
     C     @RTCD         IFEQ      *BLANKS                                      CAP004
     C     @KYST         ANDEQ     '*CNUM  '                                    CAP004
     C                   MOVEL     @KEY1         IntCPNost                      CAP004
     C                   ENDIF                                                  CAP004
     C*
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         IFEQ      '*CNUM  '
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0648'     MsgID1
     C                   ELSE
     C*
     C** See if it is a counterparty nostro
     C*
     C                   CALLB     'AOCNSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      INOSN         @ARCD             8
     C     SDCNST        PARM      SDCNST        DSFDY
      *                                                                         CAP004
      * If a valid counterparty nostro has been selected from the               CAP004
      * prompt screen then set the screen field value accordingly               CAP004
      *                                                                         CAP004
     C     @RTCD         IFEQ      *BLANKS                                      CAP004
     C                   MOVE      *BLANKS       IntCPNost                      CAP004
     C                   MOVEL     @ARCD         IntCPNost                      CAP004
     C                   ENDIF                                                  CAP004
     C*
     C     @RTCD         IFNE      *BLANKS
     C     IZZ02         ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0649'     MsgID1
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       IntCPNost
     C                   END
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Message ID (10A, returned to caller)
     C                   PARM                    Msgid1
      ** Interest counterparty nostro (10A, from transaction)
     C                   PARM                    IntCPNost
      ** Enhanced rollovers feature on (1A, from SCSARDPD, via caller)
     C                   PARM                    S01434
      ** Interest settlement method (2A, from transaction)
     C                   PARM                    DDIMET
 
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
