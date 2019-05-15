     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Penalty Pay/Receive')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVPNLTYPR - Validate Penalty Pay/Receive                    *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Penalty Pay/Recieve indicator and confirms        *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
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
      *  Prev Amend No. BUG3735            Date 20Jul04               *
      *                 CDL017  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG3735- Allow penalty Pay/Receive to be blank if the        *
      *           penalty amount is blank                             *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
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
 
      ** Penalty Pay/Receive indicator received as a parameter
     D DDPNPR          S              1A
 
      ** Deal Amendment Type received as a parameter
     D DDMTYP          S              2A
 
      ** Original Deal Type received as a parameter
     D DDTYPE          S              2A
 
      ** Penalty Pay/Receive indicator received as a parameter
     D IGPNPR          S              1A
      ** Deal Amendment Amount received as a parameter                                       BUG3735
     D DDAMNP          S             15A                                                     BUG3735
 
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
 
      ** For Deal Amendments, Deal Type Must be 'EM' for
      ** Penalty Pay/Receive to be entered.
     C     DDMTYP        IFNE      'EM'
     C                   IF        DDPNPR <> *blanks
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0319'     Msgid1
     C                   ENDIF
 
     C                   ELSE
 
      ** Penalty Pay/Receive must be 'P' or 'R'
     C     DDPNPR        IFNE      'P'
     C     DDPNPR        ANDNE     'R'
      ** Allow Pay/Recieve to be blanks if the penalty amount also blanks                    BUG3735
     C     DDPNPR        IFEQ      *BLANKS                                                   BUG3735
     C     DDAMNP        ANDEQ     *BLANKS                                                   BUG3735
     C                   ELSE                                                                BUG3735
      *                                                                                      BUG3735
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0326'     Msgid1
     C                   ENDIF                                                               BUG3735
     C                   ENDIF
 
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
     C     ERROR         TAG
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVE      DDPNPR        IGPNPR
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
     C                   PARM                    DDPNPR
     C                   PARM                    DDMTYP
     C                   PARM                    IGPNPR
     C                   PARM                    DDAMNP                                      BUG3735
 
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
(c) Finastra International Limited 2004
