     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate deal amount')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVAMOUNT  - Validate The Deal Amount                        *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             the deal amount and confirms whether it is a valid*
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
      *  Prev Amend No. AR569568           Date 22Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8236            Date 06Sep05               *
      *                 BUG5026            Date 01Dec04               *
      *                 BUG1004            Date 22Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *  Prev Amend No. CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR569568 - CDL006 is not being passed causing zero amount to *
      *             be valid in Insert.  But in amendment, it will    *
      *             issue an error message MMM0372.(Child: AR569569)  *
      *  BUG8236 - Negotiable Assets Purchased field validations      *
      *            and Contingent Delivery amount and Expiry time     *
      *            error message validation in Options                *
      *  BUG5026- Allow entry of 13 digits on Principal Amount.       *
      *  BUG1004- Setup validation of amount field even error with    *
      *           currency.                                           *
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
 
      ** Deal Amount is received as a parameter
     D DDAMNP          S             14A
 
      ** Status of currency after validation received as a parameter
     D DDCcyOK         S              1A
 
      ** Number of decimal places for currency received as a parameter
     D A6NBDP          S              1S 0
 
      ** Amount passed to ZA0840 as a parameter
     D @@AMT           S             15  0
 
      ** Deal Type Received as a parameter
     D DDTYPE          S              2A
 
      ** Deal File Deal Amount output as a parameter
     D IKAMNP          S             15  0
 
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
 
      ** Decimal separator
     D BNDCSP          S              1A
                                                                                CDL006
     D*CDL006***       S              1A   IMPORT                                    CDL006 AR569568
     D CDL006          S              1A                                                    AR569568
 
     D*@@NUM****       S             14  0                                          BUG8236 AR569568
     D DDACTN          S              1A                                                    AR569568
                                                                                             BUG8236
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
     C*
     C** Deal Amount Validation:
     C** Error if blank
     C*
     C**********         MOVE      DDAMNP        @@NUM                              BUG8236 AR569568
      *****************************************************************             BUG8236 AR569568
     C     DDAMNP        IFEQ      *BLANKS
     C*****@@NUM         OREQ      *ZERO                                            BUG8236 AR569568
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0143'     Msgid1
     C*
     C**  Verify that the amount entered is valid numeric.
     C                   ELSE
     C***If*there*was*no*error*found*in*the*currency*validation                             BUG1004
     C*  Validate Amount even currency in error and use 2 decimal places                    BUG1004
     C*****DDCcyOK       IFNE      'N'                                                      BUG1004
     C     DDCcyOK       IFEQ      'N'                                                      BUG1004
     C                   Z-ADD     2             A6NBDP                                     BUG1004
     C                   END                                                                BUG1004
     C                   Z-ADD     A6NBDP        @@IDP
     C*****12***         SUB       A6NBDP        @@IINT                                      BUG5026
     C     13            SUB       A6NBDP        @@IINT                                      BUG5026
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDAMNP        @@ALPH
     C                   MOVE      'Y'           @@MTID
     C*
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
     C*
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0144'     Msgid1
     C                   ELSE
     C*
     C**  The amount must not be zero.
     C     @@AMT         IFEQ      *ZEROS
     C     DDTYPE        ANDNE     'CD'
     C     CDL006        ANDEQ     'N'                                          CDL006
     C     DDACTN        ANDEQ     'I'                                                      AR569568
     C     @@AMT         OREQ      *ZEROS                                                   AR569568
     C     DDTYPE        ANDNE     'CL'                                                     AR569568
     C     CDL006        ANDEQ     'N'                                                      AR569568
     C     DDACTN        ANDEQ     'I'                                                      AR569568
     C     @@AMT         OREQ      *ZEROS                                       CDL006
     C     DDTYPE        ANDNE     'CD'                                         CDL006
     C     DDTYPE        ANDNE     'DT'                                         CDL006
     C     DDTYPE        ANDNE     'LT'                                         CDL006
     C     DDTYPE        ANDNE     'CL'                                                     AR569568
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDACTN        ANDEQ     'I'                                                      AR569568
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0143'     Msgid1
     C                   END
     C                   END
     C****               END                                                                BUG1004
     C                   END
     C*
     C                   Z-ADD     *zeros        IKAMNP
     C**  If the amount is valid, set up the numeric amount for output
 
     C     DDCcyOK       IFNE      'N'
     C     ErrorFound    ANDNE     'Y'
     C                   Z-ADD     @@AMT         IKAMNP
     C                   MOVE      @@ALPH        DDAMNP
     C                   END
     C*
     C** If an error was found, set the return code appropriately
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
     C                   PARM                    DDAMNP
     C                   PARM                    DDCcyOK
     C                   PARM                    A6NBDP
     C                   PARM                    DDTYPE
     C                   PARM                    IKAMNP
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    DDACTN                                     AR569568
     C                   PARM                    CDL006                                     AR569568
 
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
