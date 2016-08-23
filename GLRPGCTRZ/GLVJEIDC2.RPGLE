     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JEIDCx JEIDEx Identification')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  GLVJEIDC2 - Validate Identification and Identification code  *
      *                                                               *
      *  Function:  This module receives parameters containing a      *
      *             Identification and Identification code and        *
      *             confirm wether it is a valid Identification and   *
      *             Identification code or not                        *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP122CTYLX*-*Core*Luxembourg*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Prev Amend No. ULX043             Date 17Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX043 - IBLC 2002 Reporting                                 *
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
     D #LLXIDCF        S              2A
     D #LLXIDEF        S              9A
     D #LLXOPCF        S              3A
     D #LLXCOCF        S              2A
     D #LLXDCIF        S              1A
     D #LLXPTAF        S             14A
     D #1CUST          S              6A
     D @ILIM           S             15P 0
     D WPTAF           S             13P 0
     D #MSGID1         S              7A
     D #WMSGID         S              7A
     D SVOPCF          S              3A
     D SVCOCF          S              2A
     D SVIDCF          S              2A
     D SVIDEF          S              9A
     D SVPTAF          S             14A
     D SVDCIF          S              1A
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
     D @@IDCF          S              2P 0
     D @@IDEF          S              9P 0
     D @@CUST          S              6A
     D @@PGM           S             10A
     D @@DBID          S              1A
     D @@ERR1          S              1A
     D @@MSG1          S              7A
     D @@DTA1          S             40A
     D @@ERR2          S              1A
     D @@MSG2          S              7A
     D @@DTA2          S             40A
 
      ** Define parameters for call module
 
 
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
     C                   RESET                   WarnFound
      *
      ***  Validate field  : WNPTAM is Amout to be reported
      ***                    PILIM, Returned Limit for Identification by IL0410
      *
     C     WPTAF         IFLT      @ILIM
      *
      ***  Identification is not necessary, Reset to blank
      *
     C                   MOVE      *BLANKS       #LLXIDCF
     C                   MOVE      *BLANKS       #LLXIDEF
      *
     C                   ELSE
      *
      ** Perform validation
      *
      ** If #LLXIDCF AND #LLXIDEF are Both blank --> send WARNING msg
      *
     C     #LLXIDCF      IFEQ      *BLANKS
     C     #LLXIDEF      ANDEQ     *BLANKS
      *
      ** Do only one validation
      *
     C     #LLXOPCF      IFNE      SVOPCF
     C     #LLXCOCF      ORNE      SVCOCF
     C     #LLXIDCF      ORNE      SVIDCF
     C     #LLXIDEF      ORNE      SVIDEF
     C     #LLXPTAF      ORNE      SVPTAF
     C     #LLXDCIF      ORNE      SVDCIF
     C                   MOVEL     'IL10012'     #WMSGID
     C                   EVAL      WarnFound = 'W'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If greater then limit & blank entered, report error
      *
     C     #LLXIDCF      IFEQ      *BLANKS
     C                   MOVEL     'IL10013'     #MSGID
     C                   ENDIF
      *
     C     #LLXIDEF      IFEQ      *BLANKS
     C                   MOVEL     'IL10014'     #MSGID1
     C                   ENDIF
      *
      ** If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Align numeric fields and report error if non-numeric
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #LLXIDCF             99
     C     *IN99         IFNE      *ON
      *
      ***  'Identification Code must be a 2 digits field.'
      *
     C                   MOVEL     'IL10013'     #MSGID
     C                   ELSE
      *
     C                   MOVE(P)   #LLXIDCF      ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
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
     C                   MOVEL     'IL10013'     #MSGID
     C                   ELSE
     C                   MOVE      ZFIELD        #LLXIDCF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Identification
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #LLXIDEF             99
     C     *IN99         IFNE      *ON
      *
      ***  'Identification Number must be a 9 digits field.'
      *
     C                   MOVEL     'IL10014'     #MSGID1
     C                   ELSE
      *
     C                   MOVE(P)   #LLXIDEF      ZFIELD
     C                   Z-ADD     9             ZADIG
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
     C                   MOVEL     'IL10014'     #MSGID1
     C                   ELSE
     C                   MOVE      ZFIELD        #LLXIDEF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Prepare parameters & call external validation program
      *
     C                   MOVE      #LLXIDCF      @@IDCF
     C                   MOVE      #LLXIDEF      @@IDEF
     C                   MOVEL     'GLBPLXVXL'   @@PGM
      *
     C                   CALL      'IL0411'
     C                   PARM                    @@IDCF
     C                   PARM                    @@IDEF
     C                   PARM                    @@PGM
      *
      ** Result parameters
      *
     C                   PARM      *BLANK        @@DBID
     C                   PARM      *BLANK        @@ERR1
     C                   PARM      *BLANK        @@ERR2
      *
      ** If error found, report error using message, passed by validation
      *
     C     @@DBID        IFEQ      *ON
     C                   MOVEL     'IL0411  '    DBFILE                         ***************
     C                   MOVEL     '900'         DBASE                          * DBERROR 900 *
     C                   MOVEL     '*PGM'        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @@ERR1        IFEQ      *ON
     C                   MOVEL     'IL00002'     #MSGID
     C                   ENDIF
      *
     C     @@ERR2        IFEQ      *ON
     C                   MOVEL     'IL00003'     #MSGID1
     C                   ENDIF
      *
      ** If errors detected
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ENDIF
      *
     C     #ERROR        TAG
      *
     C                   IF        WarnFound = 'W'
     C                   EVAL      RetCodeIn = 'Warning'
     C                   ENDIF
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #MsgID1
     C                   PARM                    #WMsgID
     C                   PARM                    #LLXIDCF
     C                   PARM                    #LLXIDEF
     C                   PARM                    #LLXOPCF
     C                   PARM                    #LLXCOCF
     C                   PARM                    #LLXDCIF
     C                   PARM                    #LLXPTAF
     C                   PARM                    #1CUST
     C                   PARM                    @ILIM
     C                   PARM                    WPTAF
     C                   PARM                    SVOPCF
     C                   PARM                    SVCOCF
     C                   PARM                    SVIDCF
     C                   PARM                    SVIDEF
     C                   PARM                    SVPTAF
     C                   PARM                    SVDCIF
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
      *
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
