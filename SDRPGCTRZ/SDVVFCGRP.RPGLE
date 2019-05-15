     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate VFCGRP Economic Group')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVVFCGRP  - Validate Economic Group                         *
      *                                                               *
      *  Function:  This module receives a parameter containing an    *
      *             economic group, and confirms wether it is a valid *
      *             economic group or not.                            *
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
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 203235             Date 22Feb02               *
      *                 FIXML              Date 31Jul00               *
      *                 ULX609  *CREATE    Date 31Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus (Recompile only)           *
      *  203025 - Defaulting must not cause any problem               *
      *           but when redisplay due to F12 pressed on next window*
      *           Economic Group is not validated in insertion because*
      *           Details not yet in Master file SDCUSTPD             *
      *  FIXML  - Decimal data error                                  *
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for currency details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #6LXCGRP        S              6A
     D #6LXVFCGRP      S              6A
     D #1PAIN          S              1A
     D #1PCNB          S              6A
     D #1CUST          S              6A
 
      ** Define parameters for call module
     D @KEY1           S             10A
     D @KYST           S              7A
 
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
      ** Setup Economic Group if the field is blanks
      *
     C     #6LXCGRP      IFEQ      *BLANKS
      *
     C     #1PAIN        IFNE      'P'
     C     #1PCNB        ANDNE     *BLANKS
     C                   MOVEL     #1PCNB        #6LXCGRP
     C                   ELSE
     C                   MOVEL     #1CUST        #6LXCGRP
     C                   ENDIF
      *
     C                   ELSE
      *
     C     '?'           SCAN      #6LXCGRP      WRESUL            1 0    77
     C     *IN77         IFEQ      '1'
     C                   MOVE      *BLANKS       #6LXCGRP
     C                   MOVEL     '?'           #6LXCGRP
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       @KEY1
     C                   MOVE      *BLANKS       SDCUST                                       203235
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #6LXCGRP      @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     #6LXCGRP      ANDNE     #1CUST                                       itself        203235
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVE      'ER01007'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C     *IN77         IFEQ      '1'
     C                   EVAL      RetCodeIn = '?'
     C                   MOVEL     BBCUST        #6LXCGRP
     C                   ENDIF
      *
     C                   MOVE      BBCUST        #6LXVFCGRP
      *
     C                   ENDIF
     C     #6LXVFCGRP    IFEQ      *BLANKS                                           FIXML
     C                   MOVE      #6LXCGRP      #6LXVFCGRP                          FIXML
     C                   END                                                         FIXML
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
     C                   PARM                    #6LXCGRP
     C                   PARM                    #6LXVFCGRP
     C                   PARM                    #1PAIN
     C                   PARM                    #1PCNB
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
