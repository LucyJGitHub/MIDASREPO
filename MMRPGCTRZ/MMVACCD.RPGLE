     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Action Code')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVACCD - MM Repo Detail action Code Validation              *
      *                                                               *
      *  Function: This Program Validates Exchange Rate Details       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1June99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FDPTMVR    IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
 
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
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D ValidRepo     E DS                  EXTNAME(MMVRPDDPD)
      * Valid Repo Delivery Details
 
     D TranIn        E DS                  EXTNAME(MMRPDDPD)
     D                                     PREFIX(IK:2)
      * Incoming Transaction
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data Structure for Access Program for switchable features
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Access Program for Bank Details
 
      ** Data Structure for subfile entry fields excluding action code
     D DDDATA          DS            73
     D  DDSECT                 1     10
     D  DDNOML                11     22
     D  DDVALP                23     38
     D  DDORDP                39     48
     D  DDCPDP                49     58
     D  DDEXCR                59     73
 
 
      ** Define multibranch indicator field
     D RUNDAT          DS
     D  MBIN                  13     13
 
     D ActMode         S              1A
     D DepRef          S              6A
     D Branch          S              3A
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
      *
      ** Send error message if no details are entered yet action code
      ** is entered
      *
     C                   EVAL      DDSECT = IKSECT
     C                   EVAL      DDNOML = IKNOML
     C                   EVAL      DDVALP = IKVALP
     C                   EVAL      DDORDP = IKORDP
     C                   EVAL      DDCPDP = IKCPDP
     C                   EVAL      DDEXCR = IKEXCR
      *
     C                   IF        DDDATA = *BLANKS and IKACTN <> *Blanks
     C                   MOVE      'MMA0781'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
      *
      ** Send error message if record is new and action code is not blank
      *
     C                   IF        DepRef = *Blanks and IKACTN <> *Blanks
     C                   MOVE      'MMA0781'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
      *
      ** Send error message if action code is not C, D, Blanks. Condition
      ** allowance of 'M' on switchable feature S01401.
      *
     C                   IF        S01401 <> 'Y'
     C                   IF        ActMode = 'M' or ActMode = 'R'
     C                             or ActMode = 'I' or ActMode = 'A'
     C                   IF        IKACTN <> 'C' and IKACTN <> 'D'  and
     C                             IKACTN <> ' '
     C                   MOVE      'MMA0782'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ELSE
     C                   IF        IKACTN <> 'C' and IKACTN <> ' '
     C                   MOVE      'MMA0782'     MSG2
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   IF        ActMode = 'M' or ActMode = 'R'
     C                             or ActMode = 'I' or ActMode = 'A'
     C                   IF        IKACTN <> 'C' and IKACTN <> 'D'  and
     C                             IKACTN <> ' ' and IKACTN <> 'M'
     C                   MOVE      'MMA0782'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ELSE
     C                   IF        IKACTN <> 'C' and IKACTN <> ' '  and
     C                             IKACTN <> 'M'
     C                   MOVE      'MMA0782'     MSG2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
     C** Do not allow delete if this is amend mode and run day number is not
     C** the same as the original entry date
     C                   OPEN      DPTMVR
     C     DepRef        CHAIN     DPTMVR                             89
     C                   IF        *IN89 = '0'
     C                   IF        IKACTN = 'D' and ORED <> BJRDNB
     C                             and ActMode = 'A'
     C                   MOVE      'MMA0783'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ORED = BJRDNB
     C                   ENDIF
     C                   CLOSE     DPTMVR
     C*
     C** Check whether user is authorised to delete action code for
     C** individual depot movements
     C*
     C                   IF        MSG2 = *Blanks
     C                   IF        IKACTN = 'D'
     C                   MOVEL     IKACTN        @ZACTN
     C*
     C** - If Single Branch Environment
     C*
     C     MBIN          IFNE      'Y'
     C                   CALL      'ZVACTU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @ERR              1 0
     C**
     C     @ERR          IFNE      *ZERO
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'FXM0290'     MSG5
     C                   END
     C                   ELSE
     C*
     C** - If Multibranching Environment
     C*
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM      Branch        @ZBR              3
     C                   PARM                    @ERR              1 0
     C**
     C     @ERR          IFEQ      2
     C                   MOVEL     'FXM0290'     MSG5
     C                   MOVE      'Y'           ErrorFound        1
     C                   END
     C     @ERR          IFEQ      1
     C                   MOVEL     'FXM0291'     MSG5
     C                   MOVE      'Y'           ErrorFound        1
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** If 'M' is entered against an action code and ActMode is 'M' send
     C** error message
     C*
     C                   IF        S01401 = 'Y'
     C                   IF        IKACTN = 'M' and ActMode = 'M'
     C                   IF        ORED <> BJRDNB
     C                   MOVE      'MMA0784'     MSG4
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
      *
     C                   RETURN
     C********************************************************************
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSG5
      * Receive Transaction Details
     C                   PARM                    TranIn
     C                   PARM                    ActMode
     C                   PARM                    DepRef
     C                   PARM                    Branch
      * Export Formatted Details
     C                   PARM                    ValidRepo
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMEXCR'      DBPGM
     C                   OUT       LDA
      *
      **  Define RUNDAT data area to access multi-branch indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access SAR details file to determine if MT5xx Message Generation
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 01 *
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'S01401'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   SETON                                        14
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   ENDIF
      *
      **  Access Bank Details via Access Object
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
