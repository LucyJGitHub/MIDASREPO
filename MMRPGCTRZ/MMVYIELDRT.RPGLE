     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate NA yield rate')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVYIELDRT - Validate Negotiable asset sold yield rate       *
      *                                                               *
      *  Function:  This module checks that a 12A field contains a    *
      *             legitimate yield rate.                            *
      *                                                               *
      *  Component of: MMVALIDATE - Money Market validation service   *
      *                             program.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 216117             Date 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  216117 - Yield rate is an optional field for NAS deals with  *
      *           type equal to 'CS', 'BS' or 'BR'.  Applied fix      *
      *           216117.                                             *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID 1 (10A, returned to caller)
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Deal file version of yield rate (11,7P, returned                   )
      ** to caller
     D ILINTR          S             11P 7
 
      ** Yield rate (12A, from transaction)
     D DDINTR          S             12A
 
      ** Decimal separator character (1A from SDDEALPD, via caller)
     D BNDCSP          S              1A
 
      ** End of parameters
      ** =================
 
      ** =========================
      ** Parameter list for ZA0840
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
 
      ** Number of decimal places field for numeric validation
     D @@IDP           S              2  0
 
      ** Number of integers field for numeric validation
     D @@IINT          S              2  0
 
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
 
      ** Amount calculation field
     D @@AMT           S             15  0
 
      ** Error return code for ZA0840 module
     D @@ERCD          S              1  0
 
      ** Numeric version of spread
     D @SPRD           S             11P 7
      ** End of parameter list for ZA0840
      ** ================================
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
     C**  If the yield rate is blank, this is an error.
     C**  Unless NAB deal type is 'C1'
     C*
     C     DDINTR        IFEQ      *BLANKS
      *                                                                                       216117
     C     DDMTYP        IFEQ      'CS'                                                       216117
     C     DDMTYP        OREQ      'BS'                                                       216117
     C     DDMTYP        OREQ      'BR'                                                       216117
     C                   Z-ADD     0             @@AMT                                        216117
     C                   ELSE                                                                 216117
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0424'     MsgID1
     C                   ENDIF                                                                216117
     C*
     C**  Check it is a valid figure with 7 decimal places max.
     C                   ELSE
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDINTR        @@ALPH
     C                   MOVE      'N'           @@MTID            1
 
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
     C     @@ERCD        IFNE      0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0425'     MsgID1
 
     C                   ELSE
 
     C                   MOVE      @@ALPH        DDINTR
     C                   END
     C                   END
 
     C**  Output valid Yield/Discount rate
     C     ErrorFound    IFEQ      'N'
     C*
     C** FOR INT BEARING NAS USE INT RATE ELSE USE DISCOUNT RATE
     C     @@AMT         DIV       10000000      ILINTR
     C*
     C                   ELSE
     C*
     C                   Z-ADD     0             ILINTR
     C                   END
 
      ** Set return code
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msgid1
      ** Deal file version of yield rate (11,7P, returned                   )
      ** to caller
     C                   PARM                    ILINTR
      ** Yield rate (12A, from caller)
     C                   PARM                    DDINTR
      ** Decimal separator character (1A from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      ** Deal Type                                                                            216117
     C                   PARM                    DDMTYP            2                          216117
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
