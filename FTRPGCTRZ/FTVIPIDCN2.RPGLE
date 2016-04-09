     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IPIDCO & OPIDEN Identification')     *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  FTVIPIDCN2 - Validate Identification Code and Identification *
      *                                                               *
      *  Function:  This module receives parameters containing an     *
      *             identification code and an identification, and    *
      *             confirms wether it is a valid identification code *
      *             and a valid identification or not                 *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of: SP6FT0009  - Core Luxembourg service program   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX611  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX611 - FT Incoming Payments API for Lux                    *
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
     D                 DS
      * Data structure to send PCUST as '*xxx' in BL0298 subprogram.
     D  @@STAR                 1      1
     D  @@BRCD                 2      4
     D  WWBRCD                 1      6
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXIDCO        S              2A
     D #LLXIDEN        S              9A
     D #LLXOPCO        S              2A
     D SMAM            S             13P 0
     D @ILIM           S             15P 0
     D @CUST           S              6A
     D #MsgID1         S              7A
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D @@IDCO          S              2P 0
     D @@IDEN          S              9P 0
     D @@CUST          S              6A
     D @@PGM           S             10A
     D @@DBID          S              1A
     D @@ERR1          S              1A
     D @@ERR2          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ***
      ***  Initial processing is performed automatically: the *INZSR is
      ***  executed at program activation.
      ***
      *
      ***  Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  IF no opcode >> no identification code/number
      *
     C     #LLXOPCO      IFEQ      *BLANKS
      *
     C     #LLXIDCO      IFNE      *BLANKS
     C     #LLXIDEN      ORNE      *BLANKS
      *
      ***  'Not Required, Left it Blanks'
      *
     C                   MOVEL     'IL05510'     #MSGID
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVE      *BLANK        #LLXIDCO
     C                   MOVE      *BLANK        #LLXIDEN
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     SMAM          IFGE      @ILIM
      *
      ***  Perform validation
      *
      ***  If greater then limit & blank entered, report error
      *
     C     #LLXIDCO      IFEQ      *BLANKS
     C     #LLXIDEN      OREQ      *BLANKS
     C                   MOVEL     'IL05511'     #MSGID
     C                   MOVEL     'IL05511'     #MSGID1
     C                   ENDIF
      *
      ***  If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Align numeric fields and report error if non-numeric
      *
     C                   MOVE      *OFF          *IN99
      *
     C                   MOVE(P)   #LLXIDCO      ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ***  Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVEL     'IL05512'     #MSGID
     C                   ELSE
     C                   MOVE      ZFIELD        #LLXIDCO
     C                   ENDIF
      *
      ***  Validate Identification
      *
     C                   MOVE      *OFF          *IN99
      *
     C                   MOVE(P)   #LLXIDEN      ZFIELD
     C                   Z-ADD     9             ZADIG
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ***  Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVEL     'IL05513'     #MSGID1
     C                   ELSE
     C                   MOVE      ZFIELD        #LLXIDEN
     C                   ENDIF
      *
      ***  If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Prepare parameters & call external validation program
      *
     C                   MOVE      #LLXIDCO      @@IDCO
     C                   MOVE      #LLXIDEN      @@IDEN
      *
     C                   CALL      'IL0411'
     C                   PARM                    @@IDCO                         Id code
     C                   PARM                    @@IDEN                         Id
     C                   PARM      'FTVIPIDCN2'  @@PGM                          Calling pgm
      *
      ***  Result parameters
      *
     C                   PARM      '0'           @@DBID                         Database error
     C                   PARM      '0'           @@ERR1                         Error in IDCO
     C                   PARM      '0'           @@ERR2                         Error in IDEN
      *
      ***  If error found, report error using message, passed by validation
      *
     C     @@DBID        IFEQ      *ON
     C                   MOVEL     'IL0411'      DBFILE                         ***************
     C                   MOVEL     '900'         DBASE                          * DBERROR 900 *
     C                   MOVEL     '*PGM'        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  'Identification code is not consistent'
      *
     C     @@ERR1        IFEQ      *ON
     C                   MOVEL     'IL00002'     #MSGID
     C                   ENDIF
      *
      ***  'Identification number isn't consistent'
      *
     C     @@ERR2        IFEQ      *ON
     C                   MOVEL     'IL00003'     #MSGID1
     C                   ENDIF
      *
      ***  If errors detected
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  If less then limit, force fields to blank
      *
     C                   ELSE
     C                   MOVE      *BLANKS       #LLXIDCO
     C                   MOVE      *BLANKS       #LLXIDEN
     C                   ENDIF
      *
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
      ***  Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #MsgID1
     C                   PARM                    #LLXIDCO
     C                   PARM                    #LLXIDEN
     C                   PARM                    #LLXOPCO
     C                   PARM                    SMAM
     C                   PARM                    @ILIM
     C                   PARM                    @CUST
      *
      ***  Set the program, module and procedure names for database
      ***  error processing.  Note: this /COPY requires that the PSDS
      ***  /COPY is also included.
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
