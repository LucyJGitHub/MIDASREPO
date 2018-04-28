     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Buy-Out Amount')                     *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing ILE Module                           *
      *                                                               *
      *  IRVBOAM01 - Validate Buy-Out Amount                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 245692             Date 10Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
 
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
 
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
     D WBUYA           S             13P 0
      *
      ** Parameters for ZALIGN
     D PZField         S             16A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PZalignOk       S              1A
      *
      ** Parameters for ZSEDITF
     D PZFld15         S             15P 0
     D PZECode         S              1
     D PZEChar         S              1
     D PZOut21         S             21
 
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *
      ** Validate Buy-Out Amount
      *
     C                   EXSR      SRValBuyA
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKBUYA = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKBUYA <> 'N'
     C                   Z-ADD     WBUYA         #1BOAM
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValBuyA - Validation for Buy-Out Amount                    *
      *                                                               *
      *****************************************************************
     C     SRValBuyA     BEGSR
      *
     C                   Z-ADD     *ZERO         WBUYA
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
      *
      ** If Buy-Out value date and pay/rec indicator
      ** are not blank, amount cannot be blank.
      *
     C     SBUYA         IFEQ      *BLANKS
 
     C     SBOVD         IFNE      *BLANKS
     C     SBOPR         ORNE      *BLANKS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKBUYA = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SBUYA'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00020'
     C                   ENDIF
 
     C                   GOTO      ESRValBuyA
     C                   ENDIF
      *
      ** Buy-Out amount must be a valid numeric field
      ** with the correct number of decimal places
      ** depending on currency (based on the pay/rec
      ** indicator).
      *
     C                   IF        SBOPR = 'P' OR SBOPR = 'R'
      *
     C**********         MOVE      *BLANKS       PZField                                      245692
     C**********         MOVE      SBUYA         PZField                                      245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      SBUYA         @@ALPH                                       245692
     C     SBOPR         IFEQ      'P'
     C                   Z-ADD     PWUCDP        PZADec
     C                   Z-ADD     PWUCDP        @@IDP                                        245692
     C                   ELSE
     C                   Z-ADD     PWTCDP        PZADec
     C                   Z-ADD     PWTCDP        @@IDP                                        245692
     C                   ENDIF
     C*****13***         SUB       PZADec        PZADig                                       245692
     C     13            SUB       PZADec        @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
 
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM      *BLANK        PZALIGNok                                    245692
     C**********         PARM                    PZField                                      245692
     C**********         PARM                    PZADec                                       245692
     C**********         PARM                    PZADig                                       245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
 
     C**********         IF        PZALIGNok <> 'Y'                                           245692
     C     @@ERCD        IFNE      0                                                          245692
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKBUYA = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SBUYA'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00021'
     C                   GOTO      ESrValBuyA
     C                   ENDIF
 
     C**********         MOVE      PZField       WBUYA                                        245692
     C                   MOVE      @@AMT         WBUYA                                        245692
     C                   Z-ADD     WBUYA         PZFld15
     C                   MOVE      *BLANK        PZECode
     C                   MOVE      *BLANK        PZEChar
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PZFld15
     C                   PARM                    PZADec
     C                   PARM                    PZECode
     C                   PARM                    PZeChar
     C                   PARM                    PZOut21
 
     C                   MOVE      PZOut21       SBUYA
 
     C                   ENDIF
 
     C     ESRValBuyA    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
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
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      *
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWTCDP
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
     C                   PARM                    BNDCSP                                       245692
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
(c) Misys International Banking Systems Ltd. 2002
