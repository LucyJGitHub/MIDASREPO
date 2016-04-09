     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate VLCLAT Claim Type')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMVVLCLAT  - Validate Claims Type                            *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             claim type and the subordinate, and confirms      *
      *             wether it is a valid claim type or not.           *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP120CTYLX - CORE Lux Module service program  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 20Jul05               *
      *  Prev Amend No. ULX600  *CREATE    Date 07Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - Include '1' (Subordinated Debts) for valid claim    *
      *           types.                                              *
      *  ULX600 - API Luxembourg - Function MMLDNI                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #6LXCLAT        S              1A
     D #6LXSUBR        S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ** Move '0' if claim type is blanks
      *
     C     #6LXCLAT      IFEQ      *BLANKS
     C                   MOVE      '0'           #6LXCLAT
     C                   ENDIF
      *
     C     #6LXCLAT      IFNE      '0'
     C     #6LXCLAT      ANDNE     '1'                                                        CER001
     C     #6LXCLAT      ANDNE     '3'
     C     #6LXCLAT      ANDNE     '4'
     C     #6LXCLAT      ANDNE     '5'
     C     #6LXCLAT      ANDNE     '6'
     C     #6LXCLAT      ANDNE     '9'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER32015'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      **  If subordinate is 'Y', the claim type should be '0'
      *
     C     #6LXCLAT      IFNE      '0'
     C     #6LXSUBR      ANDEQ     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER32020'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
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
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #6LXCLAT
     C                   PARM                    #6LXSUBR
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
