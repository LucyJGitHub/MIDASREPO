     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate deal date')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVDLDATE  - Validate deal date                              *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             deal date and confirms whether it has a valid     *
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
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG3992            Date 05Oct04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG3992 - Do not suppress warning messages.                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
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
 
      ** External data structure for access programs (long)                                   CER043
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
 
      ** External data structure for SAR details                                              CER043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ZAVDATE         C                   CONST('ZAVDATE')
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 returned to caller
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Error message code 2 returned to caller
     D Msgid2          S                   LIKE(#MsgID)
 
      ** Werning message code 1 returned to caller
     D WMsgid1         S                   LIKE(#MsgID)
 
      ** Deals file version of the deal date to return
     D IKDDND          S                   LIKE(BJRDNB)
 
      ** Deal date is received as a parameter
     D DDDldt          S              6A
 
      ** Run date (day number) received as a parameter
     D BJRdnb          S              5  0
 
      ** Date format indicator received as a parameter
     D BJDfin          S              1A
 
     D @DAYNO          S              5  0
 
     D @VDYNO          S              5  0
 
     D @RTCDE          S              1A
 
      ** Holiday indicator
     D ZIND            S              1A
 
      ** Local currency code
     D BJLCCY          S              3A
 
      ** Local location code
     D A8LCCD          S              3A
 
      ** Switchable feature                                                                   CER043
     D CER043          S              1A                                                      CER043
                                                                                              CER043
      ** Return Code                                                                          CER043
     D PRtcd           S              7A                                                      CER043
                                                                                              CER043
     D ZDAYN           S              5P 0                                                    CER043
                                                                                              CER043
     D ZDATE           S              6P 6                                                    CER043
                                                                                              CER043
     D ZADATE          S              7A                                                      CER043
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
     C                   CLEAR                   Msgid1
     C                   CLEAR                   Msgid2
     C                   CLEAR                   WMsgid1
 
     C*                  MOVE      @DLDT         DDDLDT
 
     C**  The Deal Date must be entered.
 
     C     DDDLDT        IFEQ      *BLANKS
      *                                                                                       CER043
      **  Default deal date if switchable feature CER043 is on                                CER043
      *                                                                                       CER043
     C                   If        CER043 = 'Y'                                               CER043
     C                   CallB     'ZDATE2'                                                   CER043
     C                   Parm      BJRDNB        ZDAYN                                        CER043
     C                   Parm                    BJDFIN                                       CER043
     C                   Parm      *ZERO         ZDATE                                        CER043
     C                   Parm      *BLANK        ZADATE                                       CER043
     C                   Move      ZDATE         DDDLDT                                       CER043
     C                   Else                                                                 CER043
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0248'     Msgid1
     C                   EndIf                                                                CER043
     C*
     C**  Validate that the deal date is a valid date.
     C                   ELSE
     C                   RESET                   ReturnCode
     C                   CALLB     ZAVDATE
     C                   PARM                    ReturnCode
     C                   PARM                    DDDLDT
     C                   PARM                    BJDfin
     C                   PARM                    @DAYNO
     C*
     C**  If the return code indicates an error the input date is invalid or
     C**  non-numeric.
     C     ReturnCode    IFEQ      'Error'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0124'     Msgid1
     C*
     C**  If the date is valid, carry out further validation.
     C                   ELSE
     C*
     C**  The deal date must not be greater than the run date
     C     @DAYNO        IFGT      BJRDNB
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0249'     Msgid1
     C                   END
     C                   END
     C                   END
 
     C**  If no error then use Booking Branch
     C**  Location to verify that the Deal Date is not a holiday
     C**  in the local currency.
     C*****ErrorFound    IFNE      'Y'                                                       BUG3992
     C                   CALLB     'ZCHKH'
     C                   PARM                    @DAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    A8LCCD
     C                   PARM                    ZIND
     C*
     C**  If ZIND   = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM1038'     WMsgID1
     C                   END
     C**********         END                                                                 BUG3992
 
      ** Return the date
 
     C                   Z-ADD     @DAYNO        IKDDND
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
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
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    WMsgid1
     C                   PARM                    IKDDND
     C                   PARM                    DDDldt
     C                   PARM                    BJRdnb
     C                   PARM                    BJDfin
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
      ** Local currency (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Local location code (3A, from SDBRCHPD via caller)
     C                   PARM                    A8LCCD
 
      *                                                                                       CER043
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   Call      'AOSARDR0'                                                 CER043
     C                   Parm      *BLANKS       PRtcd                                        CER043
     C                   Parm      '*VERIFY'     POPTN             7                          CER043
     C                   Parm      'CER043'      PSARD             6                          CER043
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   If        PRtcd = *BLANKS                                            CER043
     C                   Eval      CER043 = 'Y'                                               CER043
     C                   Else                                                                 CER043
     C                   Eval      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   If        PRtcd <> '*NRF'                                            CER043
     C     *Lock         IN        LDA                                                        CER043
     C                   Eval      DBKEY = 'CER043'                                           CER043
     C                   Eval      DBFILE = 'SCSARDPD'                                        CER043
     C                   Eval      DBASE = 001                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   Exsr      *PSSR                                                      CER043
     C                   EndIf                                                                CER043
                                                                                              CER043
     C                   EndIf                                                                CER043
                                                                                              CER043
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
