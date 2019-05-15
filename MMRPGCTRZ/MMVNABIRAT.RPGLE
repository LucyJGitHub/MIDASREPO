     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate interest rate                  ')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  MMVNABIRAT - Validate Interest rate                          *
      *               **** FOR NA'S PURCHASED ****                    *
      *                                                               *
      *  Function:  This module validates the interest rate field     *
      *               **** FOR NA'S PURCHASED ****                    *
      *                                                               *
      *  Component of:                 modules service program        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR814519           Date 10Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 18Nov97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR814519 - Allow negative base rate.                         *
      *           - Applied for MD033488                              *
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
      ***Name*of*the*ZA0840*routine*(Validate*field*is*numeric)********                     AR814519
     D*ZA0840***       C                   CONST('ZA0840')                                  AR814519
      ** Name of the ZA0841 routine (Validate field is numeric)                             AR814519
     D ZA0841          C                   CONST('ZA0841')                                  AR814519
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Deal type
     D DDMTYP          S              2A
 
      ** Decimal separator
     D BNDCSP          S              1A
 
     ** Face rate
     D IHFRAT          S             11  7
 
     ** Int Rate      **
     D DDINTR          S             12A
 
 
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   MSGID1
 
      *  *-------------------------------*
      *  * Validate Interest Rate/Spread *
      *  *-------------------------------*
      *
      **  If the deal type has been input, validate the spread/rate.
      *
     C     DDMTYP        IFEQ      'C1'
     C     DDMTYP        OREQ      'C2'
     C     DDMTYP        OREQ      'BP'
     C     DDMTYP        OREQ      'BD'
      *
      **  If the spread/rate is blank, this is an error.
     C     DDINTR        IFEQ      *BLANKS
     C                   MOVEL     'MMM0419'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
      *
      **  Check it is a valid figure with 7 decimal places max.
     C                   ELSE
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDINTR        @@ALPH
     C                   MOVE      'N'           @@MTID
 
     C**********         CALLB     'ZA0840'                                                 AR814519
     C                   CALLB     'ZA0841'                                                 AR814519
      *                  ~~~~~~~~~~~~~~~~~
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
     C     @@ERCD        IFNE      0
     C**********         MOVEL     'MMM0422'     MSGID1                                     AR814519
     C                   MOVEL     'MMM9023'     MSGID1                                     AR814519
     C                   EVAL      ErrorFound = 'Y'
      *
      **  If deal type is not a 'BD' and interest rate is zero
      **  then it is an error.
     C                   ELSE
     C                   MOVE      @@ALPH        DDINTR
     C     DDMTYP        IFNE      'BD'
     C     @@AMT         ANDEQ     0
     C                   MOVEL     'MMM0421'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   ELSE
     C     @@AMT         DIV       10000000      @SPRD            11 7
     C                   END
     C                   END
     C                   END
      *
      *
      **  If the deal type is not a 'CD' then interest/spread rate should
      **  be blank.
     C                   ELSE
     C     DDINTR        IFNE      *BLANKS
     C                   MOVEL     'MMM0420'     MSGID1
     C                   EVAL      ErrorFound = 'Y'
     C                   END
     C                   END
      *
      **  If the spread/rate is valid, determine the effective rate and
      **  output it
     C     ErrorFound    IFNE      'Y'
     C     DDINTR        IFNE      *BLANKS
     C     @@AMT         DIV       10000000      IHFRAT
     C                   ELSE
     C                   Z-ADD     0             IHFRAT
     C                   END
     C                   END
 
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
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A)
     C                   PARM                    RetCodeIn
      ** Message ID
     C                   PARM                    MsgID1
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP            2
      ** Interest Rate, from transaction
     C                   PARM                    DDINTR           12           12A
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP            1
      ** Face rate - output from this module
     C                   PARM                    IHFRAT           11 7
 
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
