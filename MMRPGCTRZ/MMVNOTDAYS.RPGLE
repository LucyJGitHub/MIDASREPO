     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate notice days')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNOTDAYS - Validate Notice Days                            *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             notice days and confirms whether it has a valid   *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. 162955             Date 07Jul00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  162955   The problem is the notice days are not set          *
      *           to -999 when the maturity date is input on a call   *
      *           deal.  Fix is to set notice days to -999 when the   *
      *           maturity date is input on a call deal.              *
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
 
      ** Notice Days is received as a parameter
     D DDNTCE          S              3A
 
      ** Maturity Date received as a parameter
     D DDMDAT          S              6A
 
      ** Deal Type Passed as a parameter
     D DDTYPE          S              2A
 
     ** Notice days (numeric field needed for 'Total Interest' validation)
     D NotDayNum       S              3S 0
 
 
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
      *
     D @RTCDE          S              1A
 
      ** Amount calculation field
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
     C** Notice Days Validation
     C** 1) Notice Days must be blank if deal type not CL, DL or CD.
     C**
     C** 2) If notice days are not entered for CL, DL or CD type
     C**    deals then maturity date must have been entered
     C**
     C*
     C**  If the deal type is CL,DL or CD.
     C     DDTYPE        IFEQ      'CL'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C*
     C**  If the notice days have not been input, it is invalid unless
     C**  the maturity date has been input.
     C     DDNTCE        IFEQ      *BLANKS
     C     DDMDAT        ANDEQ     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C     DDTYPE        IFEQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM9016'     Msgid1                         CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0137'     Msgid1
     C                   ENDIF                                                  CDL006
     C                   END
     C*
     C**  If the notice days are not zero...
     C     DDNTCE        IFNE      '  0'
     C     DDNTCE        ANDNE     ' 0 '
     C     DDNTCE        ANDNE     '0  '
     C     DDNTCE        ANDNE     '00 '
     C     DDNTCE        ANDNE     ' 00'
     C     DDNTCE        ANDNE     '000'
     C     DDNTCE        ANDNE     *BLANKS
     C*
     C**  Check if the notice days are numeric.
     C                   MOVE      *BLANKS       @@ALPH
     C                   Z-ADD     0             @@IDP
     C                   Z-ADD     3             @@IINT
     C                   MOVE      DDNTCE        @@ALPH
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
     C**  If the notice days are non-numeric this is invalid.
     C     @@ERCD        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0139'     Msgid1
     C                   ELSE
     C                   MOVE      @@ALPH        DDNTCE
     C                   Z-ADD     @@AMT         NotDayNum
     C                   END
     C*
     C**  If the notice days are zero, set up the screen fields.
     C                   ELSE
     C     DDNTCE        IFNE      *BLANKS
     C                   MOVE      '  0'         DDNTCE
     C                   Z-ADD     0             NotDayNum
     C                   END
     C                   END
     C*
     C**  If the Maturity Date has been set for a call deal, in all             162955
     C**  cases set the notice days to -999.                                    162955
     C                   If        DDMDAT <>  *BLANKS                           162955
     C                   Eval      NotDayNum = -999                             162955
     C                   End                                                    162955
     C**                                                                        162955
     C**  Otherwise, if the deal type is not CD,CL or DL....
     C                   ELSE
     C*
     C**  If the notice days have been entered, this is invalid.
     C     DDNTCE        IFNE      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0138'     Msgid1
     C                   ELSE
     C*
     C**  Set the notice days to -999.
     C                   Z-SUB     999           NotDayNum
     C*
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
     C                   PARM                    DDNTCE
     C                   PARM                    DDMDAT
     C                   PARM                    DDTYPE
     C                   PARM                    NotDayNum
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
(c) Finastra International Limited 2001
