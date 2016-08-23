     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFAUTG Guarantee and Collateral')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFAUTG  - Validate Guarantee and Collateral               *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             guarantee and Collateral, and confirms wether it  *
      *             is a valid Guarantee and Collateral or not.       *
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
     D #6LXAUTG        S              1A
     D #6LXCGRP        S              6A
     D OK#6LXCGRP      S              1A
     D #1CUST          S              6A
 
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
      ** Gurantee and Collateral is mandatory
      *
     C     #6LXAUTG      IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01101'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C     #6LXAUTG      IFNE      'Y'
     C     #6LXAUTG      ANDNE     'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01102'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** The flag may be set to 'Y' for a not Economic Group
      ** only when the 'Processing for Eco group & Subs' field
      ** is 'N' on the Economic Group
      *
     C     #6LXAUTG      IFEQ      'Y'
     C     #1CUST        ANDNE     #6LXCGRP
     C     OK#6LXCGRP    ANDEQ     'Y'
      *
     C**********         MOVE      #6LXCGRP      W6LXCGRP          6 0                       CSD027A
     C                   Eval      W6LXCGRP = #6LXCGRP                                       CSD027A
     C*****W6LXCGRP      CHAIN     SDCUSTZ6                           99                      CER001
     C     W6LXCGRP      CHAIN     SDCUX2L1                           99                      CER001
     C     *IN99         IFEQ      *ON
     C**********         MOVEL     'SDCUSTZ6'    DBFILE                          ************ CER001
     C                   MOVEL     'SDCUX2L1'    DBFILE                          ************ CER001
     C                   Z-ADD     900           DBASE                           * DBER 900 *
     C                   MOVEL     #6LXCGRP      DBKEY                           ************
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C     VFPROG        IFEQ      'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER01103'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
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
     C                   PARM                    #6LXAUTG
     C                   PARM                    #6LXCGRP
     C                   PARM                    OK#6LXCGRP
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
