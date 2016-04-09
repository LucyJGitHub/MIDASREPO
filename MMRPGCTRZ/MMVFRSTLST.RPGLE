     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate First/Last day interest')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVFRONTUP - Validate First/Last day Interest                *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             First/Last day interest field and confirms        *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  Note: Reference is made to DDFLID in the validation of       *
      *        DDTOTI                                                 *
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
      *  Last Amend No. CDL013             Date 09Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *  Prev Amend No. CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 17Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** First/Last Day Interest indicator - received as a parameter
     D DDFLID          S              1A
 
      ** F/L Day Ind. from Deal S.types file - received as a parameter
     D ASFLID          S              1A
 
      ** Deal Type received as a parameter
     D DDTYPE          S              2A
 
      ** Tax Indicator - received as a parameter
     D DDMTAX          S              1A
 
      ** Interest Payment Frequency - received as a parameter
     D DDIPFQ          S              2A
 
      ** Next interest Payment Date - received as a parameter
     D DDNDAT          S              6A
 
      ** Valid Deal Types for Front Up Interest
     D TABTFU          S              2    DIM(4) CTDATA PERRCD(4)
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
      *Withholding tax Flag received as a parameter                                          CDL013
     D CDL013          S              1A                                                     CDL013
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      *  *----------------------------------------------*
      *  * Validate First & Last Day Interest Indicator *
      *  *----------------------------------------------*
      *
      * Default
     C     DDFLID        IFEQ      ' '
     C                   MOVE      'N'           DDFLID
     C                   END
      *
      **  If the First & Last Day Ind does not have the value 'Y','N'
      **  it is an error.
      *
     C     DDFLID        IFNE      'Y'
     C     DDFLID        ANDNE     'N'
     C                   MOVEL     'MMM0606'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *
      **  If the First & Last Day Ind from the Deal Sub-Types file is 'N'
      **  that input must be 'N'
      *
     C     ASFLID        IFEQ      'N'
     C     DDFLID        ANDNE     'N'
     C                   MOVEL     'MMM0607'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
      *
      ** If the First & Last Day Ind is 'Y' Check the following:
      **  the Deal Type is IT, IP, TD or TI
      **  the Tax Indicator is not 'Y'
      **  the Interest Payment Frequency is blank
      **  the Next interest Payment Date is blank
      *
     C     DDFLID        IFEQ      'Y'
     C     DDTYPE        LOOKUP    TABTFU                                 99
                                                                                CDL006
      ** If not found on the table, check if FL or FT.                          CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     *IN99         ANDEQ     '0'                                          CDL006
     C     DDTYPE        ANDEQ     'FL'                                         CDL006
     C     CDL006        OREQ      'Y'                                          CDL006
     C     *IN99         ANDEQ     '0'                                          CDL006
     C     DDTYPE        ANDEQ     'FT'                                         CDL006
     C                   Eval      *IN99 = *ON                                  CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C     *IN99         IFEQ      '0'
     C     DDMTAX        OREQ      'Y'
     C     CDL013        OREQ      'Y'                                                       CDL013
     C     DDMTAX        ANDNE     '0'                                                       CDL013
     C     DDIPFQ        ORNE      *BLANK
     C     DDNDAT        ORNE      *BLANK
     C                   MOVEL     'MMM0608'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   END
      *
      *
      ** If an error was found, set the return code appropriately
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDFLID
     C                   PARM                    ASFLID
     C                   PARM                    DDTYPE
     C                   PARM                    DDMTAX
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    CDL013                                      CDL013
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TABTFU
ITIPTDTI
