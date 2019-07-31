     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Creation Date')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCRDT  - Validate Date of Initial Contact                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD050212           Date 02Apr18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD037883A          Date 31Mar16               *
      *                 MD035076           Date 21Jul15               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037883A - Unable to Authorise Amendment on Customer Details*
      *  MD035076 - Unable to delete a customer where Creation Date   *
      *             is blank                                          *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
     FSDCUSXL1  IF   E           K DISK    PREFIX(X1_)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** VALIDATION
      *
     C                   EXSR      VCRDT
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCRDTOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Creation Date
      *****************************************************************
     C     VCRDT         BEGSR
 
      * Retrieve Customer Creation Date for reference
     C     DDCUSN        CHAIN     SDCUSTX0                           99
 
      * On Insert Action - If Creation Date is left blank,
      * set the current run date as default value
     C                   IF        DDCRDT = *BLANKS and DDACTN = 'I'
     C                   Z-ADD     RDNB          XCCRDT
     C                   Z-ADD     XCCRDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     *BLANKS       DDCRDT
     C                   MOVEL     ZDATE         DDCRDT
     C                   GOTO      EndVCRDT
     C                   ENDIF
 
      * On Amendment - If Creation Date is displayed and left blank,
      * keep the value of 0, the take-on initial value for existing users
     C                   IF        DDACTN = 'A' and DDCRDT = *BLANKS
     C                             OR DDACTN = 'D' and DDCRDT = *BLANKS                    MD037883A
     C                   IF        X1_XCCRDT = 0
     C                   Z-ADD     0             XCCRDT
     C                   GOTO      EndVCRDT
 
      * If Creation Date has already been set previously, it cannot be reset.
     C                   ELSE
     C                   MOVE      'N'           DDCRDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0303'     MsgIdXAr(Idx)
     C                   GOTO      EndVCRDT
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCRDT <> *BLANKS                                        MD035076
      * Creation Date must be numeric
     C                   TESTN                   DDCRDT               98
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'N'           DDCRDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0301'     MsgIdXAr(Idx)
     C                   GOTO      EndVCRDT
     C                   ENDIF
 
      * Creation Date must be a valid date
     C                   MOVE      DDCRDT        ZDATEA
     C                   EXSR      ZDATE1
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDCRDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0301'     MsgIdXAr(Idx)
     C                   GOTO      EndVCRDT
     C                   ENDIF
     C                   ENDIF                                                              MD035076
 
      * Creation Date is only amendable when previous value is default (0)
     C     DDCUSN        CHAIN     SDCUSTX0                           99
     C                   IF        X1_XCCRDT <> 0
     C                             and X1_XCCRDT <> ZDAYNO
     C                             AND *IN99 = '0'
     C                   MOVE      'N'           DDCRDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0303'     MsgIdXAr(Idx)
     C                   GOTO      EndVCRDT
     C                   ENDIF
 
      * Creation Date may not be later than run date
     C                   Z-ADD     ZDAYNO        XCCRDT
     C     XCCRDT        IFGT      RDNB
     C                   MOVE      'N'           DDCRDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCRDT'      FldNamXAr(Idx)
     C                   MOVEL     'USS0304'     MsgIdXAr(Idx)
     C                   ENDIF
 
      *
     C     EndVCRDT      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    DFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    DFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Creation Date Alpha (6A)
      ** Customer Number (6A)
      ** Action Code (1A)
      ** Midas Run Date (5,0)
      ** Midas Date Format Indicator (1A)
      *
     C                   PARM                    DDCRDT            6
     C                   PARM                    DDCUSN            6
     C                   PARM                    DDACTN            1
     C                   PARM                    RDNB              5 0
     C                   PARM                    DFIN              1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Creation Date - OK
     C                   PARM                    DDCRDTOK          1
      *
      ** Creation Date Numeric (5,0)
      *
     C                   PARM                    XCCRDT            5 0
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
