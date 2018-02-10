     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate brokerage Amount for NAs')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNASBRKG - Validate brokerage amount for negotiable assets *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             brokerage and confirms whether it has a valid     *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
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
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for Currencies file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
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
 
      ** Error message ID 1
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Deal file version of broker currency (3A, returned to caller)
     D IHBKCY          S                   LIKE(A9BRCY)
 
      ** Broker code received as a parameter
     D DDBKCD          S              4A
 
      ** Brokerage Amount received as a parameter
     D DDBRKG          S             14A
 
      ** Broker Currency Code Field received from caller
     D A9BRCY          S              3A
 
      ** Deal file Brokerage Field returned to caller
     D IHBRKG          S             15  0
 
      ** Decimal separator
     D     BNDCSP      S              1A
 
      ** Broker code OK flag (1A, from caller)
     D DDBKCDOK        S              1A
 
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
 
     C** Allow 'NIL' for brokerage.
     C     DDBRKG        IFEQ      'NIL'
     C                   MOVE      *BLANKS       DDBRKG
     C                   MOVE      0             DDBRKG
     C                   ENDIF
 
     C**  If the Brokerage is blank it is valid; if the Broker was invalid
     C**  by-pass the Brokerage validation.
     C     DDBRKG        IFNE      *BLANKS
     C     DDBKCDOK      ANDNE     'N'
     C*
     C**  If the Broker was not entered it is an error to enter the
     C**  Brokerage.
     C     DDBKCD        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0199'     MsgID1
     C                   ENDIF
 
      **  If the Broker is TELX,MAIL, or PHON the Brokerage may
      **  not be entered.
     C     DDBKCD        IFEQ      'TELX'
     C     DDBKCD        OREQ      'MAIL'
     C     DDBKCD        OREQ      'PHON'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0194'     MsgID1
     C                   ENDIF
 
      **  If there has been an error do not validate Brokerage further.
     C                   IF        ErrorFound = 'N' AND DDBKCDOK <> 'N'
 
      **  Validate that the Brokerage entered has the correct number
      **  of decimal places and is a valid number, using ZA0840.
032   * CALL ACCESS PROG. FOR CURRENCY DETAILS.
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A9BRCY        @CURKY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** call za0840 to validate currency has correct no of decimal
      ** places and is a valid number.
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBRKG        @@ALPH
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
 
      **  If the input value was non-numeric, it is an error.
     C     @@ERCD        IFEQ      1
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0198'     MsgID1
     C                   ENDIF
     C*
     C**  If the figure entered had an incorrect number of decimals,
     C**  it is an error.
     C     @@ERCD        IFEQ      2
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0200'     MsgID1
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C*
     C**  If the Brokerage is valid, put the formatted field into
     C**  the screen field, and output the Broker Ccy and amount
 
     C                   Z-ADD     *ZEROS        IHBRKG
 
     C                   IF        ErrorFound = 'N' AND DDBKCDOK <> 'N'
 
     C                   IF        DDBRKG <>  *blanks
     C                   MOVE      @@ALPH        DDBRKG
     C                   Z-ADD     @@AMT         IHBRKG
 
      ** If brokerage is blank output the amount as all 9s
     C                   ELSE
     C                   MOVE      *ALL'9'       IHBRKG
     C                   ENDIF
 
     C                   ENDIF
 
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
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Error message ID (7A, returned to caller)
     C                   PARM                    Msgid1
      ** Deals file version of brokerage amount (15,0P, returned
      ** to caller)
     C                   PARM                    IHBRKG
      ** Deals file version of broker currency (3A, returned
      ** to caller)
     C                   PARM                    IHBKCY
      ** Broker code (4A, from transaction)
     C                   PARM                    DDBKCD
      ** Brokerage (15A, from transaction)
     C                   PARM                    DDBRKG
      ** Broker currency (3A, from SDBROKPD, via caller)
     C                   PARM                    A9BRCY
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
      ** Broker OK flag (1A, from caller)
     C                   PARM                    DDBKCDOK
 
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
(c) Finastra International Limited 2001
