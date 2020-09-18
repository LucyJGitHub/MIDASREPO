     H DEBUG
     H COPYRIGHT ('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate WECOAC /WECOBR Correct Accnt/brc')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLVWECOAC  - Validate Correction Account and Branch Code     *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             Correction Account and a Branch Code and confirm  *
      *             if it is a valid Correction Account and Branch    *
      *             Code or not.                                      *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of: SP6GL0003 Service Program                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CER001             Date 25Apr05               *
      *                 ULX606  *CREATE    Date 18Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX606 - API Luxembourg - Function GLAMAD                    *
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
     D LETTER          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D NUMBER          C                   '0123456789'

      **
      **   Arrays and Data Structures
      **   ==========================
      **
      ** External DS for account details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **Data structure for Correction Account
     D                 DS
     D**********W6LXCOAC               1     15                                               CER001
     D  W6LXCOAC               1     21                                                       CER001
     D  W#CNUM                 1      6
     D  W#CCY                  7      9
     D**********W#ACOD                10     13                                               CER001
     D**********W#ACSQ                14     15                                               CER001
     D  W#ACOD                10     19                                                       CER001
     D  W#ACSQ                20     21                                                       CER001

      **
      **   Declared variables
      **   ==================
      **
      ** Define parameters received
     D**********#6LXCOAC        S             15A                                             CER001
     D #6LXCOAC        S             21A                                                      CER001
     D #6LXCOBR        S              3A
     D #6LXWECOAM      S             15  0
     D #1CCY           S              3A
     D #MsgID1         S              7A

      ** Define parameters for call module
     D @CUST           S              6A
     D @CCYD           S              3A
     D**********@ACCD          S              4A                                              CER001
     D @ACCD           S             10A                                                      CER001
     D @ACSN           S              2A
     D @BRCA           S              3A
     D @RETL           S             10A


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
      ** Either correction amount or correction acc. can be entered
      ** No test with correction account as module is called if field
      ** is not blank
      *
     C     #6LXWECOAM    IFNE      *ZEROS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89006'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Branch must be inputed if correction account specified
      *
     C     #6LXCOBR      IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89012'     #MSGID1
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      #6LXCOAC      W6LXCOAC
      *
      ** Customer number must be fully numeric
      *
     C                   MOVE      *OFF          *IN99
     C     NUMBER        CHECK     W#CNUM                                 99
     C     *IN99         IFEQ      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89007'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Currency code must be alphabetic but not spaces
      *
     C                   MOVE      *OFF          *IN99
     C     LETTER        CHECK     W#CCY                                  99
     C     *IN99         IFEQ      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89008'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Account Code must be fully numeric
      *
     C                   MOVE      *OFF          *IN99
     C     NUMBER        CHECK     W#ACOD                                 99
     C     *IN99         IFEQ      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89009'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Account Sequence must be fully numeric
      *
     C                   MOVE      *OFF          *IN99
     C     NUMBER        CHECK     W#ACSQ                                 99
     C     *IN99         IFEQ      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89010'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Account Number must exits in ACNUM
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @RETL
     C                   PARM      W#CNUM        @CUST
     C                   PARM      W#CCY         @CCYD
     C                   PARM      W#ACOD        @ACCD
     C                   PARM      W#ACSQ        @ACSN
     C                   PARM      #6LXCOBR      @BRCA
     C     ACCNT         PARM      ACCNT         DSSDY
      *
      ** If record not on file, setup message 'Account not found'
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89004'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** It must be a live account
      *
     C     RECI          IFNE      'D'
     C     ACST          OREQ      'C'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89005'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Currency code must be the same as in the main acc.
      *
     C     W#CCY         IFNE      #1CCY
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER89011'     #MSGID
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
     C                   PARM                    #MsgID1
     C                   PARM                    #6LXCOAC
     C                   PARM                    #6LXCOBR
     C                   PARM                    #6LXWECOAM
     C                   PARM                    #1CCY
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
