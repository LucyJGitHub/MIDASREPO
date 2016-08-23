     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFPLGT Pledges Given To Customer')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFPLGT  - Validate Pledges Given To Customer              *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             Pledges Given to customer and a Assets Pleged, and*
      *             confirm wether it is a valid Pledges Given to     *
      *             customer or not.                                  *
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
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX609  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CER001 - LUX Upgrade to MidasPlus (Recompile only)           *
      *  ULX609 - API Luxembourg - Function SDCUSD                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F***SDCUSTX6  IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FSDCUX2PD  IF   E           K DISK    INFSR(*PSSR)                                       CER001
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for currency details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D*NWCUST***     E DS                  EXTNAME(SDCUSTX6)                                  CER001
     D NWCUST        E DS                  EXTNAME(SDCUX2PD)                                  CER001
      ** New Record
 
     D SAVECUST        DS            59
      ***Save*Pledges*Given*to*Customer*(Position*54*to*59*in*SDCUSTX6)                       CER001
      ** Save Pledges Given to Customer (Position 54 to 59 in SDCUX2PD)                       CER001
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #6LXPLGT        S              6A                                        Pledges Given To
     D #6LXASSP        S              1A                                        Assets Pledged
 
      ** Define parameters for call module
     D @KEY1           S             10A
     D @KYST           S              7A
 
     D WKCGRP          S              6A                                                     CSD027A
 
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
     C     #6LXPLGT      IFNE      *BLANKS                                      - B1
      *
      **  Pledges given to Number must exist as a customer
      *
     C     '?'           SCAN      #6LXPLGT      WRESUL            1 0    77
     C     *IN77         IFEQ      '1'
     C                   MOVE      *BLANKS       #6LXPLGT
     C                   MOVEL     '?'           #6LXPLGT
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       @KEY1
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #6LXPLGT      @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL3201'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C     *IN77         IFEQ      '1'
     C                   EVAL      RetCodeIn = '?'
     C                   MOVEL     BBCUST        #6LXPLGT
     C                   ENDIF
      *
      **  Pledges Given to customer should exist on Extension File
      *
     C                   MOVE      NWCUST        SAVECUST
     C*****#6LXPLGT      CHAIN(N)  SDCUSTX6                           85                      CER001
     C     #6LXPLGT      CHAIN(N)  SDCUX2PD                           85                      CER001
     C     *IN85         IFEQ      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL3205'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      **  Customer number should be setup with "Guarantees & Collateral
      **  Automatic Generation" Flag set to 'Y'
      *
     C     VFAUTG        IFEQ      'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL3202'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      **  Economic Group of the "Pledges Given to" Customer must be
      **  different from the Economic Group of the customer being
      **  maintained
      *
     C**********         Z-ADD     VFCGRP        WKCGRP            6 0                       CSD027A
     C                   Eval      WKCGRP = VFCGRP                                           CSD027A
     C                   MOVE      SAVECUST      NWCUST
     C     WKCGRP        IFEQ      VFCGRP
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL3203'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      **  The "Assets Pledged" Flag of the customer being maintained
      **  should not be equal to 'Y'
      *
     C     #6LXASSP      IFEQ      'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ERL3204'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ENDIF                                                  - E1
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   SETON                                        LR
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
     C                   PARM                    #6LXPLGT
     C                   PARM                    #6LXASSP
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
