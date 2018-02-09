     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate int calculation method (FRA)')
      *****************************************************************
      *                                                               *
      *  Midas - Validate Interest Calculation Method                 *
      *                                                               *
      *  IRVFRAINTC
      *                                                               *
      *  Function:  This module returns a blank indicator if the      *
      *             validate interest calculation method is correct;  *
      *             else there is an error.                           *
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
      *  Prev Amend No. CIR013             Date 20Apr05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR004             Date 20Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
                                                                                              CIR004
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
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
 
      * Settlement Formula
     D SSETF           S              1A
 
      * Interest calculation basis
     D SUICBS          S              1A
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
 
      ** Validate Interest Calculation Method.
      **
      **  Checking valid settlement formula's, (G,A & U).
      **  Blank is not a valid entry for sett. formula but should
      **  not be excluded because BLANK sett. formula will default
      **  to G later when validation for sett. formula is carried out.
 
     C     SSETF         IFEQ      'A'
     C     SSETF         OREQ      'U'
     C     SSETF         OREQ      'G'
     C     SSETF         OREQ      *BLANKS
 
      *** If the Settlement Formula to be used is the standard one
      *** ('G') then Calculation Method must be input; else Settlement
      *** Formula is 'A' for Australian or 'U' for USA and Calculation
      *** Method is not necessary.
 
     C     SSETF         IFEQ      'G'
     C     SSETF         OREQ      *BLANKS
 
     C*****SUICBS        IFLT      '1'                                                        CIR013
     C*****SUICBS        ORGT      '6'                                                        CIR013
     C*****CIR004        ANDEQ     'N'                                                 CIR004 CIR013
     C*****SUICBS        ORGT      '7'                                                 CIR004 CIR013
     C*****CIR004        ANDEQ     'Y'                                                 CIR004 CIR013
                                                                                              CIR013
      **  Calculation method may be 1 - 6, or 7 if CIR004 is on, or 9 if                      CIR013
      **  CIR013 is on.                                                                       CIR013
     C                   IF        (SUICBS >= '1' and SUICBS <= '6') or                       CIR013
     C                             (SUICBS = '7' and CIR004 = 'Y') or                         CIR013
     C                             (SUICBS = '9' and CIR013 = 'Y')                            CIR013
     C                   ELSE                                                                 CIR013
      *                                                                                       CIR004
     C     CIR004        IFEQ      'Y'                                                        CIR004
     C                   If        CIR013 = 'N'                                               CIR013
     C*****              MOVE      'MMM0429'     MsgID1                                CIR004 CIR013
     C                   Eval      MsgID1 = 'MMM4003'                                         CIR013
     C                   Else                                                                 CIR013
     C                   Eval      MsgID1 = 'MMM4005'                                         CIR013
     C                   Endif                                                                CIR013
                                                                                              CIR013
     C                   ELSE                                                                 CIR004
     C                   If        CIR013 = 'N'                                               CIR013
     C                   MOVE      'MMM0428'     MsgID1
     C                   Else                                                                 CIR013
     C                   Eval      MsgID1 = 'MMM4004'                                         CIR013
     C                   Endif                                                                CIR013
     C                   ENDIF                                                                CIR004
                                                                                              CIR013
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *
     C                   ELSE
 
      *** else Settlement Formula is 'A' for Australian or 'U' for USA
      *** and Calculation Method is not necessary.
 
     C     SUICBS        IFNE      *BLANKS
     C                   MOVE      'MMA0003'     MsgID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
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
     C                   PARM                    SSETF
     C                   PARM                    SUICBS
 
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
                                                                                              CIR013
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
(c) Finastra International Limited 2001
