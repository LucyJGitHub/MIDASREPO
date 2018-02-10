     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate penalty amount')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVPNAM    - Validate The Penalty amount                     *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             the penalty amount and confirms whether it is a   *
      *             valid value. If it is valid the 10A return code   *
      *             will be blank; if it is not it will contain       *
      *             'Error'                                           *
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
      *  Prev Amend No. AR704846           Date 15Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CDL007  *CREATE    Date 06Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR704846 - Amend program to show warning message for IP/TI   *
      *             deal. (Child artifact: AR704847)                  *
      *  CDL007 - Deposit Breakdown Penalty                           *
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
 
      ** Warning message ID
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Penalty Amount is received as a parameter
     D DDPENA          S             14A
 
      ** Action Code is received as a parameter
     D DDACTN          S              1A
 
      ** Status of currency after validation received as a parameter
     D DDCcyOK         S              1A
 
      ** Deal Type Received as a parameter
     D DDTYPE          S              2A
 
      ** Private Banking Module indicator received as a parameter
     D BGN4ST          S              1A
 
      ** Maturity Date received as a parameter
     D IKMATD          S              5P 0
 
      ** Previous Maturity Date received as a parameter
     D OLD_IKMATD      S              5P 0
 
      ** Previous Penalty Amount
     D OLDPENA         S             13P 0
 
      ** Test Numeric Penalty Amount
     D TSPENA          S             13P 0
 
      ** Number of decimal places for currency received as a parameter
     D A6NBDP          S              1S 0
 
      ** Amount passed to ZA0840 as a parameter
     D @@AMT           S             15  0
 
      ** Deal File Penalty Amount output as a parameter
     D IKPENA          S             13  0
 
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
 
      ** Decimal separator
     D BNDCSP          S              1A
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     D RespMode        S              1A
 
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
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgID1
 
     C                   Z-ADD     IKPENA        OLDPENA
     C                   Z-ADD     *zeros        IKPENA
     C                   Z-ADD     *zeros        TSPENA
 
     C     DDPENA        IFNE      *BLANKS
     C     DDCcyOK       ANDNE     'N'
     C                   Z-ADD     A6NBDP        @@IDP
     C     14            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDPENA        @@ALPH
     C                   MOVE      'Y'           @@MTID
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
 
     C     @@ERCD        IFEQ      0
     C                   Z-ADD     @@AMT         TSPENA
     C                   ENDIF
     C                   ENDIF
      *
      ** No Entry is allowed on the Penalty field if
      ** the Private Banking module is switched on
      ** Error if blank
      *
     C     DDPENA        IFNE      *BLANKS
     C     TSPENA        ANDNE     OLDPENA
     C     RespMode      ANDEQ     'S'
     C     BGN4ST        ANDEQ     'Y'
     C     DDCcyOK       ANDNE     'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0692'     Msgid1
     C                   ENDIF
      *
      **  Verify that the amount entered is valid numeric.
      **  And if there was no error found in the currency validation
     C     DDPENA        IFNE      *BLANKS
     C     ErrorFound    ANDNE     'Y'
     C     DDCcyOK       ANDNE     'N'
     C                   Z-ADD     A6NBDP        @@IDP
     C     14            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDPENA        @@ALPH
     C                   MOVE      'Y'           @@MTID
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
 
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0693'     Msgid1
     C                   ELSE
 
      **  The amount must not be zero.
     C     @@AMT         IFEQ      *ZEROS
     C     DDACTN        ANDEQ     'A'
     C     DDTYPE        ANDEQ     'TD'
     C     IKMATD        ANDLT     OLD_IKMATD
     C     @@AMT         OREQ      *ZEROS
     C     DDACTN        ANDEQ     'A'
     C     DDTYPE        ANDEQ     'IT'
     C     IKMATD        ANDLT     OLD_IKMATD
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0691'     WMsgID1
     C                   ENDIF
     C                   ENDIF
      *
      **  If the amount is valid, set up the numeric amount for output
     C     DDCcyOK       IFNE      'N'
     C     ErrorFound    ANDNE     'Y'
     C                   Z-ADD     @@AMT         IKPENA
     C                   MOVE      @@ALPH        DDPENA
     C                   ENDIF
     C                   ENDIF
 
      *
      **  The amount must not be blank: Warning - Deposit is to be closed
      **  and no penalty is charged to the customer
     C     DDPENA        IFEQ      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDTYPE        ANDEQ     'TD'
     C     IKMATD        ANDLT     OLD_IKMATD
     C     ErrorFound    ANDNE     'Y'
     C     DDPENA        OREQ      *BLANKS
     C     DDACTN        ANDEQ     'A'
     C     DDTYPE        ANDEQ     'IT'
     C     IKMATD        ANDLT     OLD_IKMATD
     C     ErrorFound    ANDNE     'Y'
     C     DDPENA        OREQ      *BLANKS                                                  AR704846
     C     DDACTN        ANDEQ     'A'                                                      AR704846
     C     DDTYPE        ANDEQ     'IP'                                                     AR704846
     C     IKMATD        ANDLT     OLD_IKMATD                                               AR704846
     C     ErrorFound    ANDNE     'Y'                                                      AR704846
     C     DDPENA        OREQ      *BLANKS                                                  AR704846
     C     DDACTN        ANDEQ     'A'                                                      AR704846
     C     DDTYPE        ANDEQ     'TI'                                                     AR704846
     C     IKMATD        ANDLT     OLD_IKMATD                                               AR704846
     C     ErrorFound    ANDNE     'Y'                                                      AR704846
      *                                                                                     AR704846
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0691'     WMsgID1
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
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
     C                   PARM                    WMsgid1
     C                   PARM                    DDACTN
     C                   PARM                    DDPENA
     C                   PARM                    DDCcyOK
     C                   PARM                    A6NBDP
     C                   PARM                    DDTYPE
     C                   PARM                    IKPENA
     C                   PARM                    IKMATD
     C                   PARM                    OLD_IKMATD
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    RespMode
     C                   PARM                    BGN4ST
 
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
**  CCPY@
(c) Finastra International Limited 2001
