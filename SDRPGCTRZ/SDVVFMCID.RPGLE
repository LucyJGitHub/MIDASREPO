     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFMCID Market Centre')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFMCID  - Validate Market Centre                          *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             Market Centre and a customer, and confirms wether *
      *             it is a valid Market Centre or not.               *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP121CTYLX - Core Luxembourg service program  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. ULX609  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ULX609 - API Luxembourg - Function SDCUSD                    *
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
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      ** External DS for customers details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #6LXMCID        S              1A
     D #1CUST          S              6A
 
      ** Define parameters for call module
     D @CUST           S              6A
 
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
      ** Allowed Values Are 'Y' Or 'N'
      *
     C     #6LXMCID      IFNE      *BLANKS
     C     #6LXMCID      IFNE      'Y'
     C     #6LXMCID      ANDNE     'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0829'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Check If Customer Is A SE Customer By Access Object
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1CUST        @CUST
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** If Record Not Found
      *
     C     @RTCD         IFNE      *BLANKS
     C     #6LXMCID      ANDEQ     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL0834'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
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
     C                   PARM                    #6LXMCID
     C                   PARM                    #1CUST
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
