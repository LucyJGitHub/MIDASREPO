     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate debit charges and customer ref')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCSRF  - Validate Charges To The Debit Of and Debit        *
      *             Customer Reference                                *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT157             Date 29Aug14               *
      *                 MD021128           Date 01Jul13               *
      *                 AR1097264          Date 27Mar13               *
      *                 AR1080200          Date 24Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT145             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255428             Date 04Dec08               *
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 247142             Date 31May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244936             Date 17Apr07               *
      *                 244260             Date 12Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 240689             Date 29Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4321            Date 28Sep04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 09Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  MD021128 - Unexpected warning message displayed for Charges  *
      *             to the Debit of A/C                               *
      *  AR1097264 - Field validation that if charge to debit of      *
      *              account is filled and the field CDRO ccy is not  *
      *              filled, CDRO ccy will be defaulted to the base   *
      *              ccy of the bank                                  *
      *  AR1080200 - In Charge details 2 tab, charges on the left and *
      *              right hand side of the screen is incorrect       *
      *            - Partially applied fix 222568                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CFT145 - FT IN/OP - Charges to the Debit of Account          *
      *           Validation                                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  255428 - Apply client fix 255930                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654. Annotated as 240689  *
      *  232151 - DBASE error when inserting an inactive account.     *
      *           Annotated as 240689.                                *
      *  244936 - Charges to Debit A/c Of should be defaulted to blank*
      *  244260 - Error if alpha customer number in partial account.  *
      *           Partly applied fix 242926.                          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4321- Sender's charges error msg error                    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)

     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMAF)

      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      * External DS for Midas SD Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)

      ** External data structure for Nostro customer number
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
                                                                                              187056
      ** External data structure for Funds Transfer ICD Details                               187056
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                                  187056
      *                                                                                       CFT120
      ** External DS for Currency details                                                     CFT120
      *                                                                                       CFT120
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CFT120
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120

      *                                                                                       CFT145
      ** External DS for Accounts file                                                        CFT145
      *                                                                                       CFT145
     D ACCNTDS       E DS                  EXTNAME(ACCNTAB)                                   CFT145
     D  QCCYXX       E                     EXTFLD(CCY)                                        CFT145
     D  QLCDXX       E                     EXTFLD(LCD)                                        CFT145
      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CFT145
      ** External data structure for access programs (Long)                                   CFT145
      *                                                                                       CFT145
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CFT145

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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **********************************************************************
      /EJECT                                                               *
      **********************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D LWRC            C                   'abcdefghijklmnopqrstuvwxyz'                       CFT120

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      *                                                                                       240689
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     240689
      *                                                                                       240689
      ** Array of fields with Warning.                                                        240689
      *                                                                                       240689
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        240689
      *                                                                                       240689
      ** Array of Warning message IDs                                                         240689
      *                                                                                       240689
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      240689
      *                                                                                       240689
      ** Array of Warning message data.                                                       240689
      *                                                                                       240689

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInSecA****E*DS***               EXTNAME(FTOPY2PD)                    CFT014
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014

      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

     D**********       DS            18                                                       CGL029
     D                 DS                                                                     CGL029
     D*K#CNUM***               1      6  0                                                    CSD027
     D K#CNUM                  1      6A                                                      CSD027
     D K#BCCY                  7      9
     D K#ACOD                 10     19  0                                                    CGL029
     D K#ACSQ                 20     21  0                                                    CGL029
     D K#BRCA                 22     24                                                       CGL029
     D AKEYF                   1     24                                                       CGL029
     D*K#ACOD***              10     13  0                                                    CGL029
     D*K#ACSQ***              14     15  0                                                    CGL029
     D*K#BRCA***              16     18                                                       CGL029
     D*AKEYF****               1     18                                                       CGL029

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D/COPY FTCPYSRC,SFTVALCSLE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                       240689
     D WIx             S              3P 0                                                    240689
      *                                                                                       240689
      ** Index for arrays of warning message ids etc.                                         240689
      *                                                                                       240689

     D K#RENO          S             10  0

     D*C#ACCD***       S              4                                                       CGL029
     D C#ACCD          S             10                                                       CGL029
     D C#ACSN          S              2
     D C#BRCA          S              3
     D C#CSSN          S             10
     D C#CUST          S              6
     D C#CYCD          S              3
     D C#NONB          S              2
     D C#OPTN          S              7
     D C#PNOI          S              1
     D C#RTCD          S              7

     D*WACCS****       S              6                                                       CGL029
     D*WCDRO13**       S             13                                                       CGL029
     D WACCS           S             12                                                       CGL029
     D WCDRO13         S             19                                                       CGL029
     D WDATE           S              5  0
     D Ccy             S              3A                                                      CFT120
     D CFT120          S              1A                                                      CFT120

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C*                  Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtaXAr = *Blanks                                       240689
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                    240689
      *                                                                                       CFT120
      ** Set upper case characters                                                            CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Eval      SCDRO  = %Xlate(LWRC: ALPHAB: SCDRO)                       CFT120
     C                   ENDIF                                                                CFT120

      * Validate
      *
     C                   Exsr      VDBTCC

      ** If an error was found, set the return code appropriately
      *
     C                   If        OKCdro = 'N' or
     C                             OKCdBr = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKCdro = 'W' or                                            CSD089
     C                             OKCdBr = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End

      * RETURN

     C                   RETURN
      ******************************************************************
      /EJECT
     C**********************************************************************
     C* VDBTCC  -  Validation of Charges to the Debit & Debit Cust Ref     *
     C**********************************************************************
     C*
     C     VDBTCC        BEGSR

      *  Charges To The Debit of A/C is optional.
      *  3 formats acceptable - Nostro, Retail A/C, A/C No.
                                                                                CFT014
     C*******************Eval      @CDRO = *Zero                                CFT014        244936
     C                   Eval      @CDRO = *Blank                                             244936
     C                   Eval      @CDRT = *Blank                               CFT014
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      @CDRC = *BLANKS                                            CFT120
     C                   ENDIF                                                                CFT120

      *  If blank and branch entered error
     C                   If        SCDRO  = *Blanks and
     C                             SCDBR <> *Blanks
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1026'     MsgIdXAr(Idx)
     C                   End
      *                                                                                       CFT120
      ** Currency entered but no CDRO                                                         CFT120
      *                                                                                       CFT120
     C                   IF        OKCdro = 'Y' AND CFT120 = 'Y'                              CFT120
     C                   IF        SCDRC   <> *Blanks  And                                    CFT120
     C                             SCDRO   =  *Blanks                                         CFT120
     C                   EVAL      OkCdro = 'N'                                               CFT120
     C                   EVAL      OkCdrc = 'N'                                               CFT120
     C                   EVAL      Idx = Idx + 1                                              CFT120
     C                   EVAL      FldNamXAr(Idx) = 'SCDRO'                                   CFT120
     C                   EVAL      MsgIdXAr(Idx) = 'FTM7100'                                  CFT120
     C                   EVAL      RetCodeIn = 'Error'                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** Currency entered but invalid currency                                                CFT120
      *                                                                                       CFT120
                                                                                              CFT120
     C                   IF        OKCdro = 'Y' AND CFT120 = 'Y'                              CFT120
     C                   IF        SCDRC   <> *BLANKS                                         CFT120
      *                                                                                       CFT120
      ** If entered, Charges currency must be valid on the system                             CFT120
      *                                                                                       CFT120
     C                   CALL      'AOCURRR0'                                                 CFT120
     C                   PARM      *Blanks       @RTCD                                        CFT120
     C                   PARM      '*KEY'        @OPTN                                        CFT120
     C                   PARM      SCDRC         Ccy                                          CFT120
     C     SDCURR        PARM      SDCURR        DSSDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD <> *BLANKS                                           CFT120
     C                   EVAL      OkCdro = 'N'                                               CFT120
     C                   EVAL      OkCdrc = 'N'                                               CFT120
     C                   EVAL      Idx = Idx + 1                                              CFT120
     C                   EVAL      FldNamXAr(Idx) = 'SCDRC'                                   CFT120
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3255'                                  CFT120
     C                   EVAL      RetCodeIn = 'Error'                                        CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120

      * Field is optional, ignore if blank
     C                   If        SCDRO <> *Blanks
      * If Add/deduct indicator is 'D' and Details of charges is 'BEN',                       255428
      * then field SCDRO should be blank.                                                     255428
     C     SADDC         IFEQ      'D'                                                        255428
     C     SDTCH         ANDEQ     'BEN'                                                      255428
     C     SCDRO         ANDNE     *BLANKS                                                    255428
     C                   MOVE      'N'           OKCdro                                       255428
     C                   MOVE      'N'           OKCdbr                                       255428
     C                   ADD       1             Idx                                          255428
     C                   MOVEL     'SCDRO'       FldNamXAr(Idx)                               255428
     C                   MOVEL     'FTM5052'     MsgIDXAr(Idx)                                255428
     C                   ENDIF                                                                255428

      * No error
     C                   If        OKCdro = 'Y'

      *  ? not allowed
     C     '?'           Scan      SCDRO         Y#                       90
      *
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1027'     MsgIdXAr(Idx)
     C                   End

     C                   End

      * No error
     C                   BITOFF    '01234567'    WRETB             1                          240689
     C                   If        OKCdro = 'Y'

      *  Determine the number of digits in the field
      *
      *  Check first two characters are numeric and rest is blank
      *
     C                   Movel(P)  SCDRO         WCDRO13
     C     DIGITS        Check     WCDRO13       Y#                3 0    90
      *                                                                                       244260
     C     Y#            IFNE      3                                                          244260
     C     Y#            ANDNE     11                                                         244260
     C     ALPHAN        Check     WCDRO13       Y#                3 0    90                  244260
     C                   ENDIF                                                                244260
      *
      ***2,*10*and*12*digits*allowed***********************************                       CFT120
      *                                                                                       CFT120
      ** 2, 10 and 18 digits allowed                                                          CFT120
      *
     C                   If        *IN90 = *ON

     C                   If        Y# = 3 or
     C                             Y# = 11 or
     C**********                   Y# = 13 and                                                CGL029
     C                             Y# = 19 and                                                CGL029
     C                             SCDBR <> *Blanks and
     C                             @MBIN = 'Y' or
     C**********                   Y# = 13 and                                                CGL029
     C                             Y# = 19 and                                                CGL029
     C                             @MBIN <> 'Y'
     C                   Eval      *IN90 = *Off
     C                   End

     C                   End

      *  Field is invalid format
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1028'     MsgIdXAr(Idx)
     C                   End

     C                   End

      * No error
     C                   If        OKCdro = 'Y'

      *  If 10 digits and Retail accounts not used error
     C                   If        BMRANR <> 'Y' and
     C                             Y# = 11 and
     C                             SCDBR = *Blanks
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1029'     MsgIdXAr(Idx)
     C                   End

     C                   End

      * No error
     C                   If        OKCdro = 'Y'

      *  Check if a 2 digit Nostro code has been entered - based on
      *  no. of blanks found in field
     C                   If        Y# = 3 and
     C                             SCDBR = *Blanks

      *  Validate Nostro Code
     C                   Movel     SCDRO         C#NONB
     C                   IF        SCDRC   =  *BLANKS AND CFT120 = 'Y'                        CFT120
     C                             OR CFT120 <> 'Y'                                           CFT120
     C                   Eval      C#CYCD  =  BJCYCD                                          CFT120
     C                   ELSE                                                                 CFT120
     C                   Eval      C#CYCD  =  SCDRC                                           CFT120
     C                   ENDIF                                                                CFT120

      * Read SDNOSTPD for customer number
     C                   CALLB     'AONOSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      *Blanks       C#CUST
     C**********         Parm      BJCYCD        C#CYCD                                       CFT120
     C                   Parm                    C#CYCD                                       CFT120
     C                   Parm      *Blanks       C#ACCD
     C                   Parm      *Blanks       C#ACSN
     C                   Parm                    C#NONB
     C                   Parm      *Blanks       C#BRCA
     C                   Parm      *Blanks       C#CSSN
     C                   Parm      *Blanks       C#PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
      *
      *  If error on call
     C                   If        C#RTCD <> *Blanks
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     'FTM7101'     MsgIdXAr(Idx)                                CFT120
     C                   ELSE                                                                 CFT120
     C                   Movel     'MMA1030'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   Else
      * Move new SYNON field names to old field names
     C                   Move      A7CUST        K#CNUM
     C                   Move      A7ACCD        K#ACOD
     C                   Move      A7ACSN        K#ACSQ
     C                   Move      A7BRCD        K#BRCA
     C                   MOVE      A7CUST        WWCDCN            6                          CFT145

     C                   IF        SCDRC   =  *BLANKS AND CFT120 = 'Y'                        CFT120
     C                             OR CFT120 <> 'Y'                                           CFT120
     C                   Eval      K#BCCY = BJCYCD
     C                   ELSE                                                                 CFT120
     C                   EVAL      K#BCCY  =  SCDRC                                           CFT120
     C                   ENDIF                                                                CFT120
      *  Access Full Account Details for later validation
     C     AKEY          CHAIN     ACCNTABF                           90
      *
     C                   If        *IN90 = *On or
     C                             RECI <> 'D'
     C                   Move      'FTVCSRF'     DBPGM
     C                   Move      'ACCNT  '     DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     AKEYF         DBKEY
     C                   Exsr      *PSSR
     C                   ELSE                                                                 240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                    AR1097264
     C                   IF        SCDRC = *BLANKS AND CFT120 = 'Y'                        AR1097264
     C                   EVAL      SCDRC = K#BCCY                                          AR1097264
     C                   ENDIF                                                             AR1097264
      *                                                                                    AR1097264
     C                   End
      *
     C                   End
     C                   End
     C                   End

      * No error
     C                   If        OKCdro = 'Y'

      *  Check for Retail Account No. being entered
      *  only if Debit Customer reference is not entered OR
      *  multibranching is not active.
     C**********         If        Y# = 11 and                                               BUG4321
     C**********                   SCDBR = *Blanks                                           BUG4321
     C                   If        Y# = 11                                                   BUG4321

     C                   Movel     SCDRO         K#RENO
     C     K#RENO        Chain     ACNUMAF                            90
      *
      * Error if not found or RECI <> D
     C                   If        *IN90 = *ON or
     C                             RECI <> 'D'
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1031'     MsgIdXAr(Idx)

     C                   Else
     C                   MOVEL     CNUM          WWCDCN            6                          CFT145
      *                                                                                       CFT120
      ** If charges currency not same as currency of account specified                        CFT120
      *                                                                                       CFT120
     C                   IF        SCDRC <> *BLANKS AND                                       CFT120
     C                             CCY   <> SCDRC AND CFT120 = 'Y'                            CFT120
      *                                                                                       CFT120
      ** Send error to screen                                                                 CFT120
      *                                                                                       CFT120
     C                   MOVE      'N'           OKCdro                                       CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ADD       1             Idx                                          CFT120
     C                   MOVEL     'SCDRC'       FldNamXAr(Idx)                               CFT120
     C                   MOVEL     'FTM7104'     MsgIdXAr(Idx)                                CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   MOVE      RETB          WRETB                                        240689
     C                   Eval      @CCY = CCY
      *  A/C Currency must be base currency
      *  if charges currency not specified                                                    CFT120
     C                   If        @CCY <> BJCYCD
     C                             AND CFT120 <> 'Y' OR                                       CFT120
     C                             SCDRC = *Blanks AND CFT120 = 'Y'                           CFT120
     C                             AND @CCY <> BJCYCD                                         CFT120
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1036'     MsgIdXAr(Idx)
      *                                                                                    AR1097264
     C                   ELSE                                                              AR1097264
     C                   IF        CFT120 = 'Y' AND SCDRC = *BLANKS                        AR1097264
     C                   EVAL      SCDRC = @CCY                                            AR1097264
     C                   ENDIF                                                             AR1097264
      *                                                                                    AR1097264
     C                   End
      *                                                                                      BUG4321
      *  If branch entered it must be the same as the retail a/c branch                      BUG4321
     C                   Move      'Y'           RetailAc          1                         BUG4321
     C                   If        SCDBR <> *Blanks and                                      BUG4321
     C                             SCDBR <> BRCA                                             BUG4321
      * Send error to screen                                                                 BUG4321
     C                   Move      'N'           RetailAc                                    BUG4321
     C                   Move      'N'           OKCdro                                      BUG4321
     C                   Move      'N'           OKCdBr                                      BUG4321
     C                   Add       1             Idx                                         BUG4321
     C                   Movel     'SCDRO'       FldNamXAr(Idx)                              BUG4321
     C                   Movel     'MMA1315'     MsgIdXAr(Idx)                               BUG4321
     C                   End                                                                 BUG4321
      *
     C                   End
     C                   End
     C                   End
     C                   ENDIF                                                                CFT120

      * No error
      * ... and no valid retail account found                                                BUG4321
     C                   If        OKCdro = 'Y'
     C                             and RetailAc <> 'Y'                                       BUG4321

      *  Validate for G/L Account No.
      *  If 12 digits when combined with base currency must exist
      *  on PF/ACCNTAB
      *  unless combined with Charges DR Of Currency if used                                  CFT120
     C**********         If               Y# = 13 or                                          CGL029
     C                   If               Y# = 19 or                                          CGL029
     C                                    SCDBR <> *Blanks

     C                   Movel     SCDRO         K#CNUM
     C                   MOVEL     SCDRO         WWCDCN            6                          CFT145
     C                   IF        SCDRC   =  *BLANKS AND CFT120 = 'Y'                        CFT120
     C                             OR CFT120 <> 'Y'                                           CFT120
     C                   Eval      K#BCCY = BJCYCD
     C                   ELSE                                                                 CFT120
     C                   EVAL      K#BCCY  =  SCDRC                                           CFT120
     C                   ENDIF                                                                CFT120
     C                   Move      SCDRO         WACCS
     C                   Movel     WACCS         K#ACOD
     C                   Move      WACCS         K#ACSQ
      *
      * If multibranched use screen branch else use passed branch
     C                   If        @MBIN = 'Y'
     C                   Movel     SCDBR         K#BRCA
     C                   Else
     C                   Movel     BJSBRC        K#BRCA
     C                   End

     C     AKEY          Chain     ACCNTABF                           90
      * Error if not found or RECI <> D
     C                   If        *IN90 = *ON or
     C                             RECI <> 'D'
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Movel     'FTM7103'     MsgIdXAr(Idx)                                CFT120
     C                   ELSE                                                                 CFT120
     C                   Movel     'MMA1032'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CFT120
     C                   ELSE                                                                 240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                    AR1097264
     C                   IF        SCDRC = *BLANKS AND CFT120 = 'Y'                        AR1097264
     C                   EVAL      SCDRC = K#BCCY                                          AR1097264
     C                   ENDIF                                                             AR1097264
      *                                                                                    AR1097264
     C                   End

     C                   End
     C                   End

      * No error
     C                   If        OKCdro = 'Y'

      *  If 'Charges To The Debit Of is entered then
      *  check if date is in the future and if the account is
      *  closing today
     C                   If        SADDC = 'A'
     C                   Eval      WDATE = @SLDT
     C                   Else
     C                   Eval      WDATE = @PVDT
     C                   End

     C                   If        WDATE > BJRDNB and
     C                             ACST = 'C'
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   Add       1             Idx
     C                   IF        SCDRC <> *Blanks AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1033'     MsgIdXAr(Idx)
     C                   End

      *  Check not past backvalue period
      *                                                                                       CFT120
      ** If OP Template validation, this date will be zero                                    CFT120
     C                   If        WDATE <> 0 AND CFT120 = 'Y' OR CFT120 <> 'Y'               CFT120
     C                   If        WDATE < @BVLD
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1034'     MsgIdXAr(Idx)
     C                   End
     C                   ENDIF                                                                CFT120

      *  For Retail accounts only, check that the
      *  earlier of the two value dates is not before the Backvalue
      *  Limit Date nor before the account was opened
     C                   If        ATYP = 'R' and
     C                             WDATE < DACO
     C                             AND CFT120 <> 'Y'                                       AR1097264
     C                             OR  CFT120 = 'Y' AND ATYP = 'R'                         AR1097264
     C                             AND WDATE <> 0 AND WDATE < DACO                         AR1097264
      * Send error to screen
     C                   Move      'N'           OKCdro
     C                   Move      'N'           OKCdBr
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   Add       1             Idx
     C                   Movel     'SCDRO'       FldNamXAr(Idx)
     C                   Movel     'MMA1035'     MsgIdXAr(Idx)
     C                   End

     C                   End

      *  If no errors then set file fields
     C                   If        OKCdro = 'Y'

     C                   Select
     C                   When      Y# = 3
     C                   Movel     'N'           @CDRT
     C                   When      Y# = 11
     C                   Movel     'R'           @CDRT
     C**********         When      Y# = 13                                                    CGL029
     C                   When      Y# = 19                                                    CGL029
     C                   Movel     'P'           @CDRT

     C                   End
      *
     C                   Movel     SCDRO         @CDRO
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     SCDRC         @CDRC                                        CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   End
     C                   End
      *
      ** If valid set up @RCCY
     C                   If        OKCdro = 'Y'
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C     SCDRO         IFNE      *BLANKS                                                    240689
      *                                                                                       240689
      ** Blocked Debit                                                                        240689
      *                                                                                       240689
     C                   TESTB     '2'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKCdro                                240689 CSD089
     C**********         MOVE      'N'           OKCdbr                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SCDRO'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0014'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKCdro                                       CSD089
     C                   MOVE      'W'           OKCdbr                                       CSD089
     C                   IF        SCDRC <> *Blanks AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SCDRO'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0014'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKCdro                                240689 CSD089
     C**********         MOVE      'N'           OKCdbr                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SCDRO'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0015'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKCdro                                       CSD089
     C                   MOVE      'W'           OKCdbr                                       CSD089
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SCDRO'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0015'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKCdro                                240689 CSD089
     C**********         MOVE      'N'           OKCdbr                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SCDRO'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0016'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKCdro                                       CSD089
     C                   MOVE      'W'           OKCdbr                                       CSD089
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SCDRO'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0016'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKCdro                                       240689
     C                   MOVE      'N'           OKCdbr                                       240689
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SCDRO'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Debit                                                                       240689
      *                                                                                       240689
     C                   TESTB     '0'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKCdro                                       240689
     C                   MOVE      'N'           OKCdbr                                       240689
     C                   IF        SCDRC <> *BLANKS AND CFT120 = 'Y'                          CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SCDRO'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0018'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689

     C                   SELECT
      *
     C     SCDRO         WHENNE    *BLANKS
     C                   IF        SCDRC = *BLANKS AND CFT120 = 'Y'                           CFT120
     C                             OR CFT120 <> 'Y'                                           CFT120
     C                   MOVEL     BJCYCD        @RCCY
     C                   ELSE                                                                 CFT120
     C                   MOVEL     SCDRC         @RCCY                                        CFT120
     C                   ENDIF                                                                CFT120
      *
     C     SADDC         WHENEQ    'A'
     C                   MOVEL     SSMCY         @RCCY
      *
     C                   OTHER
     C                   MOVEL     SPCCY         @RCCY
     C                   ENDSL
                                                                                              187056
     C                   SELECT                                                               187056
     C                   WHEN      BTCHCY = 'B' OR SCDRO <> *BLANKS                           187056
     C**********                   AND CFT120 = 'N'                                 CFT120 AR1080200
     C                             AND CFT120 = 'N' AND BTCHCY = 'C'                       AR1080200
     C                   EVAL      @CCCY = BJCYCD                                             187056
     C                   WHEN      CFT120 = 'Y' AND SCDRO <> *BLANKS                       AR1080200
     C                             AND BTCHCY = 'C'                                        AR1080200
     C                   EVAL      @CCCY = SCDRC                                           AR1080200
     C                   WHEN      BTCHCY = 'L'                                               187056
     C                   EVAL      @CCCY = BJLCCY                                             187056
     C                   WHEN      BTCHCY = 'C' AND SADDC = 'A'                               187056
     C                   EVAL      @CCCY = SSMCY                                              187056
     C                   WHEN      BTCHCY = 'F'                                               CFT009
     C                   EVAL      @CCCY = FCHCCY                                             CFT009
     C                   OTHER                                                                187056
     C                   EVAL      @CCCY = SPCCY                                              187056
     C                   ENDSL                                                                187056

     C                   End
      *                                                                                       CFT145
      ** Additional validation CDRO                                                           CFT145
      *                                                                                       CFT145
     C                   IF        OKCdro = 'Y' AND                                           CFT145
     C                             SCDRO <> *blanks                                           CFT145
      *                                                                                       CFT145
      ** If coming from OT SSI template, @Orbt will be blank on entry                      AR1097264
      *                                                                                    AR1097264
     C                                                                                     AR1097264
     C                   IF        @Orbt = ' '                                             AR1097264
     C                             AND @Orbds <> *BLANKS                                    MD021128
     C                   EVAL      @Orbt = @CDRT                                           AR1097264
     C                   ENDIF                                                             AR1097264
      *                                                                                    AR1097264
     C                   SELECT                                                               CFT145
     C                   WHEN      @Orbt =  'R' Or                                            CFT145
     C                             @Orbt =  'P' Or                                            CFT145
     C                             @Orbt =  'N'                                               CFT145
     C                   MOVEL     @Orbds        WWODCN            6                          CFT145
      *                                                                                       CFT145
     C                   WHEN      @Orct =  'R'                                               CFT145
     C                   CALL      'AOACCTV1'                                                 CFT145
     C                   PARM      *Blanks       @RtCd                                        CFT145
     C                   PARM      *Blanks       P@Typ            10                          CFT145
     C                   PARM      SORC1         P@Str            35                          CFT145
     C     ACCNTDS       PARM      *Blanks       DSSDY                                        CFT145
     C                   IF        @RtCd = *Blanks                                            CFT145
     C                   MOVE      CNUM          WWODCN            6                          CFT145
     C                   ENDIF                                                                CFT145
      *                                                                                       CFT145
     C                   WHEN      @Orct =  'P'                                               CFT145
     C                   MOVEL     SORC1         WWODCN            6                          CFT145
     C                   ENDSL                                                                CFT145
      *                                                                                       CFT145
      ** Warning - if Ordering Bank or Customer is not customer of CDRO account               CFT145
      *                                                                                       CFT145
     C                   IF        WWCDCN <> WWODCN                                           CFT145
     C                   MOVE      'N'           OKCdro                                       CFT145
     C                   ADD       1             WIx                                          CFT145
     C                   MOVEL     'SCDRO'       WFldNmXAr(WIx)                               CFT145
     C                   MOVEL     'FTX0023'     WMsgIdXAr(WIx)                               CFT145
     C                   ENDIF                                                                CFT145
     C                   ENDIF                                                                CFT145

     C                   ENDSR
     C*
     C************************************************************
     C* END OF VALIDATION
     C************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn

      *  Screen fields
     C                   Parm                    TranInPrim
     C***********        Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInFour                     CFT014

      *  Program Fields
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Read SDRETLPD for retail details
      *  (database error handling done in access program)
      * Only if RETAIL switched on.
     C                   If        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDRETL        Parm      SDRETL        DSFDY
     C                   End
      *                                                                                       187056
      ** Access FT ICD Details                                                                187056
      *                                                                                       187056
     C                   CALL      'AOFTFRR0'                                                 187056
     C                   Parm      *BLANKS       @RTCD                                        187056
     C                   Parm      '*FIRST'      @OPTN                                        187056
     C     SDFTFR        Parm      SDFTFR        DSFDY                                        187056
      *                                                                                       187056
      * DATABASE ERROR                                                                        187056
      *                                                                                       187056
     C     @RTCD         IFNE      *BLANKS                                                    187056
     C                   MOVEL     'SDFTFRPD'    DBFILE                                       187056
     C                   MOVEL     '902'         DBASE                                        187056
     C                   MOVEL     @OPTN         DBKEY                                        187056
     C                   EXSR      *PSSR                                                      187056
     C                   ENDIF                                                                187056

      * Key list for account validation
     C     AKEY          KLIST
     C                   Kfld                    K#CNUM
     C                   Kfld                    K#BCCY
     C                   Kfld                    K#ACOD
     C                   Kfld                    K#ACSQ
     C                   Kfld                    K#BRCA
      *
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   Z-ADD     3             DBASE                                        CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'N'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
