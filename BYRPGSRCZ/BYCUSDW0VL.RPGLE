     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BoE extra customer data validation')             *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BYCUSDW0VL - Validate Bank Of England Extra Customer Data    *
      *                                                               *
      *  Function:  This module validates extra Customer Bank of      *
      *             England Data.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR684053           Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG8497            Date 14Sep05               *
      *                 LLN022             Date 24Jan05               *
      *                 203458             Date 02Oct02               *
      *                 204195             Date 05Apr02               *
      *                 202030             Date 15Jan02               *
      *                 LLN018  *CREATE    Date 17Apr01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR684053 - Cannot enter a new customer. Applied AR665308.    *
      *  AR665308 - Error message BYM0071 being incorrectly issued.   *
      *  BUG8497 - SDVCUSDX0 renamed to SDVCUSDPE.                    *
      *          - SDECUSDX0 renamed to SDECUSDPE.                    *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  203458 - Add validation for institution code and industry    *
      *           previously done in main customer details maintenance*
      *  204195 - Default fields before validation if data coming     *
      *           from APIs.                                          *
      *  202030 - Only validate Institution code if not blanks        *
      *  LLN018 - Upgrade BoE to APIs and addition of 2 new fields    *
      *           on ICD.
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. SRSETUP -   Move fields to valid file                  *
      *     2. *PSSR   -   Database Error Handling                    *
      *     3. END     -   Leave program                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *---------------------------------------------------------------*
      *---------------------------------------------------------------*
      *****************************************************************
      *
      ** Files needed for field validation
 
     FBYINDRV0  IF   E           K DISK
      * Industry Code selection program.
 
     FBYINSTV0  IF   E           K DISK
      * Institution Code selection program.
      *
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
     D @EI             S              1    DIM(11)
 
      *** Datastructure to define input parameter DATA
      /COPY QWINDSRC,SDCUSDDTA
 
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs, Short data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs, Long data structure.
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for Country Details
 
      * DS to define layout of data area BYSTAT                                     LLN018
     D BYSTAT        E DS                  EXTNAME(BYSTATPP)                        LLN018
 
      ** New Deal in File Format (V)
     D*NwCuFilFmt****E DS                  EXTNAME(SDVCUSDX0)                                BUG8497
     D NwCuFilFmt    E DS                  EXTNAME(SDVCUSDPE)                                BUG8497
 
      ** New Deal in Screen Format (#S)
     D NwCuScnFmt    E DS                  EXTNAME(SDCUEXPD)
     D                                     PREFIX(#S)
 
      ** Error indicators (OK#S)
     D*OkFlags*******E DS                  EXTNAME(SDECUSDX0)                                BUG8497
     D OkFlags       E DS                  EXTNAME(SDECUSDPE)                                BUG8497
 
      **   Declared variables
      **   ==================
      **
 
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D TITLE           S              7
 
      ** Define *entry parameters
 
 
 
     D Idx             S              3P 0                                      Index error array
     D WIdx            S              3P 0                                      Index warning array
 
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1            Action Code
     C                   PARM                    DATA                           Action Code
     C                   PARM                    CallMod           3            Data from deal
     C                   PARM                    NwCuScnFmt                     New deal screen form
     C                   PARM                    OKFlags                        Field OK Flags
     C                   PARM                    FldNameArr                     Errors fields
     C                   PARM                    MsgIDArr                         ""
     C                   PARM                    MsgDtaArr                        ""
     C                   PARM                    Idx                            Error array index
     C                   PARM                    WFldNamArr                     Warnings fields
     C                   PARM                    WMsgIDArr                        ""
     C                   PARM                    WMsgDtaArr                       ""
     C                   PARM                    WIdx                           Warning array index
     C                   PARM                    NwCuFilFmt                     New deal file format
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALIDATE THE SCREEN
      *****************************************************************
      *
     C                   MOVE      *BLANKS       VALID             1
      *                                                                     204195
      ** Define the BYSTAT Dtaara                                           204195
     C     *Dtaara       Define                  BYSTAT                     204195
      *                                                                     204195
      *  Get values from BYSTAT data area                                   204195
     C                   IN        BYSTAT                                   204195
      *                                                                     204195
      * If program is being called from the CTL module, on an Insert &      204195
      * incoming data is blank then default so that record does not         204195
      * fail validation.                                                    204195
      * Also if called from RPR module.
     C     CallMod       IFEQ      'CTL'                                    204195
     C     CallMod       OREQ      'RPR'                                    204195
     C     ACTN          IFEQ      'I'                                      204195
     C     ACTN          OREQ      'A'                                      204195
     C     #SSIOF        IFEQ      ' '                                      204195
     C     #SUPAR        ANDEQ     ' '                                      204195
     C     #SHASI        ANDEQ     ' '                                      204195
     C     #SELGF        ANDEQ     ' '                                      204195
     C     #SCNTP        ANDEQ     ' '                                      204195
     C     #SLINC        ANDEQ     *BLANKS
     C     #SLICD        ANDEQ     *BLANKS
      *                                                                     204195
      * Set Housing Association indicator to be N                           204195
     C                   MOVE      'N'           #SHASI                     204195
      *                                                                     204195
      * Set Eligibility Flag to be N                                        204195
     C                   MOVE      'N'           #SELGF                     204195
      *                                                                     204195
      * Set Connected Counterparty flag to be N                             204195
     C                   MOVE      'N'           #SCNTP                     204195
      *                                                                     204195
      * If Default Local Industry Code Flag is Y on BoE ICD,                        LLN018
      * move in value on SDCUSTPD.                                                  LLN018
     C     LDICD         IFEQ      'Y'                                              LLN018
     C***                MOVEL     ULLICD        #SLICD                             LLN018LLN020
     C                   MOVEL     BYLICD        #SLICD                             LLN020
     C                   ENDIF                                                      LLN018
      *                                                                             LLN018
      * If Default Local Institution Code Flag is Y on BoE ICD,                     LLN018
      * move in value on SDCUSTPD.                                                  LLN018
     C     LDINC         IFEQ      'Y'                                              LLN018
     C***                MOVEL     ULLINC        #SLINC                       LLN018LLN020
     C                   MOVEL     BYLINC        #SLINC                             LLN020
     C                   ENDIF                                                      LLN018
      *                                                                     204195
     C                   ENDIF                                              204195
     C                   ENDIF                                              204195
     C                   ENDIF                                              204195
      *                                                                     204195
      ** Get ISO code for country of location
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       RTNCDE
     C                   PARM      '*KEY   '     OPTION
     C***                PARM      ULCOLC        P@KEY                                        LLN020
     C                   PARM      BYCOLC        P@KEY                                        LLN020
     C     SDCTRY        PARM      *Blanks       DSSDY
      *
      *
      *----------------------------------------------------------------
      ** SIO code must be E, I or U if entered.
     C     #SSIOF        IfNe      *Blanks
     C     #SSIOF        AndNe     'E'
     C     #SSIOF        AndNe     'I'
     C     #SSIOF        AndNe     'U'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SSIOF'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0030'
     C                   EVAL      ReturnCode = 'Error'
 
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SIOIndOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   EndIf
      *
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Housing Association Flag
     C     #SHASI        IfEq      'Y'
     C     #SLICD        IfNe      '101'
     C     #SLINC        OrNe      '81'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SHASI'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0091'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    HouseAssOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
     C                   EndIf
     C                   EndIf
 
      ** Valid values are Y or N
     C     #SHASI        IfNe      'Y'
     C     #SHASI        AndNe     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SHASI'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0092'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    HouseAssOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   EndIf
      *
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Ultimate parent
     C     #SUPAR        IfNe      *Blanks
      *
      *   Must be valid customer if entered
     C                   Call      'AOCUSTR0'                             99
     C     RTNCDE        PARM      '*VERIFY'     RTNCDE            7
     C                   PARM      '*KEY'        OPTION            7
     C                   PARM      #SUPAR        P@KEY            10
     C                   PARM                    P@KYST            7
     C     SDCUST        PARM      *Blanks       DSSDY
 
     C     RTNCDE        IfEq      '*NRF'
     C     *IN99         OrEq      *ON
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SUPAR'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0090'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    UltParOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   EndIf
 
     C     #SUPAR        IfEq      '?'
     C                   Move      BBCUST        #SUPAR
     C                   Move      'Y'           RedScreen
     C                   EndIf
 
     C                   EndIf
 
 
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      ** Validate Eligibility flag
     C     #SELGF        IfNe      'Y'
     C     #SELGF        AndNe     'N'
     C     #SELGF        AndNe     ' '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SELGF'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0093'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    EligFlgOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   EndIf
 
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      * Bank of England Institution Code
 
      * If '?' is entered call the selection program and redisplay
      * detail screen with selected value.
     C     #SLINC        IfEq      '?'
     C                   Call      'BY9230'
     C                   Parm                    P0RTN             7
     C                   Parm      *Blanks       P1INSC            2
      *
     C                   MoveL     P1INSC        #SLINC
     C                   Move      'Y'           RedScreen
     C                   EndIf
 
     C*****#SLINC        Ifne      *Blanks                                             202030 203458
     C                   Move      #SLINC        ULLINS            2 0
     C     ULLINS        Chain     BYINSTV0                           89
     C     *IN89         IfEq      *On
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SLINC'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0053'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    InstCodeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   Else
 
      ** Customer is UK Res. but Institution code not for UK Res.
     C*****A4ISOC        IFEQ      'GB'                                                       LLN022
     C*****BYCOLC        IFEQ      'GB'                                              LLN022 AR665308
     C     A4ISOC        IFEQ      'GB'                                                     AR665308
     C     LAUKRI        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SLINC'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0070'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    InstCodeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
      ** Customer is non-UK Res. but Inst. code not for non-UK Res.
     C*****A4ISOC        IFNE      'GB'                                                       LLN022
     C*****BYCOLC        IFNE      'GB'                                              LLN022 AR665308
     C     A4ISOC        IFNE      'GB'                                                     AR665308
     C     LAUKRI        ANDNE     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SLINC'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0071'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    InstCodeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
     C**********         ENDIF                                                         202030 203458
 
     C                   EndIf
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      * Bank of England Industry Code
 
      ** Industry code must be entered for UK non-monetary sector
     C     LAUKMI        IFEQ      'N'
     C     LAUKRI        ANDEQ     'Y'
     C     #SLICD        ANDEQ     *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SLICD'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0072'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    IndCodeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
      * If '?' is entered call the selection program and redisplay
      * detail screen with selected value.
     C     #SLICD        IfEq      '?'
     C                   Call      'BY9240'
     C                   Parm                    P0RTN             7
     C                   Parm      *Blanks       P1INDC            3
      *
     C                   MoveL     P1INDC        #SLICD
     C                   Move      'Y'           RedScreen
     C                   EndIf
 
     C     #SLICD        IfNe      *Blanks
     C*****#SLICD        AndNe     '?'
     C     #SLICD        Chain     BYINDRV0                           89
     C     *IN89         IfEq      *On
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SLICD'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0073'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    IndCodeOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   EndIf
     C                   EndIf
 
 
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      **  Validate Connected Counterparty
     C     #SCNTP        IfNe      'Y'
     C     #SCNTP        AndNe     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#SCNTP'
     C                   EVAL      MsgIDArr(Idx) = 'BYM0205'
     C                   EVAL      ReturnCode = 'Error'
      *
      ** Use the return code's value to set the field's OK flag
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    ConCntOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   EndIf
 
      *----------------------------------------------------------------
      *----------------------------------------------------------------
 
     C*******************IF        Idx = 0                                          204195
     C     Idx           IFEQ      0                                                204195
     C     CallMod       OREQ      'RPR'                                            204195
     C                   EXSR      SRSETUP
     C                   ENDIF                                                      204195
      *
 
     C                   EXSR      END
 
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUP - Set up fields that are needed on the Valid file     *
      *           record.                                             *
      *                                                               *
      *****************************************************************
     C     SRSETUP       BEGSR
      *
     C                   MOVE      #SSIOF        LVSIOF
     C                   MOVE      #SHASI        LVHASI
     C                   MOVE      #SUPAR        LVUPAR
     C                   MOVE      #SELGF        LVELGF
     C                   MOVE      #SLINC        LVLINC
     C                   MOVE      #SLICD        LVLICD
     C                   MOVE      #SCNTP        LVCNTP
      *
      **If*this*module*has*been called from the CTL module then if            LLN018204195
      **Industry*Code*or*Institution Code is blank and BYSTAT is set          LLN018204195
      **to*default*the*field to the value on the main customer screen         LLN018204195
      **then*do*this*defaulting.                                              LLN018204195
     C*****CallMod       IFEQ      'CTL'                                      LLN018204195
      *****                                                                   LLN018204195
      **If*Default*Local Industry Code Flag is Y on BoE ICD,                  LLN018204195
      **and*Industry*Code on extra data is blank, move in value on SDCUSTPD.  LLN018204195
     C*****LDICD         IFEQ      'Y'                                        LLN018204195
     C*****#SLICD        ANDEQ     *BLANK                                     LLN018204195
     C*****              MOVEL     ULLICD        LVLICD                       LLN018204195
     C*****              ENDIF                                                LLN018204195
      *****                                                                   LLN018204195
      **If*Default Local Institution Code Flag is Y on BoE ICD, then          LLN018204195
      **and Instit Code in extra data is Blank, move in value on SDCUSTPD.    LLN018204195
     C*****LDINC         IFEQ      'Y'                                        LLN018204195
     C*****#SLINC        ANDEQ     *BLANKS                                    LLN018204195
     C*****              MOVEL     ULLINC        LVLINC                       LLN018204195
     C*****              ENDIF                                                LLN018204195
      *****                                                                   LLN018204195
     C*****              ENDIF                                                LLN018204195
 
     C                   ENDSR
      **********************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END   - End Program, no errors                               *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR                                                              **
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
