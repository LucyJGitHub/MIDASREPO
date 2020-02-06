     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate round down interest indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVRNDDOWN - Validate round down interest indicator          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             round down interest indicator and confirms        *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      *  Prev Amend No. BUG7320            Date 27Sep05               *
      *                 CAP084  *CREATE    Date 15Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG7320- Default the round down indicator                    *
      *  CAP084 - API Wrapper project                                 *
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
 
      ** Round Down Interest indicator received as a parameter
     D DDRdfc          S              1A
 
      ** Currency Round Down Interest indicator received as a parameter
     D CyRdfc          S              1A
 
      ** Branch Round Down Interest indicator received as a parameter
     D BrRdfc          S              1A
 
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
     C*
     C* If Round Down Int Ind on Currency or Branch is 'N'
     C* then Round Down Int Ind on deal must be 'N'
     C*
     C     CyRdfc        IFEQ      'N'
     C     DDRDFC        ANDEQ     'Y'                                          CAP084
     C                   EVAL      ErrorFound = 'Y'                             CAP084
     C                   MOVEL     'MMM0615'     Msgid1                         CAP084
     C                   END                                                    CAP084
     C*****BrRdfc********OREQ      'N'                                          CAP084
     C*                                                                         CAP084
     C     BrRdfc        IFEQ      'N'                                          CAP084
     C     DDRDFC        ANDEQ     'Y'                                          CAP084
     C**********         MOVE      'N'           DDRDFC                         CAP084
     C                   EVAL      ErrorFound = 'Y'                             CAP084
     C                   MOVEL     'MMM0616'     Msgid1                         CAP084
     C                   END
      ** Default round down indicator                                                        BUG7320
     C     CyRdfc        IFEQ      'N'                                                       BUG7320
     C     BrRdFc        OREQ      'N'                                                       BUG7320
     C     DDRDFC        IFNE      'Y'                                                       BUG7320
     C                   Eval      DDRDFC = 'N'                                              BUG7320
     C                   ENDIF                                                               BUG7320
     C                   ENDIF                                                               BUG7320
     C*
      ** Validate the Round down interest indicator, must be Y or N
     C     DDRdfc        IFNE      'Y'
     C     DDRdfc        ANDNE     'N'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0610'     Msgid1
 
     C                   END
 
     C*
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
     C                   PARM                    DDRdfc
     C                   PARM                    CyRdfc
     C                   PARM                    BrRdfc
 
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
