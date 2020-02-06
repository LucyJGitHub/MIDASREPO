     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate WNCABR CAB Reporting')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SEVWNCABR  - Validate CAB Reporting                          *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             CAB Reporting and confirms wether it is a valid   *
      *             field or not.                                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP120CTYLX - CORE Lux Service Program         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX008  *CREATE    Date 23May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD) *
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
     D #6LXCABR        S              1A
 
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
      ***CAB*Reporting*field*is*mandatory******************************                       CER001
      *
     C*****#6LXCABR      IFEQ      *BLANKS                                                    CER001
     C**********         EVAL      ErrorFound = 'Y'                                           CER001
     C**********         MOVEL     'ERL0841'     #MSGID                                       CER001
     C**********         GOTO      #ERROR                                                     CER001
     C**********         ENDIF                                                                CER001
      *                                                                                       CER001
      ** If CAB Reporting field is blank, default to 'N'                                      CER001
      *                                                                                       CER001
     C     #6LXCABR      IFEQ      *BLANKS                                                    CER001
     C                   EVAL      #6LXCABR = 'N'                                             CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     #6LXCABR      IFNE      'Y'
     C     #6LXCABR      ANDNE     'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVE      'ERL0842'     #MSGID
     C**********         GOTO      #ERROR                                                     CER001
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C*****#ERROR        TAG                                                                  CER001
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
     C                   PARM                    #6LXCABR
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
(c) Finastra International Limited 2005
