     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate sale of deal number')                *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVSALEDNO - Validate sale of deal number                    *
      *                                                               *
      *  Function:  This module validates that a received six-digit   *
      *             number is valid as a sale of deal number for a    *
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
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12582           Date 13Nov06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG12582 - Additional validation during Authorise: Check if  *
      *             associated (purchase) deal is authorised.         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP,*
      *           MMDENBPP, MMDENSPP and MMDEAMPP.                    *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(@MDEAL)
     F                                     RENAME(MMDELDP0:MMDELDP2)
     F                                     RENAME(MMDENBP0:MMDENBP2)
     F                                     RENAME(MMDENSP0:MMDENSP2)
 
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP2)
 
     FDLDLDDL1  IF   E           K DISK                                                     BUG12582
                                                                                            BUG12582
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
 
      ** MMDENBP0 format inlcuded as an externally-defined data structure,
      ** so that it can be returned to the caller.
     D NASBFmt       E DS                  EXTNAME(MMDENBPP)
 
      ** INFDS for MMDEALLL
     D @MDEAL          DS
     D  @DEST            *STATUS
     D  @FMT             *RECORD
 
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
 
      ** Deal file version of sale of deal number (6A, returned
      ** to caller)
     D ILDADN          S                   LIKE(HLDADN)
 
      ** Sale of deal number (6A, from transaction)
     D DDDADN          S              6A
 
      ** Deal type (2A, from transaction)
     D DDMTYP          S                   LIKE(HLMTYP)
 
      ** Deal number (6A, from transaction (or from generator))
     D DDDLNO          S              6A
 
      ** Deal currency (3A, from transaction)
     D DDCCY           S                   LIKE(HLCCY)
 
      ** Face value amount field (15,0P, from caller)
     D ILFVAL          S                   LIKE(HLFVAL)
 
      ** Issued by customer number (6,0S, from caller)
     D*ILISCN***       S              6S 0                                                    CSD027
     D ILISCN          S              6A                                                      CSD027
 
      ** Value date of deal (5,0P, from caller)
     D ILDVSD          S                   LIKE(HLLCD)
 
      ** Currency OK flag (1A, from caller)
     D DDCCYOK         S              1A
 
      ** Face value OK flag (1A, from caller)
     D FaceValOK       S              1A
 
      ** Customer OK flag (1A, from caller)
     D CustOK          S              1A
 
      ** Value date OK flag (1A, from caller)
     D ValDateOK       S              1A
 
      ** End of parameters
      ** =================
 
      ** Numeric version of deal number used for accessing deals file
     D @DLKEY          S                   LIKE(HLDN38)
 
      ** Date in Midas day number format
     D ZZMDNO          S                   LIKE(HLLCD)
 
      ** Position scan string found
     D Position        S              3P 0
 
      ** -------------------------
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
 
      ** Decimal separator character
     D BNDCSP          S              1A
                                                                                            BUG12582
      ** Action Code                                                                        BUG12582
     D DDACTN          S              1A                                                    BUG12582
 
      ** End of parameter list for ZA0840
      ** --------------------------------
 
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
 
     C**  Note: sale of deal no checks must be performed after
     C**  validation of issuer, value date, currency and face value
 
      ** Reset variables to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
 
     C     DDDADN        IFEQ      *BLANKS
     C     DDDADN        OREQ      *ZEROS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0185'     MsgID1
     C                   ELSE
 
      ** Check that the input field is numeric
      ** -------------------------------------
      ** Put the input field into the parameter field for ZA0840; set the
      ** number of decimal places to 0 and the number of integers to 6, and
      ** and disable the thousands/millions function.
     C                   EVAL      @@ALPH = DDDADN
     C                   EVAL      @@IDP = 0
     C                   EVAL      @@IINT = 6
     C                   EVAL      @@MTID = 'N'
 
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
      ** If the error code  from ZA0840 was zero, the field contains a
      ** valid number; but ZA0840 allows a decimal separator,
      ** which is not allowed here, so check for that.  Also an error
      ** if the number is negative.
     C     BNDCSP        SCAN      DDDADN        Position
     C                   IF        @@ERCD <> 0
     C                               OR (@@ERCD = 0 AND Position <> 0)
     C                               OR @@AMT < 0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0184'     MsgID1
 
     C                   ELSE
     C*
     C**  The associated deal must be an active deal record
     C*
     C**  .....Check that MMDEALL record exists and is not logically
     C**       deleted (@FMT holds record format name from INFDS)
     C                   MOVE      DDDADN        @DLKEY
     C     @DLKEY        CHAIN     MMDEALLL                           65
     C     *IN65         IFEQ      '1'
     C     @FMT          OREQ      'MMDELDP2'
     C     HKDLTF        ANDEQ     '*'
     C     @FMT          OREQ      'MMDENBP2'
     C     HLDLTF        ANDEQ     '*'
     C     @FMT          OREQ      'MMDENSP2'
     C     HMDLTF        ANDEQ     '*'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0184'     MsgID1
     C*
     C**  .....Check that not deleted deal
     C                   ELSE
     C     @FMT          IFEQ      'MMDELDP2'
     C     HKDDLT        ANDEQ     'D'
     C     @FMT          OREQ      'MMDENBP2'
     C     HLDDLT        ANDEQ     'D'
     C     @FMT          OREQ      'MMDENSP2'
     C     HMDDLT        ANDEQ     'D'
     C*
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0183'     MsgID1
     C                   END
     C                   END
     C                   END
     C*
     C**  Associated deal must be NAB and eligible for sale
     C                   IF        ErrorFound = 'N'
     C*
     C**  .....must be NAB
     C     @FMT          IFNE      'MMDENBP2'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0190'     MsgID1
     C*
     C**  .....must have status of C,A or R (complete or higher)
     C                   ELSE
 
     C     HLDSTS        IFNE      'C'
     C     HLDSTS        ANDNE     'A'
     C     HLDSTS        ANDNE     'R'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0255'     MsgID1
     C*
     C**  .....must have blank assoc. deal no. (not already sold)
     C**  (note that parcelled trades have blank associated deal number)
     C                   ELSE
     C     HLDADN        IFNE      *BLANKS
     C     HLPCLI        ANDNE     'P'
     C     HLDADN        ANDNE     DDDLNO
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0189'     MsgID1
     C*
     C**  .....new and associated deal types must correspond
     C                   ELSE
     C     DDMTYP        IFEQ      'CS'
     C     HLMTYP        ANDNE     'C1'
     C     HLMTYP        ANDNE     'C2'
     C     DDMTYP        OREQ      'BS'
     C     HLMTYP        ANDNE     'BP'
     C     DDMTYP        OREQ      'BR'
     C     HLMTYP        ANDNE     'BD'
     C     DDMTYP        OREQ      'TS'
     C     HLMTYP        ANDNE     'TB'
     C     DDMTYP        OREQ      'RA'
     C     HLMTYP        ANDNE     'DA'
     C     DDMTYP        OREQ      'TR'
     C     HLMTYP        ANDNE     'TA'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0191'     MsgID1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** +---------------------------------------+
      ** | From here on is the original part two |
      ** +---------------------------------------+
 
     C                   IF        ErrorFound = 'N'
 
     C**  Currency, face value and issuer on new deal must be same
     C**   on associated deal (only check for valid fields)
     C     DDCCYOK       IFNE      'N'
     C     DDCCY         ANDNE     HLCCY
     C     FaceValOK     ORNE      'N'
     C     DDCCYOK       ANDNE     'N'
     C* Only test if trade not parcelled
     C     HLPCLI        ANDNE     'P'
     C     ILFVAL        ANDNE     HLFVAL
     C     CustOK        ORNE      'N'
     C     ILISCN        ANDNE     HLISCN
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0192'     MsgID1
     C*
     C*   If value date valid, check that new deal value date is
     C**   between the value date and maturity date of the associated
     C**   deal and later than the date of any deal amendment
     C                   ELSE
     C     ValDateOK     IFNE      'N'
     C*
     C**  .....convert associated deal's value date to MIDAS day number
     C**       and check sale value date not earlier than purchase
     C**       value date
     C                   Z-ADD     HLVDYY        @YEAR
     C                   Z-ADD     HLVDMM        @MNTH
     C                   Z-ADD     HLVDDD        @DAY
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    @DATE
     C                   PARM                    ZZMDNO
 
     C     ILDVSD        IFLT      ZZMDNO
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ValDateOK = 'N'
     C                   MOVEL     'MMM0193'     MsgID1
     C*
     C**  .....convert associated deal's maturity date to MIDAS day no
     C**       and check sale value date is earlier than purchase
     C**       maturity date
     C                   ELSE
     C                   Z-ADD     HLMDYY        @YEAR
     C                   Z-ADD     HLMDMM        @MNTH
     C                   Z-ADD     HLMDDD        @DAY
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    @DATE
     C                   PARM                    ZZMDNO
 
     C     ILDVSD        IFGE      ZZMDNO
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      ValDateOK = 'N'
     C                   MOVEL     'MMM0193'     MsgID1
     C*
     C**  .....retrieve latest deal amendment for associated deal and
     C**       check that sale value date greater than amendment value
     C**
     C                   ELSE
     C                   MOVE      DDDADN        @DLKEY
     C     @DLKEY        SETGT     MMDEAMLL
     C                   READP     MMDEAMLL                               65
      *
      ** Do not check dates if deleted
      *
     C     HNDDLT        DOWEQ     'D'
     C     *IN65         ANDEQ     '0'
     C                   READP     MMDEAMLL                               65
     C                   END
      *
     C     *IN65         IFEQ      '0'
     C     HNDA38        ANDEQ     @DLKEY
     C                   Z-ADD     HNVDYY        @YEAR
     C                   Z-ADD     HNVDMM        @MNTH
     C                   Z-ADD     HNVDDD        @DAY
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    @DATE
     C                   PARM                    ZZMDNO
 
     C     ILDVSD        IFLE      ZZMDNO
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0181'     MsgID1
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
 
     C                   ENDIF
 
     C     ErrorFound    IFEQ      'N'
     C                   MOVE      DDDADN        ILDADN
     C                   END
 
      ** If Action code is Authorise, check if the associated deal has                      BUG12582
      ** already been authorised by looking at DEALSDD file...                              BUG12582
                                                                                            BUG12582
     C                   IF        PActn = 'X'                                              BUG12582
     C                   MOVE      DDDADN        @DLKEY                                     BUG12582
     C     @DLKEY        CHAIN     DLDLDDL1                                                 BUG12582
     C                   IF        NOT %FOUND(DLDLDDL1)                                     BUG12582
     C                   EVAL      ErrorFound = 'Y'                                         BUG12582
     C                   MOVEL     'MMM2547'     MsgID1                                     BUG12582
     C                   ENDIF                                                              BUG12582
     C                   ENDIF                                                              BUG12582
 
      ** Set return code
     C                   IF        ErrorFound= 'Y'
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
      ** +--- Note to caller ---------------------------------------------+
      ** |                                                                |
      ** | Sale of deal number must be validated after the validation of  |
      ** | Issuer, Value Date, Currency and Face Value.                   |
      ** | This differs from the original validation in MM0027, which was |
      ** | split into two sections, and only the second section had the   |
      ** | above restriction.                                             |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msgid1
      ** Deal file version of sale of deal number (6A, returned
      ** to caller)
     C                   PARM                    ILDADN
      ** Sale of deal number (6A, from transaction)
     C                   PARM                    DDDADN
      ** Deal type (2A, from transaction)
     C                   PARM                    DDMTYP
      ** Deal number (6A, from transaction (or from generator))
     C                   PARM                    DDDLNO
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Face value amount field (15,0P, from caller)
     C                   PARM                    ILFVAL
      ** Issued by customer number (6,0S, from caller)
     C                   PARM                    ILISCN
      ** Value date of deal (5,0P, from caller)
     C                   PARM                    ILDVSD
      ** Currency OK flag (1A, from caller)
     C                   PARM                    DDCCYOK
      ** Face value OK flag (1A, from caller)
     C                   PARM                    FaceValOK
      ** Customer OK flag (1A, from caller)
     C                   PARM                    CustOK
      ** Value date OK flag (1A, from/to caller)
     C                   PARM                    ValDateOK
      ** Decimal separator character (1A, from caller)
     C                   PARM                    BNDCSP
     ** Action code                                                                         BUG12582
     C                   PARM      DDACTN        PActn             1                        BUG12582
      ** Negotiable asset purchased data structure returned to caller
      ** (NOTE: this field should remain as the final parameter in this
      ** even if new ones are added, as it is not strictly part of the
      ** validation done by this module, and is only returned at this point
      ** as a convenience for other modules.
     C                   PARM                    NASBFmt
 
 
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
