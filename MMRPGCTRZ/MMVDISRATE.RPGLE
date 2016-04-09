     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Discount Rate                  ')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVDISRATE - Validate Discount/Yield Rate                    *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Discount/yield Rate and checks whether it has a   *
      *             valid value.                                      *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      *  Prev Amend No. CAP002  *CREATE    Date 11Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  216117 - Yield/discount rate is an optional field for NAP    *
      *           deals with type equal to 'C2', 'BP' or 'BD'.        *
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
 
      ** Error messages field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
      ** Discount Rate        - received as a parameter
     D DDDCRT          S             11A
      ** Deal Type            - received as a parameter
     D DDMTYP          S              2A
      ** Decimal separator character (1A from SDDEALPD, via caller)
     D BNDCSP          S              1A
 
      ** Face rate received as a parameter
     D IHFRAT          S             11P 7
 
      ** Parameter list for ZA0840
      ** =========================
 
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
      ** ¦ Initial processing is performed automatically: the *INZ        ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *------------------------------------------*
      *  * Validate Yield Discount Rate             *
      *  *------------------------------------------*
      *
      **  If the deal type is not 'C1' then Yield/discount rate must be
      **  entered.
     C     DDMTYP        IFNE      'C1'
      *
     C     DDDCRT        IFEQ      *BLANKS
      *                                                                                       216117
     C     DDMTYP        IFEQ      'C2'                                                       216117
     C     DDMTYP        OREQ      'BP'                                                       216117
     C     DDMTYP        OREQ      'BD'                                                       216117
     C                   Z-ADD     0             @@AMT                                        216117
     C                   ELSE                                                                 216117
     C                   MOVEL     'MMM0424'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF                                                                216117
      *
      **  Check it is a valid figure with 7 decimal places max.
     C                   ELSE
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDDCRT        @@ALPH
     C                   MOVE      'N'           @@MTID
 
     C                   CALLB     'ZA0840'                                     ***3
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
 
     C     @@ERCD        IFNE      0
     C                   MOVEL     'MMM0425'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   ELSE
     C                   MOVE      @@ALPH        DDDCRT
     C                   END
     C                   END
      *
      **  If the deal type is 'C1' then Yield/discount rate should not
      **  be entered.
     C                   ELSE
      *
     C                   Z-ADD     *ZERO         @@AMT
      *
     C     DDDCRT        IFNE      *BLANKS
     C                   MOVEL     'MMM0423'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
      *
      **  Output valid Yield/Discount rate
     C     ErrorFound    IFNE      'Y'
      *
      ** For Int. bearing NA's use Int. rate ELSE use Discount rate
      *
     C     DDMTYP        IFEQ      'C1'
     C                   Z-ADD     IHFRAT        IHINTR
     C                   END
     C     DDMTYP        IFEQ      'C2'
     C     DDMTYP        OREQ      'BP'
     C     DDMTYP        OREQ      'BD'
     C     @@AMT         DIV       10000000      IHINTR
     C                   ELSE
     C     @@AMT         DIV       10000000      IHDCRT
     C                   END
      * error found
     C                   ELSE
     C     DDMTYP        IFEQ      'C1'
     C     DDMTYP        OREQ      'C2'
     C     DDMTYP        OREQ      'BP'
     C     DDMTYP        OREQ      'BD'
     C                   Z-ADD     0             IHINTR
     C                   ELSE
     C                   Z-ADD     0             IHDCRT
     C                   END
     C                   END
      *
      *
      *
      ** If an error was found, set the return code appropriately
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
      ** Discount rate
     C                   PARM                    DDDCRT           11
      ** Deal Type
     C                   PARM                    DDMTYP            2
      ** Interest rate -      (Std. Deals file MMSTDBPP)
     C                   PARM                    IHINTR           11 7
      ** Discount rate -      (Std. Deals file MMSTDBPP)
     C                   PARM                    IHDCRT           11 7
      ** Face rate     -      (Std. Deals file MMSTDBPP)
     C                   PARM                    IHFRAT           11 7
      ** Decimal separator
     C                   PARM                    BNDCSP            1
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
