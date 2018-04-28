     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate interest calc method (IRS)')
      *****************************************************************
      *                                                               *
      *  Midas - Validate Interest Calculation Method                 *
      *                                                               *
      *  IRVIRSINTC
      *                                                               *
      *  Function:  This module checks the validity of the interest   *
      *             calculation basis. If an error is found the       *
      *             return code = 'error', else it is blank.          *
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
      *  Last Amend No. CIR013             Date 21Apr05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CIR004             Date 20Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *           Allow method 9 - actual/365, 366 for Feb 29 period. *
      *  CIR004 - Dealing Calculation Method Change                   *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
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
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR004
      ** External DS for SAR Details                                                          CIR004
                                                                                              CIR004
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR004
      ** First DS for Access Programs, Short Data Structure                                   CIR004
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * interest calc basis
     D STICBS          S              1A
      * their interest payment frequency
     D STIPFR          S              1A
      * interst rate calendars. For DL1604I this should be passed to module as'N'
     D CIR001          S              1A
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
                                                                                              CIR013
     D CIR013          S              1A                                                      CIR013
 
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
      **
      ** Validate Interest Calculation Method.
      **
      ** If a cash-flow schedule has been specified and the calculation
      **   basis has not been entered, default it to '1'.
      *
     C     CIR001        IFEQ      'Y'
     C     STIPFR        ANDEQ     'C'
     C     STICBS        ANDEQ     ' '
     C                   MOVEL     '1'           STICBS
     C                   END
      *
      *COPY WNCPYSRC,DL1602IC13
      *
     C*****STICBS        IFLT      '1'                                                        CIR013
     C*****STICBS        ORGT      '6'                                                        CIR013
     C*****CIR004        ANDEQ     'N'                                                 CIR004 CIR013
     C*****STICBS        ORGT      '7'                                                 CIR004 CIR013
     C*****CIR004        ANDEQ     'Y'                                                 CIR004 CIR013
      *
      *COPY WNCPYSRC,DL1602IC14
                                                                                              CIR013
      **  Calculation method may be 1 - 6, or 7 if CIR004 is on, or 9 if                      CIR013
      **  CIR013 is on.                                                                       CIR013
     C                   IF        (STICBS >= '1' and STICBS <= '6') or                       CIR013
     C                             (STICBS = '7' and CIR004 = 'Y') or                         CIR013
     C                             (STICBS = '9' and CIR013 = 'Y')                            CIR013
     C                   ELSE                                                                 CIR013
      *
     C     CIR004        IFEQ      'Y'                                                        CIR004
     C                   If        CIR013 = 'N'                                               CIR013
     C*****              MOVE      'MMM0429'     MsgId1                                CIR004 CIR013
     C                   Eval      MsgID1 = 'MMM4003'                                         CIR013
     C                   Else                                                                 CIR013
     C                   Eval      MsgID1 = 'MMM4005'                                         CIR013
     C                   Endif                                                                CIR013
                                                                                              CIR013
     C                   ELSE                                                                 CIR004
     C                   If        CIR013 = 'N'                                               CIR013
     C                   MOVE      'MMM0428'     Msgid1
     C                   Else                                                                 CIR013
     C                   Eval      MsgID1 = 'MMM4004'                                         CIR013
     C                   Endif                                                                CIR013
     C                   ENDIF                                                                CIR004
                                                                                              CIR013
     C                   MOVE      'Y'           ErrorFound
     C                   END
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
     C                   PARM                    CIR001
     C                   PARM                    STIPFR
     C                   PARM                    STICBS
 
      ** Access Switchable Features File                                                      CIR004
                                                                                              CIR004
     C                   CallB     'AOSARDR0'                                                 CIR004
     C                   Parm      *Blanks       PRtcd             7                          CIR004
     C                   Parm      '*VERIFY '    POptn             7                          CIR004
     C                   Parm      'CIR004'      PSard             6                          CIR004
     C     SCSARD        Parm      SCSARD        Dsfdy                                        CIR004
                                                                                              CIR004
     C                   Move      'N'           CIR004            1                          CIR004
     C                   If        PRtcd = *Blanks                                            CIR004
     C                   Eval      CIR004 = 'Y'                                               CIR004
     C                   Endif                                                                CIR004
                                                                                              CIR013
     C                   CallB     'AOSARDR0'                                                 CIR013
     C                   Parm      *Blanks       PRtcd                                        CIR013
     C                   Parm      '*VERIFY '    POptn                                        CIR013
     C                   Parm      'CIR013'      PSard                                        CIR013
     C     SCSARD        Parm      SCSARD        Dsfdy                                        CIR013
                                                                                              CIR013
     C                   Eval      CIR013 = 'N'                                               CIR013
     C                   If        PRtcd = *Blanks                                            CIR013
     C                   Eval      CIR013 = 'Y'                                               CIR013
     C                   Endif                                                                CIR013
                                                                                              CIR004
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
