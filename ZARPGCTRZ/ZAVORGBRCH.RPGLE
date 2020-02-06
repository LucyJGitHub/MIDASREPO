     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate originating branch')
      *****************************************************************
      *                                                               *
      *  Midas - Standard procedures                                  *
      *                                                               *
      *  ZAVORGBRCH - Validate an originating branch                  *
      *                                                               *
      *  Function:  This module confirms whether a 3-alpha field      *
      *             contains a valid branch code for an originating   *
      *             branch.                                           *
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
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
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
 
      ** Message ID
     D @MSGID          S                   LIKE(#Msgid)
 
      ** Ordering branch
     D DDORBR          S              3A
 
      ** Booking branch OK flag
     D BookBrchOK      S              1A
 
      ** Booking branch
     D DDBRCA          S                   LIKE(DDORBR)
 
      ** Muli-branching indicator
     D @MBIN           S              1A
 
      ** Originating branch used flag
     D BKOBRU          S              1A
 
      ** Originating branch/user validation
     D BKOBUV          S              1A
 
      ** End of parameters
      ** =================
 
      ** Ordering branch
     D @DSNB           S                   LIKE(DDORBR)
 
      ** Error code
     D ERR             S              1P 0
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     D RespMode        S              1A
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
     C                   RESET                   @Msgid
 
      *
      ** If the Originating Branch field is blank
      ** Set up the originating branch code field with default value
      ** only if booking branch not in error
     C     DDORBR        IFEQ      *BLANKS
     C     BookBrchOK    ANDNE     'N'
     C                   MOVE      DDBRCA        DDORBR
     C                   END
      *
      ** Originating branch code validation only when MULTI-BRANCHING
      ** indicator is on, field is user-validated and there is something
      *  to validate
      *
     C     @MBIN         IFEQ      'Y'
     C     BKOBRU        ANDEQ     'Y'
     C     DDORBR        ANDNE     *BLANKS
      *
     C**  Check that the Branch Code exists on SDBRCHPD.
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDORBR        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM0289'     @MSGID
     C                   ELSE
      *
     C                   MOVEL     A8BRCD        DDORBR
 
      ** Validate Orig. branch against user if no errors found so far
      **  and user validation flag is on
 
     C     BKOBUV        IFEQ      'Y'
 
      * Only do the User/Branch check if the program is running in
      *  Synchronous mode.  In Asynchronous mode, the deal has already
      *  been done so it is pointless saying it is not valid.
     C     RespMode      IFEQ      'S'
 
     C                   CALL      'ZVOBU'
     C                   PARM      DDORBR        ZOBRX             3
     C                   PARM                    ERR               1 0
 
     C     ERR           IFEQ      1
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM0287'     @MSGID
     C                   END
 
     C     ERR           IFEQ      2
     C                   MOVE      '1'           *IN54
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM0288'     @MSGID
     C                   END
 
     C                   ENDIF
 
     C                   END
 
     C                   END
 
     C                   END
 
      ** Set return code
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
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
     C                   PARM                    @MSGID
     C                   PARM                    DDORBR
     C                   PARM                    BookBrchOK
     C                   PARM                    DDBRCA
     C                   PARM                    @MBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
