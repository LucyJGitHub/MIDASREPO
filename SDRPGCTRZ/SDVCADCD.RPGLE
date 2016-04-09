     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate sscs alternative name & address')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVCADCD - Validate Alternative Name and Address             *
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
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CAP039  *CREATE    Date 15Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *  CAP039 - Conversion of SD inputs to modular structure        *
      *           to use as APIs                                      *
      *****************************************************************
 
     FSDALTNL1  IF   E           K DISK
      ** Midas SD Alternate names and address by customer number and code
 
     FSDALTNL2  IF   E           K DISK
      ** Midas SD Alternate names and address by customer number
 
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
      ** Work Customer Field
     D WDDCUST         S                   LIKE(DDCUST)
 
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
     C                   EXSR      VADCD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDADCDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VADCD         BEGSR
 
      ** Check that customer exists on alternative name and address file
     C                   IF        DDADCD <> *BLANKS
     C     DDCUST        CHAIN     SDALTNL2                           99
     C                   IF        *IN99 = '1'
 
      ** Err: 'Alternate name and address code not found'
     C                   Eval      DDADCDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDADCD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0083'
 
     C                   GOTO      EndVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Save Customer Name
     C                   EVAL      WDDCUST = DDCUST
      ** Query processing
     C                   MOVEL     DDADCD        QueryFld          1
     C     QueryFld      IFEQ      '?'
     C                   CALL      'SD0300S'                            99
     C                   PARM                    RetCode           7
     C                   PARM                    DDCUST
     C                   PARM                    DDADCD
     C                   ENDIF
 
      ** Check that code and customer number combination is on file
     C                   IF        DDADCD <> *BLANKS
     C     ALTNKey       CHAIN     SDALTNL1                           99
     C                   IF        *IN99 = '1'
 
      ** Err: 'Alternate name and address code not found'
     C                   Eval      DDADCDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDADCD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0083'
 
     C                   ENDIF
     C                   ENDIF
 
 
      ** Check that customer number has not changed
     C                   IF        WDDCUST <> DDCUST
      ** Err: 'Invalid Alternate Name & Address'
     C                   Eval      DDADCDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDADCD    '
     C                   Eval      MsgIdXAr(Idx) = 'USR4314'
 
     C                   ENDIF
 
     C     ENDVAL        ENDSR
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
      ** Other parms
      *
      ** Customer Number
     C                   PARM                    DDCUST            6
      *
      ** Alternative Name and Address
     C                   PARM                    DDADCD            1
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Alternative Name and Address - OK
     C                   PARM                    DDADCDOK          1
      *
      ** Key for chain to SDALTNL1 (alt name & address code file)
     C     ALTNKey       KLIST
     C                   KFLD                    DDCUST
     C                   KFLD                    DDADCD
 
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
(c) Misys International Banking Systems Ltd. 2001
