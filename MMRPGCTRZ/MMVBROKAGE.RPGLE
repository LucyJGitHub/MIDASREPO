     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate brokerage Amount')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBROKERAGE - Validate brokerage amount                     *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             brokerage and confirms whether it has a valid     *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
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
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG10582           Date 20Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10582 - Error displayed upon Approve Input of a deal      *
      *  CDL006 - Dealing Fiduciary.                                  *
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
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Broker code is received as a parameter
     D DDBKCD          S              4A
     D DDBKCDOk        S              1A
 
      ** Brokerage Amount received as a parameter
     D DDBRKG          S             14A
 
      ** Australian Switchable Feature Indicator received as a parameter
     D AUS007          S              1A
 
      ** Rate/Amount Indicator (used with AUS007) received as a parameter
     D DDRACD          S              1A
     D DDRACDOk        S              1A
 
      ** Deal Currency passed as a parameter
     D DDCCY           S              3A
 
      ** Broker Currency Code Field passed as a parameter
     D A9BRCY          S              3A
 
      ** Deal File Brokerage Field passed as a parameter
     D IKBRKG          S             15  0
 
      ** Deal File Brokerage Currency passed as parameter
     D IKBKCY          S              3A
 
      ** Deal Type Passed as a parameter
     D DDTYPE          S              2A
 
 
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
 
      ** Amount after processing by ZA0840
     D @@AMT           S             15  0
 
      ** Decimal separator
     D     BNDCSP      S              1A
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
      **
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
      ** Brokerage Validation:
      ** 1) Only call this routine if Broker Code is valid
      **
      ** 2) If AUS007 is on only call this routine if DDRACD
      **    (Rate Amount Indicator) is valid
      **
      ** 3) Brokerage is valid if not entered.
      *
      *
     C     DDBRKG        IFNE      *BLANKS
     C     DDRacdOK      ANDEQ     'Y'
     C     DDBkcdOK      ANDEQ     'Y'
      *
      **  If the Broker was not entered it is an error to enter the
      **  Brokerage.
     C     DDBKCD        IFEQ      *Blanks
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0199'     Msgid1
     C                   ENDIF
      *
      **  If the Broker is TELX the Brokerage may not be entered
     C     DDBKCD        IFEQ      'TELX'
     C     DDBKCD        OREQ      'MAIL'
     C     DDBKCD        OREQ      'PHON'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0194'     Msgid1
     C                   ENDIF
      *
     C     ErrorFound    IFNE      'Y'
      *
      ** Australian Brokerage
      *
     C     AUS007        IFEQ      'Y'
     C     DDRACD        IFEQ      'R'
      *
      ** call za0840 to validate rate has correct no of decimal
      ** places and is a valid number.
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      'N'           @@MTID
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBRKG        @@ALPH
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
     C     @@ERCD        IFEQ      1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0198'     Msgid1
     C                   END
     C     @@ERCD        IFEQ      2
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0200'     Msgid1
     C                   END
      *
     C                   MOVE      DDCCY         IKBKCY
     C                   Z-ADD     @@AMT         IKBRKG
     C                   MOVE      @@ALPH        DDBRKG                                     BUG10582
      *
     C                   ELSE
      *
     C     DDRACD        IFEQ      'A'
      *
     C     DDTYPE        IFEQ      'CD'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1061'     Msgid1
      *
     C                   END
     C                   END
     C                   END
     C                   END
      *
      **  Validate that the Brokerage entered has the correct number
      **  of decimal places and is a valid number, using ZA0840.
      **  Brokerage must be a whole number.
      *
     C     DDRACD        IFNE      'R'
      *
      ** access currency file to get number of decimal places
      ** for the broker currency
      *  (database error handling done in access program)
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A9BRCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** call za0840 to validate currency has correct no of decimal
      ** places and is a valid number.
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBRKG        @@ALPH
     C                   MOVE      'N'           @@MTID            1
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      **  If the input value was non-numeric, it is an error.
      *
     C     @@ERCD        IFEQ      1
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0198'     Msgid1
     C                   END
      *
      **  If the figure entered had an incorrect number of decimals,
      **  it is an error.
     C     @@ERCD        IFEQ      2
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0200'     Msgid1
     C                   END
      *
     C                   END
     C                   END
     C                   END
      *
      **  If the Brokerage is valid, put the formatted field into
      **  the screen field, and place the Broker Ccy into the Standard
      **  Deal format.
      *
     C     ErrorFound    IFNE      'Y'
     C     DDRACD        ANDNE     'R'
      *
     C     DDBRKG        IFNE      *BLANKS
     C                   MOVE      @@ALPH        DDBRKG
      *
     C     DDBKCD        IFNE      *BLANKS
     C                   Z-ADD     @@AMT         IKBRKG
     C                   MOVE      A9BRCY        IKBKCY
     C                   END
      *
     C                   ELSE
      *
     C                   Z-ADD     *ALL'9'       IKBRKG
     C                   END
      *
     C                   END
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDBKCD
     C                   PARM                    DDBKCDOk
     C                   PARM                    DDBRKG
     C                   PARM                    AUS007
     C                   PARM                    DDRACD
     C                   PARM                    DDRACDOk
     C                   PARM                    DDCCY
     C                   PARM                    A9BRCY
     C                   PARM                    IKBRKG
     C                   PARM                    IKBKCY
     C                   PARM                    DDTYPE
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
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
