     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CUIDCO Identification')              *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDVCUIDCO2 - Validate Identification Code and Identification *
      *                                                               *
      *  Function:  This module receives parameters containing an     *
      *             identification code and an identification, and    *
      *             confirms wether it is a valid identification code *
      *             and a valid identification or not                 *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP121CTYLX - Core Luxembourg service program  *
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
 
      ** Define Arrays
 
     DOPCVM1           S              9A   DIM(3) PERRCD(3) CTDATA
     DOPCVM2           S              9A   DIM(9) PERRCD(6) CTDATA
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
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXIDCO        S              2A
     D #LLXIDEN        S              9A
     D #LLXTYPE        S              2A
     D #1cust          S              6A
     D #1bnbi          S              1A
     D #1BRCD          S              3A
     D BRBKCO          S              2S 0
     D #MsgID1         S              7A
     D #MsgID2         S              7A
 
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
 
      *
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
      **
      *
      ***  Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  Check if it's an Internal Branch Customer
      *
     C     #1CUST        CHAIN     SDBRCHL5                           98
      *
      ***  If resident, validate fields
      *
     C                   MOVE      #LLXTYPE      TYP2              1
     C     TYP2          IFEQ      'R'
      *
      ***  Perform validation
      *
     C                   DO
      *
      ***  Identification Code is mandatory
      *
     C     #LLXIDCO      IFEQ      *BLANKS
     C                   MOVEL     'IL01106'     #MSGID
     C                   ENDIF
      *
      ***  Identification Number is mandatory
      *
     C     #LLXIDEN      IFEQ      *BLANKS
     C                   MOVEL     'IL01107'     #MSGID1
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
      ***  Validate Identification Code
      *
     C                   MOVE      *OFF          *IN99
     C****               TESTN                   #LLXIDCO             99        201628
     C**** *IN99         IFNE      *ON                                          201628
     C****               MOVEL     'IL01108'     #MSGID                         201628
     C****               ELSE                                                   201628
      *
     C                   MOVEL(P)  #LLXIDCO      ZFIELD
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
     C                   MOVEL     'IL01108'     #MSGID
     C                   ELSE                                                   201628
     C                   MOVE      ZFIELD        #LLXIDCO                       201628
     C                   ENDIF
     C***                ENDIF                                                  201628
      *
      ***  Validate Identification
      *
     C                   MOVE      *OFF          *IN99
     C***                TESTN                   #LLXIDEN             99
     C***  *IN99         IFNE      *ON                                          201628
     C***                MOVEL     'IL01109'     #MSGID1                        201628
     C***                ELSE                                                   201628
      *
     C                   MOVEL(P)  #LLXIDEN      ZFIELD
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
     C                   MOVEL     'IL01109'     #MSGID1
     C                   ELSE                                                   201628
     C                   MOVE      ZFIELD        #LLXIDEN                       201628
     C                   ENDIF
     C***                ENDIF                                                  201628
      *
      ***  If errors detected, bypass any further validation
      *
     C     #MSGID        IFNE      *BLANKS
     C     #MSGID1       ORNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  IBLC Identification must be 00, 23, 25 or 28
      *
     C     #LLXIDCO      IFNE      '00'
     C     #LLXIDCO      ANDNE     '23'
     C     #LLXIDCO      ANDNE     '25'
     C     #LLXIDCO      ANDNE     '28'
     C                   MOVEL     'IL01110'     #MSGID
     C                   ENDIF
      *
      ***  If Internal Branch Customer, Immatriculation Code
      ***  must be 00 or 23
      *
     C     *IN98         IFEQ      *OFF                                         Int. Branch Customer
     C     #LLXIDCO      ANDNE     '00'                                         Id Code
     C     #LLXIDCO      ANDNE     '23'
     C     #LLXIDCO      ANDNE     '25'                                         201568
     C                   MOVEL     'IL01111'     #MSGID1
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
      ***  Move *xxx where xxx is the branch code to bypass chain in sdcustl1
      ***  in the program IL0411
      *
     C                   MOVE      #LLXIDCO      @@IDCO
     C                   MOVE      #LLXIDEN      @@IDEN
     C                   MOVEL     'SDVCUIDCO2'  @@PGM
      *
     C                   CALL      'IL0411'
     C                   PARM                    @@IDCO                         Identification Code
     C                   PARM                    @@IDEN                         Identification Numbe
     C                   PARM                    @@PGM                          Calling pgm
      *
      ***  Result parameters
      *
     C                   PARM      *BLANKS       @@DBID                         Database error
     C                   PARM      *BLANKS       @@ERR1                         Error in #LLXIDCO
     C                   PARM      *BLANKS       @@ERR2                         Error in #LLXIDEN
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
      *
      ***  Bank Resident Customer Requires Identification Code '23'
      *
     C                   MOVE      #LLXIDEN      WWIDEN            4 0          201628
     C     #LLXTYPE      IFEQ      'BR'
     C     #LLXIDCO      ANDNE     '23'
     C     #LLXIDCO      ANDNE     '00'                                         201628
     C     #LLXIDCO      IFEQ      '25'                                         201628
     C     WWIDEN        ANDEQ     6662                                         201628
      *                                                                         201628
      ***  This is OK                                                           201628
      *                                                                         201628
     C                   ELSE                                                   201628
     C                   MOVEL     'IL01111'     #MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF                                                  201628
     C                   ENDIF
      *
      ***  Identification Code '23' is Only for Bank Resident Customer
      *
     C     #LLXIDCO      IFEQ      '23'
     C     #LLXTYPE      ANDNE     'BR'
     C                   MOVEL     'IL01112'     #MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Identification 25 000004442 Requires OPCVM Resident Customer (OR)
      *
     C                   MOVE      #LLXIDEN      WWIDEN            4 0
     C     #LLXIDCO      IFEQ      '25'
     C     WWIDEN        ANDEQ     4442
     C     #LLXTYPE      ANDNE     'OR'
     C     #1BNBI        ANDNE     'Y'
     C                   MOVEL     'IL01113'     #MSGID2
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  OPCVM Resident Customer (OR) Requires Identification 25 000004442
      *
     C     #LLXTYPE      IFEQ      'OR'
     C     #LLXIDCO      ANDNE     '25'
     C     WWIDEN        ANDNE     4442
     C                   MOVEL     'IL01114'     #MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Identification 25 0000088xx Requires Administration Resident Customer (AR)
      *
     C     #LLXIDCO      IFEQ      '25'
     C     #LLXIDEN      LOOKUP    OPCVM1                                 99
     C     *IN99         IFEQ      *ON                                          Found
     C     #LLXTYPE      ANDNE     'AR'
     C                   MOVEL     'IL01115'     #MSGID2
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   ENDIF
      *
      ***  Identification 25 and another of 0000088xx or 000004442 Requires Other
      ***  Requires Other Resident Customer ( R)
      *
     C     #LLXIDCO      IFEQ      '25'
     C     #LLXIDEN      LOOKUP    OPCVM2                                 99
     C     *IN99         IFEQ      *ON                                          Found
     C     #LLXTYPE      ANDNE     ' R'
      *                                                                         201628
      ***  201628 - Except for BR when 6662                                     201628
      *                                                                         201628
     C     #LLXTYPE      IFEQ      'BR'                                         201628
     C     WWIDEN        ANDEQ     6662                                         201628
     C                   ELSE                                                   201628
     C                   MOVEL     'IL01116'     #MSGID2
     C                   EVAL      ErrorFound = 'Y'
     C                   GOTO      #ERROR
     C                   ENDIF                                                  201628
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
     C                   MOVE      *BLANK        #LLXIDCO
     C                   MOVE      *BLANK        #LLXIDEN
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
     C                   PARM                    #MsgID2
     C                   PARM                    #LLXIDCO
     C                   PARM                    #LLXIDEN
     C                   PARM                    #LLXTYPE
     C                   PARM                    #1CUST
     C                   PARM                    #1BRCD
     C                   PARM                    #1BNBI
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
**  OPCVM1
000008812000008822000008832
**  OPCVM2
000001112000002222000003332000005552000006662000007772
000006612000006622000006632
**  CPY@
(c) Finastra International Limited 2005
