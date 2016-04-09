     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate Brokerage for FRA/IRS')
      *****************************************************************
      *                                                               *
      *  Midas - Forward Rate Agreements Dealing Module               *
      *                                                               *
      *  ZABROKAGE  - Validate Brokerage amount                       *
      *                                                               *
      *  Function:  This module receives a parameter containing
      *             the broker code indicator and HON,                *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003             Date 03Aug98               *
      *                 CAP002   *CREATE   Date 01Dec97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** RECORD FORMATS FOR ACCESS TO CURRENCY DETAILS
     D*
      ** Dummy data structures used by access programs
      ** (DSSDY only used if file records over 150 chars long)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
      *  record formats for access to broker codes
     D*SDBROK        E DS                  EXTNAME(DSSDBROKPD)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Broker Currency Code Field in data structure SDBROK
     D A9BRCY          S              3A
 
      * zalign code validity check passed as parameter
     D ZALIGNok        S              1A
 
      * brokerage code validity check passed as parameter
     D SBRKCok         S              1A
 
      * brokerage code passed as parameter
     D SBRKC           S              4A
 
      * brokerage amount passed as parameter
     D SBAGE           S             14A
 
      *  Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      *  Error message code 2 received as a parameter
     D Msgid2          S                   LIKE(#MsgID)
 
      *  A 16 character alphanumeric field to contain numeric input
      *  The field may contain leading and trailing blanks and a
      *  decimal point,and may have up to 15 digits.
     D*ZFIELD**********S             16A                                        CAP003
     D @@ALPH          S             16A                                        CAP003
 
      *  contains the required number of digits before the decimal
      *  point as a constant.
     D*ZADEC***********S              1P 0                                      CAP003
     D @@IDP           S              3  0                                      CAP003
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D*ZADIG***********S              2P 0                                      CAP003
     D @@IINT          S              3  0                                      CAP003
                                                                                CAP003
      ** Million/Thousand Indicator                                             CAP003
     D @@MTID          S              1A                                        CAP003
                                                                                CAP003
      ** Error return code                                                      CAP003
     D @@ERCD          S              1  0                                      CAP003
                                                                                CAP003
      ** Amount after processing by ZA0840                                      CAP003
     D @@AMT           S             15  0                                      CAP003
                                                                                CAP003
      ** Decimal separator                                                      CAP003
     D     BNDCSP      S              1A                                        CAP003
                                                                                CAP003
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
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
      **
      ** If Broker Code is valid,check Brokerage amount.
      **
      *
     C     SBRKCok       IFEQ      'Y'
      *
      ** If Broker Code is TELX,PHON or MAIL,Brokerage amount
      ** must be blank.
     C                   Z-ADD     0             BAGEX
      *
     C     SBRKC         IFEQ      'TELX'
     C     SBRKC         OREQ      'PHON'
     C     SBRKC         OREQ      'MAIL'
     C     SBAGE         IFNE      *BLANKS
     C                   MOVEL     'MMM0194'     Msgid1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   ELSE
      ** or a valid Broker Code must have been entered. In this
      ** case Brokerage Amount must be 'NIL' or validated using
      ** Standard sub-routine ZALIGN.
     C     SBAGE         IFNE      'NIL'
     C     SBAGE         ANDNE     *BLANKS
      *
     C** Call Access Program for Currency Details
     C**      to Obtain Currency Decimal Places
     C                   CALLB     'AOCURRR0'
      * added declarations for rtcd and optn
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A9BRCY        @BKCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Chain should not fail,but allow for corrupt files.
     C*******            MOVE      *BLANKS       ZFIELD                         CAP003
     C*******            MOVEL     SBAGE         ZFIELD                         CAP003
     C*******            Z-ADD     A6NBDP        ZADEC                          CAP003
     C*****13            SUB       A6NBDP        ZADIG                          CAP003
     C*******            MOVE      'Y'           ZAOPT             1            CAP003
      *******                                                                   CAP003
     C*******            CALLB     'ZALIGN'                                     CAP003
     C*******            PARM                    ZALIGNok                       CAP003
     C*******            PARM                    ZFIELD                         CAP003
     C*******            PARM                    ZADEC                          CAP003
     C*******            PARM                    ZADIG                          CAP003
     C*****ZALIGNok      IFEQ      'Y'                                          CAP003
     C*******            MOVE      ZFIELD        BAGEX            13 0          CAP003
     C*******            END                                                    CAP003
     C*****ZALIGNok      IFEQ      'N'                                          CAP003
     C*****BAGEX         ORLE      0                                            CAP003
     C*******            Z-ADD     0             BAGEX                          CAP003
     C*******            MOVE      'Y'           ErrorFound                     CAP003
     C*******            MOVEL     'MMM0200'     Msgid2                         CAP003
     C*******            END                                                    CAP003
     C*******            END                                                    CAP003
     C*******            END                                                    CAP003
      *******                                                                   CAP003
     C*******            END                                                    CAP003
                                                                                CAP003
     C                   MOVE      *BLANKS       @@ALPH                         CAP003
     C                   MOVEL     SBAGE         @@ALPH                         CAP003
     C                   Z-ADD     A6NBDP        @@IDP                          CAP003
     C     13            SUB       A6NBDP        @@IINT                         CAP003
     C                   MOVE      'N'           @@MTID                         CAP003
                                                                                CAP003
     C                   CALLB     'ZA0840'                                     CAP003
     C                   PARM                    RetCodeOut                     CAP003
     C                   PARM                    @@ALPH                         CAP003
     C                   PARM                    @@IDP                          CAP003
     C                   PARM                    @@IINT                         CAP003
     C                   PARM                    @@MTID                         CAP003
     C                   PARM                    @@ERCD                         CAP003
     C                   PARM                    @@AMT                          CAP003
     C                   PARM                    BNDCSP                         CAP003
      *                                                                         CAP003
     C     @@ERCD        IFEQ      1                                            CAP003
     C                   MOVE      'Y'           ErrorFound                     CAP003
     C                   Z-ADD     0             BAGEX                          CAP003
     C                   MOVEL     'MMM0198'     Msgid1                         CAP003
     C                   END                                                    CAP003
     C     @@ERCD        IFEQ      2                                            CAP003
     C                   MOVE      'Y'           ErrorFound                     CAP003
     C                   Z-ADD     0             BAGEX                          CAP003
     C                   MOVEL     'MMM0200'     Msgid1                         CAP003
     C                   END                                                    CAP003
      *                                                                         CAP003
     C     ErrorFound    IFNE      'Y'                                          CAP003
     C                   Z-ADD     @@AMT         BAGEX            13 0          CAP003
     C                   MOVE      *BLANKS       SBAGE                          CAP003
     C                   MOVE      @@ALPH        SBAGE                          CAP003
     C                   END                                                    CAP003
                                                                                CAP003
     C                   END                                                    CAP003
     C                   END                                                    CAP003
      *                                                                         CAP003
     C                   END                                                    CAP003
      *
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    SBRKCok
     C                   PARM                    SBRKC
     C                   PARM                    SBAGE
     C                   PARM                    A9BRCY
     C                   PARM                    BAGEX
     C                   PARM                    BNDCSP                         CAP003
                                                                                CAP003
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
