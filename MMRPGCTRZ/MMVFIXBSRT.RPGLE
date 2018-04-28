     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Fix Base Rate')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBSRTVLD - Validate Fix Base Rate                          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Fix Base Rate indicator and confirms whether it   *
      *             has a valid value.                                *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD020624A          Date 12Dec13               *
      *  Prev Amend No. AR1082657          Date 30Jan13               *
      *                 263678             Date 05Feb10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12810           Date 04Dec06               *
      *                 241873             Date 29Aug06               *
      *                 BUG10938 (Reopen)  Date 31Mar06               *
      *                 BUG10938           Date 21Mar06               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 26Apr05               *
      *                 BUG5812            Date 30Mar05               *
      *                 CDL019  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020624A - Prevent MMM0799 warning message from showing     *
      *              when user inserts a TD Deal.                     *
      *            - Applied for MD23981.                             *
      *  AR1082657 - Event Code not found" warning message appeared   *
      *              on LDNI screen while doing rollovers             *
      *  263678 - Incorrect defaulting of fixed based rate resulting  *
      *           to wrong interest calculation Apply fixes 262094,   *
      *           263046, 248850. Fix Base Rate is not defaulting     *
      *           properly in LDNI. Reverse 241873 and reinstated that*
      *           DDFBRT is blank before defaulting. Show warning     *
      *           message when Fix Base Rate is different from Deal   *
      *           type/sub type default setting. Include deal type,   *
      *           maturity date, and base rate code validation to get *
      *           the default value of the Fix Base Rate.             *
      *  BUG12810 - Validate Fix Base Rate only for deal types IT,    *
      *             TD, IP and TI only.                               *
      *  241873 - Assume that Fix Base Rate is 'N' when blanks if     *
      *           Deal Type is Fixed Deposit/Loan                     *
      *  BUG10938 (Reopen) - Change Base Rate Flag check from *Blank  *
      *                      to 'N' or 'Y'. BUG10769 defaults a value *
      *                      of 'N' to the Base Rate Flag in the Deal *
      *                      Type/sub-type record maintenance, if it  *
      *                      is *blank.                               *
      *  BUG10938 - Check Deal Type before defaulting Base Rate Flag  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CDs Issued. Defaulting of Fixed Base  *
      *           Rate should be for fixed deposit or internal funding*
      *           deals only.                                         *
      *  BUG5812- Don't default if this would cause an error          *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *                                                               *
      *****************************************************************
 
     FFDDTSTL1  IF   E           K DISK
      ** Midas FD Deal type/subtype file
 
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
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Fix Base Rate indicator received as a parameter
     D DDFBRT          S              1A
 
      ** Deal Type received as a parameter
     D DDTYPE          S              2A
 
      ** Deal Subtype received as a parameter
     D DDSTYP          S              2A
 
      ** Deal Class received as a parameter                                                   CDL038
     D DDCLAS          S              4A                                                      CDL038
                                                                                              CDL038
      ** Base rate code received as a parameter
     D DDBSRC          S              2A
 
      ** Maturity date received as a parameter
     D IKMATD          S              5  0
                                                                                             BUG5812
      ** Flag to check whether defaulting causes an error                                    BUG5812
     D Defaulted       S              1A                                                     BUG5812
                                                                                              241873
      ** For backing up the original Fixed Base Rate Code                                     241873
     D DDFBRTBK        S                   Like(DDFBRT)                                       241873
 
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Defaulted                                   BUG5812
 
      *                                                                                       263678
      ** Do not default fix base rate immediately to 'N'.  Check                              263678
      ** FDDTSTL1 first.                                                                      263678
      *                                                                                       263678
     C**********         If        DDTYPE = 'IP'  or                                   241873 263678
     C**********                   DDTYPE = 'IT'  or                                   241873 263678
     C**********                   DDTYPE = 'TD'  or                                   241873 263678
     C**********                   DDTYPE = 'TI'  or                                   241873 263678
     C**********                   DDTYPE = 'ID'  or                                   241873 263678
     C**********                   DDTYPE = 'IL'  or                                   241873 263678
     C**********                   DDTYPE = 'CI'  or                                   241873 263678
     C**********                   DDTYPE = 'CF'                                       241873 263678
     C**********         If        DDFBRT = *BLANKS                                    241873 263678
     C**********         Eval      DDFBRT   = 'N'                                      241873 263678
     C**********         EndIf                                                         241873 263678
     C**********         EndIf                                                         241873 263678
      **********                                                                       241873 263678
      ** Fix Base Rate is only valid for Fixed Deposit and
      ** Internal Funding Deals.
     C*****DDFBRT        IFNE      *BLANKS                                                  BUG10938
     C     DDFBRT        IFEQ      'Y'                                                      BUG10938
     C     DDTYPE        ANDNE     'IP'
     C     DDTYPE        ANDNE     'IT'
     C     DDTYPE        ANDNE     'TD'
     C     DDTYPE        ANDNE     'TI'
     C     DDTYPE        ANDNE     'ID'
     C     DDTYPE        ANDNE     'IL'
     C     DDTYPE        ANDNE     'CI'                                                       CDL033
     C     DDTYPE        ANDNE     'CF'                                                       CDL033
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0346'     Msgid1
     C                   GOTO      ERROR
     C                   ENDIF
 
      ** Default value from Deal type/subtype table
     C*****DDBSRC        IFNE      *BLANKS                                                    263678
     C*****DDFBRT        ANDEQ     *BLANKS                                                    263678
      *                                                                                       263678
     C     DDTYPE        IFEQ      'IP'                                                       263678
     C     DDTYPE        OREQ      'IT'                                                       263678
     C     DDTYPE        OREQ      'TD'                                                       263678
     C     DDTYPE        OREQ      'TI'                                                       263678
     C     DDTYPE        OREQ      'ID'                                                       263678
     C     DDTYPE        OREQ      'IL'                                                       263678
     C     DDTYPE        OREQ      'CI'                                                       263678
     C     DDTYPE        OREQ      'CF'                                                       263678
      *                                                                                     BUG10938
      ***Fix*Base*Rate*is*only*valid*for*Fixed*Deposit*and**Internal*Funding*Deals.BUG10938 BUG10938
     C*****DDTYPE        IFEQ      'IP'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'IT'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'TD'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'TI'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'ID'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'IL'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'CI'                                            BUG10938 BUG10938
     C*****DDTYPE        OREQ      'CF'                                            BUG10938 BUG10938
      *                                                                                     BUG10938
     C     KLDTST        CHAIN     FDDTSTL1
      *                                                                                      BUG5812
      * Set Flag to check whether the default value is valid                                 BUG5812
     C                   If        %Found                                                    BUG5812
     C                   MOVE      FDFBRT        WFBRT             1                          263678
      *                                                                                       263678
     C     DDFBRT        IFEQ      *BLANKS                                                    263678
     C                   MOVE      'Y'           Defaulted                                   BUG5812
     C                   MOVE      FDFBRT        DDFBRT
     C**********         EndIf                                                        BUG5812 263678
     C**********         ENDIF                                                     BUG10938 BUG10938
      *                                                                                       263678
      ** If still blank then default to 'N'                                                   263678
      *                                                                                       263678
     C     DDFBRT        IFEQ      *BLANKS                                                    263678
     C                   MOVE      'N'           DDFBRT                                       263678
     C                   ENDIF                                                                263678
     C                   ENDIF                                                                263678
     C     WFBRT         IFEQ      *BLANKS                                                 MD020624A
     C                   MOVE      'N'           WFBRT                                     MD020624A
     C                   ENDIF                                                             MD020624A
      *                                                                                       263678
      ** User override the default value of DDFBRT                                            263678
     C                   IF        DDFBRT <> WFBRT                                            263678
     C**********         MOVEL     'MMM0799'     Msgid1                             263678 AR1082657
     C                   MOVEL     '5045889'     Msgid1                                    AR1082657
     C                   EVAL      RetCodeIn = 'Warning'                                      263678
     C                   ENDIF                                                                263678
     C                   ENDIF                                                                263678
     C                   ENDIF
 
      ***Fix*Base*Rate*must*be*'Y'*or*'N'*or*blanks********************                     BUG10938
      ** Fix Base Rate must be 'Y' or 'N'                                                   BUG10938
     C                   IF        (DDTYPE = 'IT') OR                                       BUG12810
     C                             (DDTYPE = 'TD') OR                                       BUG12810
     C                             (DDTYPE = 'IP') OR                                       BUG12810
     C                             (DDTYPE = 'TI')                                          BUG12810
     C     DDFBRT        IFNE      'N'
     C     DDFBRT        ANDNE     'Y'
     C*****DDFBRT        ANDNE     *BLANKS                                                  BUG10938
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0327'     Msgid1
     C                   ELSE
 
      ***If*Base*Rate*or*Maturity*Date*not*entered,********************                     BUG10938
      ***Fix*Base*Rate*must*be*blanks.***                                                   BUG10938
     C*****DDBSRC        IFEQ      *BLANKS                                                  BUG10938
     C*****DDFBRT        ANDNE     *BLANKS                                                  BUG10938
     C*****IKMATD        OREQ      0                                                        BUG10938
     C*****DDFBRT        ANDNE     *BLANKS                                                  BUG10938
     C**********         EVAL      ErrorFound = 'Y'                                         BUG10938
     C**********         MOVEL     'MMM0333'     Msgid1                                     BUG10938
     C**********         ELSE                                                               BUG10938
 
      ** If Base Rate and Maturity Date entered,
      ** Fix Base Rate must be 'Y' or 'N'.
     C     DDBSRC        IFNE      *BLANKS
     C     IKMATD        ANDNE     0
     C     DDFBRT        ANDEQ     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0334'     Msgid1
     C                   ENDIF
 
     C**********         ENDIF                                                              BUG10938
 
     C                   ENDIF
     C                   ENDIF                                                              BUG12810
 
      ** If an error was found, set the return code appropriately
     C     ERROR         TAG
     C                   IF        ErrorFound = 'Y'
     C                   If        Defaulted = 'Y' and                                       BUG5812
     C                             MsgId1 <> 'MMM0327'                                       BUG5812
     C                   Eval      MsgId1 = *Blank                                           BUG5812
     C                   Eval      DDFBRT = ' '                                              BUG5812
     C                   Else                                                                BUG5812
     C                   EVAL      RetCodeIn = 'Error'
     C                   EndIf                                                               BUG5812
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
     C                   PARM                    DDFBRT
     C                   PARM                    DDTYPE
     C                   PARM                    DDSTYP
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDBSRC
     C                   PARM                    IKMATD
 
      ** Key List for Loan Type/Subtype and Deal Type/Subtype
 
     C     KLDTST        KLIST
     C                   KFLD                    DDTYPE
     C                   KFLD                    DDSTYP
     C                   KFLD                    DDCLAS                                       CDL038
 
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
(c) Misys International Banking Systems Ltd. 2004
