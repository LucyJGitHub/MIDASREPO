     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CUIMCO Immatriculation')             *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDVCUIMCO2 - Validate Immatriculation Code & Immatriculation *
      *                                                               *
      *  Function:  This module receives a parameter containing an    *
      *             immatriculation code and an immatriculation, and  *
      *             confirms wether it is a valid immatriculation code*
      *             and a valid immatriculation                       *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP6DS0005  - Core Luxembourg service program  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CER001             Date 25Apr05               *
      *                 201628             Date 04Dec02               *
      *                 ULX043             Date 03Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  201628 - Review Validation for 'BR' customer                 *
      *            ________________________________________           *
      *           | Identification   | Immatriculation     |          *
      *           | ---------------- | ------------------- |          *
      *           | 23 + BCL Number  | 28 + TVA (8 digits) |          *
      *           | 23 + BCL number  | 00 + 000000000      |          *
      *           | 00 + 000000000   | 28 + TVA (8 digits) |          *
      *           | 25 + 000006662   | __ + _________      |          *
      *           |________________________________________|          *
      *  ULX043 - IBLC 2002 Reporting                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
      ***  Extended Branch details                                    Prefix A8.
      *
 
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
      * Data structure to send @@CUST as '*xxx' in BL0298 subprogram.
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
     D #LLXIMCO        S              2A
     D #LLXIMNB        S              9A
     D #LLXTYPE        S              2A
     D #1cust          S              6A
     D #1BRCD          S              3A
     D BRBKCO          S              2S 0
     D #MsgID1         S              7A
     D #WMsgID         S              7A
 
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
     D @@MSG1          S              7A
     D @@DTA1          S             40A
     D @@ERR2          S              1A
     D @@MSG2          S              7A
     D @@DTA2          S             40A
 
      ** Define Work fields
     D WarningSave     S              7A
     D WWLXIMCO        S              2A   INZ('xx')
     D WWLXIMNB        S              9A   INZ('xx')
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
     C                   RESET                   WarnFound
      *
      ***  Check if it's an Internal Branch Customer
      *
     C     #1CUST        CHAIN     SDBRCHL5                           98
      *
      ***  If Customer is Bank Resident (BR) or Other Resident (OR)
      *
     C     #LLXTYPE      IFEQ      'BR'
     C     #LLXTYPE      OREQ      'OR'
      *
      ***  Validation is done only if the Customer Type is 'BR'
      *
     C     #LLXTYPE      IFEQ      'BR'
      *
      ***  Verify if immatriculation is entered correctly
      ***  201628 - if Identification is Set -up with 23
      ***           else if Identification unknown
      ***                  then immatriculation N° TVA is mandatory
      ***           Else if identification is 25 6662
      ***                  then immatriculation is left blanks
      *
     C                   SELECT                                                 201628
     C     #LLXIDCO      WHENEQ    '23'                                         201628
      *                                                                         201628
     C     #LLXIMCO      IFNE      '00'
     C     #LLXIMCO      ANDNE     '28'
      *
      ***  Warning must appeared only one time
      *
     C     #LLXIMCO      IFEQ      *BLANKS
     C     #LLXIMNB      ANDEQ     *BLANKS
     C                   MOVE      *ZEROS        #LLXIMCO
     C                   MOVE      *ZEROS        #LLXIMNB
     C                   MOVEL     'IL01117'     #WMsgID
     C                   EVAL      WarnFound = 'W'
     C                   GOTO      #ERROR
      *
     C                   ELSE
      *
     C                   MOVEL     'IL01118'     #MSGID
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                         201628
      ***  If not known, Immatriculation must be filled with 28 + N° TVA        201628
      *                                                                         201628
     C     #LLXIDCO      WHENEQ    '00'                                         201628
      *                                                                         201628
     C     #LLXIMCO      IFNE      '28'                                         201628
      *                                                                         201628
      ***  'Immatriculation must be filled with TVA Number'                     201628
      *                                                                         201628
     C                   MOVEL     'IL01122'     #MSGID                         201628
      *                                                                         201628
     C                   ENDIF                                                  201628
      *                                                                         201628
     C                   ENDSL                                                  201628
      *
     C                   ENDIF
      *
     C     #LLXTYPE      IFEQ      'OR'                                         Other Resident
      *
      ***  Verify if immatriculation is entered correctly
      *
     C     #LLXIMCO      IFNE      '00'
     C     #LLXIMCO      ANDNE     '26'
      *
      ***  Warning must appeared only one time
      *
     C     #LLXIMCO      IFEQ      *BLANKS
     C     #LLXIMNB      ANDEQ     *BLANKS
     C                   MOVE      *ZEROS        #LLXIMCO
     C                   MOVE      *ZEROS        #LLXIMNB
     C                   MOVEL     'IL01119'     #WMsgID
     C                   EVAL      WarnFound = 'W'
     C                   GOTO      #ERROR
      *
     C                   ELSE
      *
     C                   MOVEL     'IL01118'     #MSGID
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If 25 + 6662, Immatriculation is Blank                               201628
      ***  Else Validate immatriculation                                        201628
      *                                                                         201628
     C     #LLXTYPE      IFEQ      'BR'                                         201628
     C     #LLXIDCO      ANDEQ     '25'                                         201628
     C                   MOVEL     *BLANKS       #LLXIMCO                       201628
     C                   MOVEL     *BLANKS       #LLXIMNB                       201628
     C                   ELSE                                                   201628
     C
      ***  Validate Immatriculation Code
      *
     C                   MOVE      *OFF          *IN99
     C*****              TESTN                   #LLXIMCO             99        201628
     C******IN99         IFNE      *ON                                          201628
     C*****              MOVEL     'IL01120'     #MSGID                         201628
     C*****              ELSE                                                   201628
      *
     C                   MOVEL(P)  #LLXIMCO      ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
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
     C                   MOVEL     'IL01120'     #MSGID
     C                   ELSE                                                   201628
     C                   MOVE      ZFIELD        #LLXIMCO                       201628
     C                   ENDIF
     C****               ENDIF                                                  201628
      *
      ***  If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Validate Immatriculation
      *
     C                   MOVE      *OFF          *IN99
     C*****              TESTN                   #LLXIMNB             99        201628
     C******IN99         IFNE      *ON                                          201628
     C******             MOVEL     'IL01121'     #MSGID1                        201628
     C*****              ELSE                                                   201628
      *
     C                   MOVEL(P)  #LLXIMNB      ZFIELD
     C                   Z-ADD     0             ZADEC
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
     C                   MOVEL     'IL01121'     #MSGID1
     C                   ELSE                                                   201628
     C                   MOVE      ZFIELD        #LLXIMNB                       201628
     C                   ENDIF
     C*****              ENDIF                                                  201628
      *
      ***  If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Move *xxx where xxx is the branch code to bypass chain in sdcustl1
      ***  in the program IL0411
      *
     C                   MOVE      #LLXIMCO      @@IDCO
     C                   MOVE      #LLXIMNB      @@IDEN
     C                   MOVEL     'SDCUSDSIN'   @@PGM
      *
     C                   CALL      'IL0411'
     C                   PARM                    @@IDCO                         Immatriculation Code
     C                   PARM                    @@IDEN                         Immatriculation
     C                   PARM                    @@PGM                          Calling pgm
      *
      ***  Result parameters
      *
     C                   PARM      *BLANKS       @@DBID                         Database error
     C                   PARM      *BLANKS       @@ERR1                         Error in #LLXIMCO
     C                   PARM      *BLANKS       @@ERR2                         Error in #LLXIMNB
      *
     C     @@ERR1        IFEQ      *ON
     C                   MOVEL     'IL00002'     #MSGID
     C                   ENDIF
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
      *                                                                         201628
     C                   ENDIF                                                  201628
      *
     C                   ELSE
      *
      ***  Setup Immatriculation Fields with Blanks
      *
     C                   MOVE      *BLANKS       #LLXIMCO
     C                   MOVE      *BLANKS       #LLXIMNB
      *
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
      ***  Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #MsgID1
     C                   PARM                    #WMsgID
     C                   PARM                    #LLXIDCO
     C                   PARM                    #LLXIDEN
     C                   PARM                    #LLXIMCO
     C                   PARM                    #LLXIMNB
     C                   PARM                    #LLXTYPE
     C                   PARM                    #1CUST
     C                   PARM                    #1BRCD
     C                   PARM                    BRBKCO
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
(c) Finastra International Limited 2005
