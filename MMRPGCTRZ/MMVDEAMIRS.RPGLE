     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Interest Rate/Spread    (DeAms)')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMIRS - Validate Interest Rate/Spread                   *
      *               (for Deal Amendment processing)                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Rate or Spread and confirms if it is     *
      *             valid. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD033488           Date 12Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL033             Date 10Feb05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD033488 - Allow negative rates. Change message id of error  *
      *             code from 'MMM0422' to 'MMA0039'.                 *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CDE002 - Revenue Analysis                                    *
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
     D INFDS           DS
      **  Data structure for file status of MM deals file.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** External data structure for access programs (short)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Deal Amendment Type received as a parameter
     D DDMTYP          S              2A
 
      ** Interest Rate/Spread received as a parameter
     D DDINTR          S             12A
 
      ** Analytical Accounting Installed Indicator (from SDMMODPD)
      ** received as a parameter
     D BGN0ST          S              1A
 
      ** Decimal separator from SDDEALPD received as a parameter
     D BNDCSP          S              1A
 
      ** Interest Rate/Spread returned to caller
     D IGINTR          S             11  7
 
      ** Revenue Analysis received as parameter                                 CDE002
     D CDE002          S              1A                                        CDE002
 
      ** Amount received as parameter                                           CDL017
     D DDAMNP          S             15A                                        CDL017
                                                                                CDL017
      ** Fields used in call to Module ZA0840
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Number of decimal places
     D @@IDP           S              3  0
      ** Number of integers
     D @@IINT          S              3  0
 
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
      *
     C*  *-------------------------------*
     C*  * Validate Interest Rate/Spread *
     C*  *-------------------------------*
     C*
      **  If spread/rate is blank, deal type is SC, & analytical accounting
      **  and revenue analysis not installed, this is an error                  CDE002
      ****not*installed,*this*is*an*error**********************************     CDE002
      *
     C     DDMTYP        IFEQ      'SC'
     C     DDINTR        ANDEQ     *BLANKS
     C     BGN0ST        ANDEQ     'N'
     C     CDE002        ANDEQ     'N'                                          CDE002
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0468'     Msgid1
     C                   END
     C*
     C**  If the spread/rate is not blank, this is an error for type
     C**  other than SC.
     C     DDMTYP        IFNE      'SC'
     C     DDMTYP        ANDNE     'EM'                                                       CDL017
     C     DDMTYP        ANDNE     'BC'                                                       CDL022
     C     DDINTR        ANDNE     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0469'     Msgid1
     C                   END
                                                                                              CDL017
      ** Rate/Spread must be blank if Penalty Fee entered for type EM                         CDL017
     C     DDMTYP        IFEQ      'EM'
     C     DDINTR        ANDNE     *BLANKS                                                    CDL017
     C     DDAMNP        ANDNE     *BLANKS                                                    CDL017
     C                   EVAL      ErrorFound = 'Y'                                           CDL017
     C                   MOVEL     'MMM0349'     Msgid1                                       CDL017
     C                   ENDIF                                                                CDL017
     C*
     C**  Check it is a valid figure with 7 decimal places max.
     C     ErrorFound    IFNE      'Y'
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDINTR        @@ALPH
     C                   MOVE      'N'           @@MTID            1
     C**********         CALLB     'ZA0840'                                                   CDL033
      *                                                                                       CDL033
      ** Change to ZA0841 to allow input of negative amount                                   CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZA0841'                                                   CDL033
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
      *
     C     @@Ercd        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C**********         MOVEL     'MMM0422'     Msgid1                                     MD033488
     C                   MOVEL     'MMA0039'     Msgid1                                     MD033488
     C                   END
     C                   END
     C*
     C**  If the spread/rate is valid, determine the effective rate and
     C**  output it
     C     ErrorFound    IFNE      'Y'
     C     DDINTR        IFNE      *BLANKS
     C     @@Amt         DIV       10000000      IGINTR
     C                   MOVE      @@ALPH        DDINTR
     C                   ELSE
     C                   Z-ADD     0             IGINTR
     C                   END
     C                   END
     C*
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C*
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
     C                   PARM                    DDMTYP
     C                   PARM                    DDINTR
     C                   PARM                    BGN0ST
     C                   PARM                    BNDCSP
     C                   PARM                    IGINTR
     C                   PARM                    CDE002                         CDE002
     C                   PARM                    DDAMNP                         CDL017
 
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
