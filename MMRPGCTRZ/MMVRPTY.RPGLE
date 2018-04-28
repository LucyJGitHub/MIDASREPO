     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate repo transaction type')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVRPTY   - MM Validate Repo Transaction type/Deal Type      *
      *                                                               *
      *  Function: This Program cross validates Repo Transaction Type *
      *            with Deal type.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 7JUne99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
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
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
      ** External data structure for Securities Static Data
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** External data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   MOVEL     *BLANKS       SvDDCUST          1
      *
      ** If Customer has been entered as '?' make it blank for the
      ** purposes of this module.
      *
     C                   IF        DDCUST = '?'
     C                   MOVEL     '?'           SvDDCUST
     C                   MOVEL     *BLANKS       DDCUST
     C                   ENDIF
      *
      ** Transaction type must be entered and be 'RP', 'RR', 'PL', 'PD',
      ** 'BB' or 'BL'.
      *
     C                   IF        DDTRTP = *Blanks or DDTRTP <> 'RP' and
     C                             DDTRTP <> 'RR' and DDTRTP <> 'PL' and
     C                             DDTRTP <> 'PD' and DDTRTP <> 'BB' and
     C                             DDTRTP <> 'BL'
     C                   MOVE      'MMA0774'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
      *
     C                   ELSE
      *
      ** Deal type must be entered and be 'CD', 'CL', 'IT', 'IP', 'TD' or
      ** 'TI'.
      *
     C                   IF        DDTRTP = *Blanks or DDTYPE <> 'CD'
     C                             and DDTYPE <> 'CL' and DDTYPE <> 'IT'
     C                             and DDTYPE <> 'IP' and DDTYPE <> 'TD'
     C                             and DDTYPE <> 'TI'
     C                   MOVE      'MMA0775'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDTYPE = 'CD' or DDTYPE = 'IT' or
     C                             DDTYPE = 'TD'
     C                   IF        DDTRTP <> 'RP' and DDTRTP <> 'BL'
     C                             and DDTRTP <> 'PD'
     C                   MOVE      'MMA0776'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDTYPE = 'CL' or DDTYPE = 'IP' or
     C                             DDTYPE = 'TI'
     C                   IF        DDTRTP <> 'RR' and DDTRTP <> 'BB'
     C                             and DDTRTP <> 'PL'
     C                   MOVE      'MMA0776'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Customer details to obatin customer number
      *
     C                   MOVEL     DDCUST        @@KEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM                    @@KEY1           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C
     C                   IF        @@RTCD = *Blanks
     C*
     C** If customer record found it must be a security customer allowing
     C** pledge agreements.
     C*
     C                   MOVE      BBCUST        @CNUMA            6
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @CNUMA        @AENB             6
     C     SDSECS        PARM      SDSECS        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0522'     Msg4
     C                   ELSE
     C*
     C** If client record found Pledge Agreement ind must be 'Y'
     C*
     C     BFPLAG        IFNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0523'     Msg4
     C                   END
     C                   END
     C                   END
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
     C** Set IKDRID according to DDTRTP
     C
     C                   IF        DDTRTP = 'RP' or DDTRTP = 'RR'
     C                   MOVE      'R'           IKDRID
     C                   ENDIF
     C
     C                   IF        DDTRTP = 'BB' or DDTRTP = 'BL'
     C                   MOVE      'B'           IKDRID
     C                   ENDIF
     C
     C                   IF        DDTRTP = 'PD' or DDTRTP = 'PL'
     C                   MOVE      'P'           IKDRID
     C                   ENDIF
     C
     C                   ENDIF
      *
      ** If Customer was entered as '?', reinstate this value to DDCUST
      *
     C                   IF        SvDDCUST = '?'
     C                   MOVEL     '?'           DDCUST
     C                   ENDIF
      *
     C                   RETURN
     C********************************************************************
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
      * Receive Fee Settlement Method
     C                   PARM                    DDTYPE            2
     C                   PARM                    DDTRTP            2
     C                   PARM                    IKDRID            1
     C                   PARM                    DDCUST           10
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMVDLTPSTP'  DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
