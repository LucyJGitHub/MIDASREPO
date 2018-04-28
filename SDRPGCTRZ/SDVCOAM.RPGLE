     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Collateral Amount')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Collateral Amount    *
      *                                                               *
      *  SDVCOAM - Validate Collateral Amount                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Customer Future and Options Details amendments must *
      *    not be applied to this source.                             *
      *                                                               *
      *  Last Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG13609           Date 21Mar07               *
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  BUG13609 - MidasPlus error occurs during entry of Customer   *
      *             Futures and Options                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
     ** Midas SD Midas SD Currency codes retrieval
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Data Structure defined for message USR1195
     DW#MSGDTA         DS
     D W#DTA1                        13
     D W#DTA2                         2P 0
     D W#DTA3                         1P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define work field Number of Decimal Places
     D WUNBDP          S              1  0
      ** Define work field ZALIGN Screen Fun Field
     D WUZASF          S             16
      ** Define work field ZALIGN No Of Decimals
     D WUZAND          S              1  0
      ** Define work field ZALIGN No Of Digits
     D WUZADG          S              2  0
      ** Define work field ZALIGN File Field
     D WUZAFF          S             16
      ** Define work field Return Code
     D W0RTN           S              7
      ** Define work field Err Code
     D WUERCD          S              1
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work Variables
     D DDCOAM          S             13A
     D*FOCOAM***       S             13A                                                    BUG13609
     D FOCOAM          S             13P 0                                                  BUG13609
     D DDCYCD          S              3A
     D DDCOAMOK        S              1A
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
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
 
      ** Validation
 
      ** Validate Collateral Amount,
      ** Collateral Amount Screen field is Not Blank
     C                   IF        DDCOAM <> *BLANK
      ** Get Currency Code - Currency Codes  *
     C                   EXSR      SFRVGN
      ** Return code is *Record does not exist
     C                   IF        W0RTN ='Y2U0005'
     C                   EVAL      WUZAND = *ZERO
     C                   ELSE
 
      ** Get Base Currency Details 2 - Currency Codes  *
     C                   EXSR      SGRVGN
     C                   Z-ADD     WUNBDP        WUZAND
     C                   ENDIF
      ** Set up Number of Digits
      ** WRK.ZALIGN No Of Decimals is Zero
     C                   IF        WUZAND = *ZERO
     C                   Z-ADD     13            WUZADG
     C                   ELSE
      ** WRK.ZALIGN No Of Decimals is One
     C                   IF        WUZAND = 1
     C                   Z-ADD     11            WUZADG
     C                   ELSE
      ** WRK.ZALIGN No Of Decimals is Two
     C                   IF        WUZAND = 2
     C                   Z-ADD     10            WUZADG
     C                   ELSE
      ** WRK.ZALIGN No Of Decimals is Three
     C                   IF        WUZAND = 3
     C                   Z-ADD     9             WUZADG
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WUZASF = *BLANK
     C                   EVAL      WUZASF = DDCOAM
      ** Call ZALIGN & ZEDIT
      ** ZALIGN Screen Field - Standard Functions
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUZAND
     C                   PARM                    WUZADG
     C     WUZAFF        PARM      *BLANK        WUZAFF
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDCOAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOAM    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZALIGN'                                MD000091
     C                   EVAL      MsgDtaTmp = 'ZALIGN'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDTAXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
 
     ** Return code is Error
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      WUERCD = 'Y'
     C                   ELSE
 
     C                   EVAL      WUERCD = 'N'
      ** ZEDIT Screen Field - Standard Functions
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM                    WUZASF
     C                   PARM                    WUZAND
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDCOAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOAM   '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZEDIT'                                 MD000091
     C                   EVAL      MsgDtaTmp = 'ZEDIT'                                      MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
 
     C                   ENDIF
      ** WRK.Err Code is Error Found
     C                   IF        WUERCD = 'Y'
      ** Send message 'Collateral Amount Numeric'
     C                   EVAL      DDCOAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCOAM   '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1195'
     C                   EVAL      W#DTA1 = DDCOAM
     C                   EVAL      W#DTA2 = 13
     C                   EVAL      W#DTA3 = 0
     C**********         EVAL      MsgDtaXAr(Idx) = W#MSGDTA                                MD000091
     C                   EVAL      BLen = %Len(%Trim(W#DTA1))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(W#DTA1)                   MD000091
     C                   EVAL      MsgDtaTmp = %CHAR(W#DTA2)                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   EVAL      MsgDtaTmp = %CHAR(W#DTA3)                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr + %TRIM(MsgDtaTmp)               MD000091
     C
 
     C                   ELSE
      ** Move Collateral Amount - Futures & Options Clients
      ** ZALIGN Collateral Amount Screen
     C                   MOVE      WUZASF        DDCOAM
     C                   MOVE      WUZAFF        FOCOAM
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      FOCOAM = *ZERO
 
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      ******************************************************************
     C/EJECT
      ******************************************************************
      * SFRVGN - Get Currency Code - Currency Codes                    *
      ******************************************************************
     CSR   SFRVGN        BEGSR
     C                   MOVEL     *BLANK        W0RTN
      ** Define keylist
     C     KRSSF         KLIST
     C                   KFLD                    A6CYCD
      ** Move fields to key list
     C                   MOVEL     DDCYCD        A6CYCD
      ** Chain Currency Code Retrieval File,SDCURRL1
     C     KRSSF         CHAIN     @A6REA3                              90
     C                   IF        *IN90 = *ON
      ** Data record not found
     C                   MOVEL     'USR0071'     W0RTN
      ** Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN
     C                   GOTO      SFEXIT
     C                   END
 
     CSR   SFEXIT        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Get Base Currency Details 2 - Currency Codes                  *
      *****************************************************************
     CSR   SGRVGN        BEGSR
     C                   MOVEL     *BLANK        W0RTN
      ** Define keylist
     C     KRSSG         KLIST
     C                   KFLD                    A6CYCD
      ** Move fields to key list
     C                   MOVEL     DDCYCD        A6CYCD
      ** Chain Currency Code Retrieval File,SDCURRL1
     C     KRSSG         CHAIN     @A6REA3                            90
      ** Data record not found
     C   90              MOVEL     'USR0071'     W0RTN
     C                   IF        *IN90 = *OFF
      ** Process Data record for Number of Decimal places
     C                   Z-ADD     A6NBDP        WUNBDP
     C                   END
     C     SGEXIT        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
      ** Collateral Amount
     C                   PARM                    DDCOAM
      ** Collateral Currency,
     C                   PARM                    DDCYCD
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Collateral Amount - OK
     C                   PARM                    DDCOAMOK
      ** Return Collateral Amount
     C                   PARM                    FOCOAM
 
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
(c) Misys International Banking Systems Ltd. 2006
