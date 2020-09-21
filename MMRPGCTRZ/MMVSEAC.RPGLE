     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate settlement account')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVSEAC - MM Repo Header settlement account validation       *
      *                                                               *
      *  Function: This Program Validates the settlement account      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1JUne99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
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
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
     D ValidRepo     E DS                  EXTNAME(MMVRPDHPD)
      * Valid Repo Delivery Details
 
     D TranIn        E DS                  EXTNAME(MMRPDHPD)
     D                                     PREFIX(IK:2)
     D QQACC1        E                     EXTFLD(QQACCN)                                     CGL029
      * Incoming Transaction
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
 
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
 
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      **  Account details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** Midas SD Nostro details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
     D @ACCN           DS
     D @CNUM                   1      6
     D***@ACCD**                 7     10                                                     CGL029
     D***@ACSQ**                11     12                                                     CGL029
     D***@BRCA**                13     15                                                     CGL029
     D @ACCD                   7     16                                                       CGL029
     D @ACSQ                  17     18                                                       CGL029
     D @BRCA                  19     21                                                       CGL029
 
     D Branch          S              3
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
     C                   MOVEL     IKFECY        @CUCD
     C                   MOVEL     IKACCN        @ACCN
     C*
     C* Send error message if account is not blank yet settlement method
     C* is '00' or Blank.
     C*
     C                   IF        IKFESM = *Blanks and IKACCN <> *Blanks
     C                             or IKFESM = '00' and IKACCN <> *Blanks
     C                   MOVE      'MMA0770'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C*
     C* Send error message if account is not blank yet settlement method
     C* is '04'.
     C*
     C                   IF        IKFESM = '04' and IKACCN <> *BLANKS
     C                   MOVE      'MMA0771'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C*
     C* If settlement method is '05' then account should be a valid account
     C*
     C                   IF        IKFESM = '05'
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @RETL            10
     C                   PARM                    @CNUM
     C                   PARM                    @CUCD             3
     C**********         PARM                    @ACCD             4                          CGL029
     C                   PARM                    @ACCD                                        CGL029
     C                   PARM                    @ACSQ             2
     C                   PARM                    @BRCA             3
     C     ACCNT         PARM      ACCNT         DSSDY
     C
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
      *
     C                   MOVE      'MMA0772'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
     C*
     C* If settlement method is '14' then account should be a valid retail
     C* account
     C*
     C                   IF        IKFESM = '14'
     C*
     C                   MOVEL     IKACCN        @RETL
     C*
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @RETL            10
     C                   PARM      *BLANKS       @CNUM
     C                   PARM      *BLANKS       @CUCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSQ             2
     C                   PARM      *BLANKS       @BRCA             3
     C     ACCNT         PARM      ACCNT         DSSDY
     C
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI          ANDNE     'D'
      *
     C                   MOVE      'MMA0773'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
     C
     C* If settlement method is '01' then account should be a valid nostro
     C*
     C                   IF        IKFESM = '01'
     C*
     C                   CALL      'AONOSTR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *Blanks       @CUST             6
     C                   PARM                    @CUCD             3
     C**********         PARM      *Blanks       @ACCD             4                          CGL029
     C                   PARM      *Blanks       @ACCD                                        CGL029
     C                   PARM      *Blanks       @ACSN             2
     C                   PARM      IKACCN        @NONB             2
     C                   PARM      *Blanks       @BRCD             3
     C                   PARM      *Blanks       @CSSN            10
     C                   PARM      *Blanks       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'MMA0793'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
     C                   MOVE      IKACCN        IFBRCA
     C                   MOVEL     IKACCN        IFACCN
     C                   ENDIF
     C
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
      * Receive Screen Format Input
     C                   PARM                    TranIn
     C                   PARM                    Branch
      * Receive File Format Input
     C                   PARM                    ValidRepo
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMVSEAC'     DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
