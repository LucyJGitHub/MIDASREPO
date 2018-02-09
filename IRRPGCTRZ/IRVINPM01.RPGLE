     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Interest Processing Method')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRVINPM01 - Validate Interest Processing Method              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
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
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
     FDLDTSCL0  IF   E           K DISK    INFSR(*PSSR)
     FDLDTSCPD  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLDTSCD0:DLDTSCDD)
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
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D/COPY QWINDSRC,IRSIRSGDTA
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D CIR006          S              1A
     D CIR007          S              1A
     D SWIPM           S              1A
     D PSide           S              5A
 
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
     C                   Z-ADD     0             WIdx
 
      *
      ** Validate Interest Processing Method
      *
     C                   EXSR      SRValInPm
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        PSide = 'Our' AND
     C                             OKOIPM = 'N' OR
     C                             PSide = 'Their' AND
     C                             OKTIPM = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        PSide = 'Our' AND
     C                             OKOIPM <> 'N'
     C                   MOVE      SWIPM         #1UINP
     C                   ENDIF
      *
     C                   IF        PSide = 'Their' AND
     C                             OKTIPM <> 'N'
     C                   MOVE      SWIPM         #1TINP
     C                   ENDIF
      *
      ** Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValInPm - Validation for Interest Processing Method        *
      *                                                               *
      *****************************************************************
      *
     C     SRValInPm     BEGSR
      *
      ** Move the interest processing method to work field
      *
     C                   IF        PSide = 'Our'
     C                   EVAL      SWIPM = SOIPM
     C                   ELSE
     C                   EVAL      SWIPM = STIPM
     C                   ENDIF
      *
      ** If Rate Change Frequency Code is 'O', Interest Processing
      ** Method must be blank.
      *
     C                   IF        CIR007 = 'Y' AND SWIPM <> *BLANKS AND
     C                             ((PSide = 'Our' AND #1UICF = 'O') OR
     C                              (PSide = 'Their' AND #1TICF = 'O'))
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00001'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00056'
     C                   ENDIF
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
     C                   IF        SWIPM = *BLANKS
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** Must be D, Y, C or K
      *
     C                   IF        SWIPM <> 'D' AND SWIPM <> 'Y' AND
     C                             SWIPM <> 'C' AND SWIPM <> 'K' AND
     C                             SWIPM <> 'N' AND CIR006 = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00002'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00057'
     C                   ENDIF
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** Must be D, Y, C, K, A, I, L for CIR006
      *
     C                   IF        SWIPM <> 'D' AND SWIPM <> 'Y' AND
     C                             SWIPM <> 'C' AND SWIPM <> 'K' AND
     C                             SWIPM <> 'A' AND SWIPM <> 'I' AND
     C                             SWIPM <> 'L' AND CIR006 = 'Y'
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00003'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00058'
     C                   ENDIF
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** For Our Side, Principal schedule is not allowed with interest up
      ** front or if interest is capitalised.
      *
     C                   IF        PSide = 'Our' AND
     C                             SONPCD <> *BLANKS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00004'
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** For Their Side, Principal schedule is not allowed with interest up
      ** front or if interest is capitalised.
      *
     C                   IF        PSide = 'Their'
 
     C                   IF        #1DTYP = 'RS' AND
     C                             SONPCD <> *BLANKS OR
     C                             #1DTYP = 'RX' AND
     C                             STNPCD <> *BLANKS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00010'
     C                   GOTO      ESRValInPm
     C                   ENDIF
 
     C                   IF        CIR006 = 'Y' AND
     C                             SONPCD <> *BLANKS AND
     C                             (#1DTYP = 'RP' OR #1DTYP = 'RR' OR
     C                             #1DTYP = 'RF')
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00010'
     C                   GOTO      ESRValInPm
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   IF        SWIPM = 'D' OR SWIPM = 'Y'
      *
      ** Interest up front is not allowed for Caps/Collars/Floors
      *
     C                   IF        CIR006 = 'Y'
      *
     C                   IF        #1DTYP = 'RP' OR #1DTYP = 'RR' OR
     C                             #1DTYP = 'RF'
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   ENDIF
     C                   EVAL      MsgIdXAr(IDx) = 'RS00005'
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Interest Rate Change Frequency must be 'Z'
      *
     C                   IF        PSide = 'Our' AND
     C                             #1UICF <> *BLANKS AND
     C                             #1UICF <> 'Z' OR
     C                             PSide = 'Their' AND
     C                             #1TICF <> *BLANKS AND
     C                             #1TICF <> 'Z'
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00006'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00059'
     C                   ENDIF
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** Interest Payment Frequency must be 'Z'
      *
     C                   IF        PSide = 'Our' AND
     C                             #1UIPF <> *BLANKS AND
     C                             #1UIPF <> 'Z' OR
     C                             PSide = 'Their' AND
     C                             #1TIPF <> *BLANKS AND
     C                             #1TIPF <> 'Z'
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00007'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00060'
     C                   ENDIF
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** Access IRS Date Schedule and check if last
      ** interest payment date = maturity date.
      *
     C                   IF        PSide = 'Our'
     C                   MOVE      'U'           KOTIN1
     C                   ELSE
     C                   MOVE      'T'           KOTIN1
     C                   ENDIF
     C                   Z-ADD     #1DLNO        KDLNO1
     C                   MOVE      'P'           KRCIP1
     C                   Z-ADD     #1MDAT        KPRDT1
      *
     C     KDSCH1        SETLL     DLDTSCD0                               01
     C                   IF        *IN01
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   ENDIF
     C                   EVAL      MsgIdXAr(IDx) = 'RS00008'
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** Interest rate change date must have corresponding
      ** interest payment date in IRS Date Schedule.
      *
     C                   Z-ADD     #1DLNO        KDLNO2
     C                   IF        PSide = 'Our'
     C                   MOVE      'U'           KOTIN2
     C                   ELSE
     C                   MOVE      'T'           KOTIN1
     C                   ENDIF
     C                   MOVE      'R'           KRCIP2
      *
      ** Read rate change date
      *
     C                   MOVE      '0'           *IN01
     C     KDSCH2        SETLL     DLDTSCDD
     C     KDSCH2        READE     DLDTSCDD                               02
      *
     C                   DOW       NOT(*IN01) AND NOT(*IN02)
      *
      ** Read payment date
      *
     C                   Z-ADD     PRDT          KPRDT1
     C     KDSCH1        CHAIN     DLDTSCD0                           01
     C                   IF        *IN01
     C                   EVAL      IDx = IDx + 1
     C                   IF        PSide = 'Our'
     C                   EVAL      OKOIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SOIPM'
     C                   ELSE
     C                   EVAL      OKTIPM = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'STIPM'
     C                   ENDIF
     C                   EVAL      MsgIdXAr(IDx) = 'RS00009'
     C                   GOTO      ESRValInPm
     C                   ENDIF
      *
      ** Read next rate change date
      *
     C     KDSCH2        READE     DLDTSCDD                               02
     C                   ENDDO
 
     C                   ENDIF
 
     C     ESRValInPm    ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Side to be validated (Our/Their)
     C                   PARM                    PSide
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** FRA/IRS Amortisation of Caps, Collars, Floors & Individual
      ** Compounding Swaps
     C                   PARM                    CIR006
      *
      ** Overnight Index Swaps
     C                   PARM                    CIR007
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
      *
      ** Define key fields
      *
     C     KDSCH1        KLIST
     C                   KFLD                    KDLNO1            6 0
     C                   KFLD                    KOTIN1            1
     C                   KFLD                    KRCIP1            1
     C                   KFLD                    KPRDT1            5 0
      *
     C     KDSCH2        KLIST
     C                   KFLD                    KDLNO2            6 0
     C                   KFLD                    KOTIN2            1
     C                   KFLD                    KRCIP2            1
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
(c) Finastra International Limited 2002
