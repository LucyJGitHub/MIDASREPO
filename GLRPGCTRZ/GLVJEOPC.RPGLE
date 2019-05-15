     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JEOPCx Operation code')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLVJEOPC  - Validate Operation code                          *
      *                                                               *
      *  Function:  This module receives parameters containing an     *
      *             Operation code and confirm wether it is a valid   *
      *             Operation code or not                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP122CTYLX*-*Core*Luxembourg*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX607  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX607 - API Luxembourg - Function GLBITP                    *
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
     D #7LXOPCF        S              3A
     D #1CUST          S              6A
     D #1CYCD          S              3A
     D WWBKCO          S              2A
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D @CODE           S              3A
     D @CUST           S              6A
     D @TCCY           S              3A
     D @CPGM           S             10A
     D @DBID           S              1A
     D @ERID           S              1A
     D @CLIM           S             14P 0
     D @ILIM           S             14P 0
 
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
      ** If blank - report error
      *
     C     #7LXOPCF      IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10001'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Check if numeric
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #7LXOPCF             99
     C     *IN99         IFNE      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10002'     #MSGID
     C                   GOTO      #ERROR
     C                   ELSE
      *
     C                   MOVEL(P)  #7LXOPCF      ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
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
     C                   MOVEL     'BL10002'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if exist
      *
     C                   MOVEL     #7LXOPCF      @CODE
     C                   MOVEL     'GLBPLXVX7'   @CPGM
      *
      ** Call validation program
      *
     C                   CALL      'BL0297'
     C                   PARM                    @CODE                          Op. code
     C                   PARM      #1CUST        @CUST                          Customer number
     C                   PARM      #1CYCD        @TCCY                          Tr. currency
     C                   PARM                    @CPGM                          Calling pgm
     C                   PARM      *ZERO         @ERID                          Error ind.
     C                   PARM      *ZERO         @DBID                          DB error ind.
     C                   PARM      *ZEROS        @CLIM                          Country lim.
     C                   PARM      *ZEROS        @ILIM                          Id limit
      *
      ** If error found, report error using message, passed by validation pgm
      *
     C     @DBID         IFEQ      *ON
     C                   MOVEL     'BLCODEPD'    DBFILE                         ***************
     C                   MOVEL     '900'         DBASE                          * DBERROR 900 *
     C                   MOVEL     '1'           DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If not found, report error
      *
     C     @ERID         IFEQ      '1'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10003'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Operation code '490' is not authorized for Belgium
      *
     C     WWBKCO        IFEQ      'BE'
     C     #7LXOPCF      ANDEQ     '490'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10011'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Operation code '247' is just authorized for Belgium & Luxembourg
      *
     C     #7LXOPCF      IFEQ      '247'
     C     #1CYCD        IFNE      'BEF'
     C     #1CYCD        ANDNE     'LUF'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'BL10012'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ENDIF
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
     C                   PARM                    #7LXOPCF
     C                   PARM                    #1CUST
     C                   PARM                    #1CYCD
     C                   PARM                    WWBKCO
     C                   PARM                    @CLIM
     C                   PARM                    @ILIM
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
