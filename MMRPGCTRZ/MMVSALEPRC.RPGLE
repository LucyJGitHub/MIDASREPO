     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate sale price of NA sold')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVSALEPRC - Validate sale price of NA sold                  *
      *                                                               *
      *  Function:  This module takes a 15-alpha field and checks     *
      *             that it contains a legitimate sale price for a    *
      *             negotiable asset sold.                            *
      *                                                               *
      *  Component of: MMVALIDATE - Money Market validation service   *
      *                             program                           *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID 1 (10A, returned to caller)
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Deal file version of amount (15,0P, returned to caller)
     D ILAMNP          S             15P 0
 
      ** Sale price (15A, from transaction)
     D DDAMNP          S             15A
 
      ** Number of decimal places in currency (1,0S from SDCURRPD, via caller)
     D A6NBDP          S              1S 0
 
      ** Decimal separator character (1A from SDDEALPD, via caller)
     D BNDCSP          S              1A
 
      ** Currency OK flag (1A, from caller)
     D DDCCYOK         S              1A
 
      ** End of parameters
      ** =================
 
      ** =========================
      ** Parameter list for ZA0840
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
 
      ** Number of decimal places field for numeric validation
     D @@IDP           S              2  0
 
      ** Number of integers field for numeric validation
     D @@IINT          S              2  0
 
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
 
      ** Amount calculation field
     D @@AMT           S             15  0
 
      ** Error return code for ZA0840 module
     D @@ERCD          S              1  0
 
      ** Numeric version of spread
     D @SPRD           S             11P 7
      ** End of parameter list for ZA0840
      ** ================================
 
 
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
 
      ** Reset work fields
     C                   RESET                   ErrorFound
     C                   RESET                   MsgID1
 
     C**  The sale price must be entered.
     C     DDAMNP        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0408'     MsgID1
     C*
     C**  If currency valid, check sale price is valid numeric.
     C                   ELSE
     C     DDCCYOK       IFNE      'N'
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDAMNP        @@ALPH
     C                   MOVE      'Y'           @@MTID            1
 
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
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0409'     MsgID1
 
     C                   END
     C                   END
     C                   END
     C*
     C**  If the amount is valid, output it
     C     DDCCYOK       IFNE      'N'
     C     ErrorFound    ANDEQ     'N'
     C                   Z-ADD     @@AMT         ILAMNP
     C                   MOVE      @@ALPH        DDAMNP
     C                   END
 
      ** Set return code
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
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msgid1
      ** Deal file version of amount (15,0P, returned to caller)
     C                   PARM                    ILAMNP
      ** Sale price (15A, from transaction)
     C                   PARM                    DDAMNP
      ** Number of decimal places in currency (1,0S from SDCURRPD, via caller)
     C                   PARM                    A6NBDP
      ** Decimal separator character (1A from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      ** Currency OK flag (1A, from caller)
     C                   PARM                    DDCCYOK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
