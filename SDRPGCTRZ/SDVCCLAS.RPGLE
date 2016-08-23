     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate secs classification')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Security Customer Details Val.*
      *                                                               *
      *  SDVCCLAS - Validate Classification                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 15May13               *
      *  Prev Amend No. AR579505           Date 16Jul10               *
      *                 AR551811           Date 09Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG12946           Date 20Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 15Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR579505 - SE customer classification should not be amendable*
      *             when customer has existing position               *
      *  AR551811 - SE customer classification should not be amendable*
      *             when customer has existing position               *
      *  BUG12946 - Do not allow classification to be changed from    *
      *             portfolio customer to non-portfolio if there is   *
      *             an existing position.                             *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of SD inputs to modular structure        *
      *           to use as APIs                                      *
      *****************************************************************
 
      ***Midas*SE customer position by customer number                             BUG12946 AR551811
      **********                                                                   BUG12946 AR551811
     F**CPOSCS**  IF   E           K DISK    INFSR(*PSSR)                          BUG12946 AR551811
      *                                                                                     AR551811
      ** Position files updated in I/C                                                      AR551811
      *                                                                                     AR551811
     FUDEPL4    IF   E           K DISK                                                     AR551811
     FCDEPL5    IF   E           K DISK                                                     AR551811
      *                                                                                     AR551811
      ** Position files updated in COB                                                      AR551811
      *                                                                                     AR551811
     FDPOSL1    IF   E           K DISK                                                     AR551811
     FCPOSL1    IF   E           K DISK                                                     AR551811
      *                                                                                     AR551811
      ** SD Branch Details - Retrieval                                                      AR551811
      *                                                                                     AR551811
     FSDBRCHL5  IF   E           K DISK                                                     AR551811
                                                                                            BUG12946
      ** Midas SD securities clients by customer number                                     BUG12946
                                                                                            BUG12946
     FSDSECSL4  IF   E           K DISK    INFSR(*PSSR)                                     BUG12946
 
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
 
      ** Data structure for Portfolio Management indicator using SESTAT
     D SESTAT          DS           133
     D  WKPOMG                64     64
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                     AR551811
      ** Work variable for position                                                         AR551811
      *                                                                                     AR551811
     DWUPOSN           S              1A                                                    AR551811
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
     C                   EXSR      VCLAS
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCLASOK      IFEQ      'N'
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
     C     VCLAS         BEGSR
 
      ** Query processing
     C                   MOVEL     DDCLAS        QueryFld          1
     C     QueryFld      IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            99
     C                   PARM                    RetCode           7
     C                   PARM      1101775       ListNumber        7 0
     C     DDCLAS        PARM      DDCLAS        ExtValue         20
     C                   ENDIF
 
     C                   SELECT
 
      ** When classification is blank
     C                   WHEN      DDCLAS = *BLANKS
 
      ** Err: 'Value required'
     C                   Eval      DDCLASOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDCLAS    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0220'
 
      ***When*classification*is*not*S*D*M*I*X*E*C*K*or*blank***********                       CSE022
      ** When classification is not S D M I X E C or blank                                    CSE022
 
     C                   WHEN      DDCLAS <> 'S' and DDCLAS <> 'D' and
     C                             DDCLAS <> 'M' and DDCLAS <> 'I' and
     C                             DDCLAS <> 'X' and DDCLAS <> 'E' and
     C**********                   DDCLAS <> 'C' and DDCLAS <> 'K' and                        CSE022
     C**********                   DDCLAS <> *BLANKS                                          CSE022
     C                             DDCLAS <> 'C' and DDCLAS <> *BLANKS                        CSE022
 
      ** Err: 'The classification entered is invalid'
     C                   Eval      DDCLASOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDCLAS    '
     C                   Eval      MsgIdXAr(Idx) = 'USR1491'
 
      ** When portfolio management licensed indicator is N or blank
     C                   WHEN      WKPOMG = 'N' or WKPOMG = *BLANKS
 
      ** If classificiation is D or S
     C                   IF        DDCLAS = 'D' or DDCLAS = 'S'
     C
      ** Err: 'Portfolio management facilities not licensed'
     C                   Eval      DDCLASOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      FldNamXAr(Idx) = 'DDCLAS    '
     C                   Eval      MsgIdXAr(Idx) = 'USR0575'
     C                   ENDIF
 
     C                   ENDSL
                                                                                            BUG12946
     C                   IF        DDCLASOK <> 'N'                                          BUG12946
     C                             AND DDCUSN <> *BLANKS                                    BUG12946
                                                                                            BUG12946
      ** Get existing securities client details                                             BUG12946
                                                                                            BUG12946
     C     DDCUSN        CHAIN     SDSECSL4                                                 BUG12946
     C                   IF        %FOUND(SDSECSL4)                                         BUG12946
     C                   EVAL      WUPOSN = 'N'                                             AR579505
      *                                                                                     AR551811
      ** If classification changes from market to portfolio                                 AR551811
      *                                                                                     AR551811
     C                   IF        DDCLAS = 'S' and BFCLAS <> 'D' or                        AR551811
     C                             DDCLAS = 'D' and BFCLAS <> 'S'                           AR551811
     C                   IF        BFCLAS = 'M' or BFCLAS = 'I' or                          AR551811
     C                             BFCLAS = 'X' or BFCLAS ='E' or                           AR551811
     C                             BFCLAS = 'C'                                             AR551811
      *                                                                                     AR551811
      ** Check customer on Position files and if not found, check in                        AR551811
      ** position files updated in I/C.                                                     AR551811
      *                                                                                     AR551811
                                                                                            AR551811
     C     DDCUSN        CHAIN     DPOSL1                                                   AR551811
     C                   IF        %FOUND()                                                 AR551811
     C                   EVAL      WUPOSN = 'Y'                                             AR551811
     C                   ELSE                                                               AR551811
      *                                                                                     AR551811
     C     DDCUSN        CHAIN     UDEPL4                                                   AR551811
     C                   IF        %FOUND()                                                 AR551811
     C                   EVAL      WUPOSN = 'Y'                                             AR551811
     C                   ELSE                                                               AR551811
     C                   EVAL      WUPOSN = 'N'                                             AR551811
     C                   ENDIF                                                              AR551811
      *                                                                                     AR551811
     C                   ENDIF                                                              AR551811
     C                   ENDIF                                                              AR551811
     C                   ENDIF                                                              AR551811
                                                                                            BUG12946
      ** If changing from portfolio customer to non-portfolio class,                        BUG12946
      ** check if there are existing customer positions                                     BUG12946
                                                                                            BUG12946
     C                   IF        (BFCLAS = 'S' OR BFCLAS = 'D') AND                       BUG12946
     C                             (DDCLAS <> 'S' AND DDCLAS <> 'D')                        BUG12946
                                                                                            BUG12946
     C*****DDCUSN        CHAIN     CPOSCS                                          BUG12946 AR551811
     C     DDCUSN        CHAIN     CPOSL1                                                   AR551811
     C**********         IF        %FOUND(CPOSCS)                                  BUG12946 AR551811
     C                   IF        %FOUND(CPOSL1)                                           AR551811
                                                                                            BUG12946
     C**********         Eval      DDCLASOK = 'N'                                  BUG12946 AR551811
     C**********         Eval      Idx = Idx + 1                                   BUG12946 AR551811
     C**********         Eval      FldNamXAr(Idx) = 'DDCLAS    '                   BUG12946 AR551811
     C**********         Eval      MsgIdXAr(Idx) = 'USR4814'                       BUG12946 AR551811
      *                                                                                     AR551811
     C                   EVAL      WUPOSN = 'Y'                                             AR551811
     C                   ELSE                                                               AR551811
      *                                                                                     AR551811
     C     DDCUSN        CHAIN     CDEPL5                                                   AR551811
     C                   IF        %FOUND()                                                 AR551811
     C                   EVAL      WUPOSN = 'Y'                                             AR551811
     C                   ELSE                                                               AR551811
     C                   EVAL      WUPOSN = 'N'                                             AR551811
     C                   ENDIF                                                              AR551811
      *                                                                                     AR551811
                                                                                            BUG12946
     C                   ENDIF                                                              BUG12946
     C                   ENDIF                                                              BUG12946
      *                                                                                     AR551811
     C                   IF        WUPOSN = 'Y'                                             AR551811
      *                                                                                     AR551811
      ** Err: 'Customer classification can not be amended. Customer has existing position.' AR551811
      *                                                                                     AR551811
     C                   Eval      DDCLASOK = 'N'                                           AR551811
     C                   Eval      Idx = Idx + 1                                            AR551811
     C                   Eval      FldNamXAr(Idx) = 'DDCLAS    '                            AR551811
     C                   Eval      MsgIdXAr(Idx) = 'SWF0100'                                AR551811
     C                   ENDIF                                                              AR551811
      *                                                                                     AR551811
      ** Check if customer is already defined as branch internal customer.                  AR551811
      *                                                                                     AR551811
     C     DDCUSN        CHAIN     SDBRCHL5                                                 AR551811
                                                                                            AR551811
     C                   IF        %FOUND(SDBRCHL5)                                         AR551811
      *                                                                                     AR551811
      ** If classification changes from 'I' to any other classifications.                   AR551811
      *                                                                                     AR551811
     C                   IF        DDCLAS <> 'I' and BFCLAS = 'I'                           AR551811
      *                                                                                     AR551811
      **  Err: 'Customer classification can not be amended. Customer is defined as branch   AR551811
      **  internal customer of &1.'                                                         AR551811
      *                                                                                     AR551811
     C                   Eval      DDCLASOK = 'N'                                           AR551811
     C                   Eval      Idx = Idx + 1                                            AR551811
     C                   Eval      FldNamXAr(Idx) = 'DDCLAS    '                            AR551811
     C                   Eval      MsgIdXAr(Idx) = 'SWF0101'                                AR551811
     C**********         Eval      MsgDtaXAr(Idx) = A8BRCD                         AR551811 MD000091
     C                   EVAL      BLen = %Len(%Trim(A8BRCD))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(A8BRCD)                   MD000091
     C                   ENDIF                                                              AR551811
      *                                                                                     AR551811
     C                   ENDIF                                                              AR551811
      *                                                                                     AR551811
     C                   ENDIF                                                              BUG12946
     C                   ENDIF                                                              BUG12946
 
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
      ** Classification
     C                   PARM                    DDCLAS            1
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
      ** Classification - OK
     C                   PARM                    DDCLASOK          1
     C                   PARM                    DDCUSN            6                        BUG12946
      *
      ** Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  SESTAT
     C                   IN        SESTAT
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
(c) Misys International Banking Systems Ltd. 2001
