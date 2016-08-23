     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate FFTIME Transaction Time')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFVFFTIME  - Validate Transaction Time                       *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             Transaction Time and confirms wether it is a      *
      *             valid field or not.                               *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Prev Amend No. ULX605             Date 05Oct00               *
      *                 ULX604  *CREATE    Date 05Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX605 - API Luxembourg - Function FFOTCC                    *
      *  ULX604 - API Luxembourg - Function FFEXTR                    *
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
     D #6LXTIME        S              6A
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** Define DS Transaction Time
     D WKTIME          DS             6
     D  WKHH                   1      2  0
     D  WKMM                   3      4  0
     D  WKSS                   5      6  0
 
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
     C                   RESET                   ZALIGNok
      *
      ** Transaction Time field is mandatory
      *
     C     #6LXTIME      IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0803'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Validate field
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #6LXTIME             99
     C     *IN99         IFNE      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0830'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  #6LXTIME      ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0830'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WKTIME
      *
      ** Hour must be between 00 and 23
      *
     C     WKHH          IFLT      0
     C     WKHH          ORGT      23
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0831'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Minute must be between 00 and 59
      *
     C     WKMM          IFLT      0
     C     WKMM          ORGT      59
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0832'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Seconde must be between 00 and 59
      *
     C     WKSS          IFLT      0
     C     WKSS          ORGT      59
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0833'     #MSGID
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
     C                   PARM                    #6LXTIME
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
