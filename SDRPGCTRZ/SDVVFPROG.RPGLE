     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFPROG Processing for Eco. Group')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFPROG  - Validate Processing for Economic Group          *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             processing for economic group, and confirms wether*
      *             it is a valid processing for economic group or not*
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP121CTYLX - Core Luxembourg service program  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 CER001             Date 25Apr05               *
      *                 ULX609  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     F***SDCUSTZ6  IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FSDCUX2L1  IF   E           K DISK    INFSR(*PSSR)                                       CER001
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
     D #6LXPROG        S              1A                                        Proces. Eco. Group
     D #6LXCGRP        S              6A                                        Economic Group
     D #1CUST          S              6A                                        Customer
     D WCUST           S              6A                                                     CSD027A
     D W6LXCGRP        S              6A                                                     CSD027A
 
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
      ** Valid Processing for Economic Group
      *
     C     #6LXPROG      IFNE      'Y'
     C     #6LXPROG      ANDNE     'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01104'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** No validation if Processing for Economic Group is 'N'
      *
     C     #6LXPROG      IFEQ      'N'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** The flag may only be set to 'Y' when Economic Group
      ** field is maintained
      *
     C     #6LXPROG      IFEQ      'Y'
     C     #6LXCGRP      ANDEQ     '0'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01105'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** The flag may only be set when the customer is the
      ** Economic Group
      *
     C     #6LXPROG      IFEQ      'Y'
     C     #1CUST        ANDNE     #6LXCGRP
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01105'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** The flag may only be set to 'Y' if the guarantees & Coll
      ** automatic flag is 'N' for all the subsidiaies.
      *
     C                   MOVE      'N'           WWFIND            1
     C**********         MOVE      #6LXCGRP      W6LXCGRP          6 0                       CSD027A
     C                   Eval      W6LXCGRP = #6LXCGRP                                       CSD027A
     C*****W6LXCGRP      SETLL     SDCUSTZ6                                                   CER001
     C     W6LXCGRP      SETLL     SDCUX2L1                                                   CER001
     C*****W6LXCGRP      READE     SDCUSTZ6                               99                  CER001
     C     W6LXCGRP      READE     SDCUX2L1                               99                  CER001
      *
     C     *IN99         DOWEQ     *OFF
     C     WWFIND        ANDEQ     'N'
      *
     C**********         MOVE      VFCUST        WCUST             6 0                       CSD027A
     C                   Eval      WCUST = VFCUST                                            CSD027A
     C     VFAUTG        IFEQ      'Y'
     C     WCUST         ANDNE     VFCGRP
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01106'     #MSGID
     C                   GOTO      #ERROR
     C                   MOVE      'Y'           WWFIND
     C                   ENDIF
      *
     C**********         READE     SDCUSTZ6                               99                  CER001
     C                   READE     SDCUX2L1                               99                  CER001
     C                   ENDDO
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
     C                   PARM                    #6LXPROG
     C                   PARM                    #6LXCGRP
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
(c) Finastra International Limited 2005
