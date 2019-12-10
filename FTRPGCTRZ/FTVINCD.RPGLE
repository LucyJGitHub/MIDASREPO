     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP Instruction Code')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVINCD   - Validate OP Instruction Code                     *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD021318           Date 26Jul13               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 07May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206B            Date 06Sep06               *
      *                 CSW206             Date 03Jul06               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 198109             Date 20Sep01               *
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *Create    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CSW206B - Invalid message was displayed when an incorrect    *
      *            instruction code was entered.                      *
      *  CSW206 - SWIFT 2006 Standard Changes                         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  198109 - Array index out of range.  This fix applied as part *
      *           of Release 4 packaging.                             *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      /COPY FTCPYSRC,SFTVALCSLE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
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
 
      ** Array of Fields in warning.                                                          CSD089
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CSD089
                                                                                              CSD089
      ** Array of warning message IDs                                                         CSD089
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CSD089
                                                                                              CSD089
      ** Array of warning message data.                                                       CSD089
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CSD089
                                                                                              CSD089
      ** Incoming Transaction (Second screen level 2)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
 
      ** Incoming Transaction (Second screen level 2)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
 
      ** Incoming Transaction (Third screen level 2)
     D TranInThiA    E DS                  EXTNAME(FTOPY4PD)
 
      ** Incoming Transaction (Third screen level 2)
     D TranInThiB    E DS                  EXTNAME(FTOPY5PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** Array of valid swift characters
     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)
      *                                                                                       CSW201
      ** Array of entered codewords                                                           CSW201
     D Codeword        S              4A   DIM(5)                                             CSW201
      *                                                                                       CSW201
      ** Array of Instruction codewords in correct order                                      CSW201
     D*WICOR****       S              4    DIM(12) CTDATA PERRCD(12)                   CSW201 CSW202
     D WICOR           S              4    DIM(13) CTDATA PERRCD(13)                          CSW202
 
     D/COPY FTCPYSRC,SFTADDRILE
 
     D WSINCD          DS           175
     D  WCDWD1                 1      4
     D  WSLSH1                 5      5
     D  WSINC1                 1     35
     D  WL2345                36    175
     D  WCDWD2                36     39
     D  WSLSH2                40     40
     D  WSINC2                36     70
     D  WL345                 71    175
     D  WCDWD3                71     74
     D  WSLSH3                75     75
     D  WSINC3                71    105
     D  WL45                 106    175
     D  WCDWD4               106    109
     D  WSLSH4               110    110
     D  WSINC4               106    140
     D  WCDWD5               141    144
     D  WSLSH5               145    145
     D  WSINC5               141    175
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc                                          CSD089
     D WIx             S              3P 0                                                    CSD089
                                                                                              CSD089
     D ADLINE          S              1
     D ADSLON          S              1
     D ADFLDM          S              7
     D ADFLDF          S             10
 
      ** 1st character of the 1st beneficiary field
     D WBENSL          S              1
 
      ** Codewords array
     D*CODE1****       S              4    DIM(12) CTDATA PERRCD(12)                          CSW202
     D*CODE2****       S              4    DIM(7) CTDATA PERRCD(7)                            CSW202
     D CODE1           S              4    DIM(13) CTDATA PERRCD(13)                          CSW202
     D CODE2           S              4    DIM(8) CTDATA PERRCD(8)                            CSW202
 
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** SWIFT 2002 Switchable Feature Indicator                                              CSW202
     D CSW202          S              1A                                                      CSW202
                                                                                              CSW202
      ** Return Code when calling SWIF2002                                                    CSW202
     D PRetrnCde       S              7A                                                      CSW202
                                                                                              CSW202
     D CSW206          S              1                                                       CSW206
                                                                                              CSW206
      ** Duplicate codeword flag                                                              CSW201
     D WDuplicate      S              1A                                                      CSW201
                                                                                              CSW201
      ** Invalid codeword combination flag                                                    CSW201
     D WInvalidCombi   S              1A                                                      CSW201
                                                                                              CSW201
      ** Codeword array counter                                                               CSW201
     D X               S              1S 0                                                    CSW201
                                                                                              CSW201
      ** Codeword array counter                                                               CSW201
     D Y               S              1S 0                                                    CSW201
     D WIn             S              2P 0                                                    CSW201
     D WIz             S              2P 0                                                    CSW201
     D Wx              S              2P 0                                                    CSW201
     D Wj              S              2P 0                                                    CSW201
                                                                                              CSW201
      ** Instruction code line in error                                                       CSW201
     D E               S              1S 0                                                    CSW201
                                                                                              CSW201
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
     D PMode           S              6A                                                    MD021318
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WFldNmXAr = *Blanks                                        CSD089
     C                   Eval      WMsgIDXAr  = *Blanks                                       CSD089
     C                   Eval      WMsgDtXAr = *Blanks                                        CSD089
     C                   Eval      WIx = 0                                                    CSD089
     C                   Eval      AD#1 = 'N'
     C                   Eval      AD#2 = 'N'
     C                   Eval      AD#3 = 'N'
     C                   Eval      AD#4 = 'N'
     C                   Eval      AD#5 = 'N'
     C                   Eval      AD#6 = 'N'
 
      ** Instruction Code
 
     C                   ExSr      SrInsCde
 
      ** If an error was found, set the return code appropriately
 
     C                   If        (OKICD1 = 'N') Or (OKICD2 = 'N') Or
     C                             (OKICD3 = 'N') Or (OKICD4 = 'N') Or
     C                             (OKICD5 = 'N')
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        (OKICD1 = 'W') Or (OKICD2 = 'W') Or                        CSD089
     C                             (OKICD3 = 'W') Or (OKICD4 = 'W') Or                        CSD089
     C                             (OKICD5 = 'W')                                             CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   EndIf                                                                CSD089
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrInsCde
      *****************************************************************
      *                                                               *
      * SR/SrInsCde   - Validate Instruction Code                     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ADCHK       - Address validation, checks for invalid char.    *
      *                                                               *
      *****************************************************************
 
     C     SrInsCde      BegSr
 
     C                   Eval      WSINC1 = SICD1
     C                   Eval      WSINC2 = SICD2
     C                   Eval      WSINC3 = SICD3
     C                   Eval      WSINC4 = SICD4
     C                   Eval      WSINC5 = SICD5
     C                   Eval      WBENSL = (%Subst(SBNC1:1:1))
 
      ** Intruction code is optional and must be a valid codeword if entered
 
     C                   If        WSINCD <> *Blanks
 
      ** Check if an invalid character exists
 
     C                   Eval      ADLINE = *Blank
     C                   Eval      ADFLDM = 'FTM3245'
     C                   Eval      ADFLDF = 'FTUSRMSG'
 
     C                   Eval      ADDRSS = *Blank
     C                   Eval      ADDRSS = WSINCD
 
     C                   ExSr      ADCHK
 
      ** Illigal Characters found
 
     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKICD1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SICD1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKICD1                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SICD1'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKICD1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SICD1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   EndIf
 
     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKICD2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SICD2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKICD2                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SICD2'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKICD2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SICD2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   EndIf
 
     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKICD3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SICD3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKICD3                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SICD3'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKICD3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SICD3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   EndIf
 
     C                   If        AD#4 = 'Y'
     C**********         Move      'N'           OKICD4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SICD4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKICD4                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SICD4'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKICD4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SICD4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   EndIf
 
     C                   If        AD#5 = 'Y'
     C**********         Move      'N'           OKICD5                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SICD5'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKICD5                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SICD5'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKICD5                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SICD5'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   EndIf
 
      ** Entry not allowed when the bank operation code is 'SSTD' or 'SPAY'
 
     C                   If        (SBOCD = 'SSTD') Or (SBOCD = 'SPAY')
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   Movel     'FTM3218'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
 
      ** Instruction code 1
 
     C                   If        SICD1 <> *Blank
 
      ** '?' not allowed
 
     C     '?'           Scan      STRI1         Y#                3 0    90
      *
     C                   If        *IN90 = True
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   Movel     'FTM3224'     MsgIdXAr(Idx)
     C                   EndIf
 
      ** No error
 
     C                   If        OKICD1 <> 'N'
 
      ** Check codeword if valid
 
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C     WCDWD1        LookUp    CODE1                                  35
 
      ** Invalid codeword
 
     C                   If        *IN35 = False
     C                             OR (WCDWD1 ='REPA' AND CSW202 = 'N')                       CSW202
     C                             OR (WCDWD1 ='BONL' AND CSW206 = 'Y')                       CSW206
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C**********         IF        WCDWD1 ='BONL' AND CSW206 = 'Y'                    CSW206 CSW206B
     C                   IF        CSW206 = 'Y'                                              CSW206B
     C                   Movel     'FTM5601'     MsgIdXAr(Idx)                                CSW206
     C                   ENDIF                                                                CSW206
     C                   Goto      EndInCd
     C                   EndIf
 
      ** Valid code word with additional information, check if additional
      ** information allowed.
 
     C                   Move      WSINC1        WLEN31           31
     C                   If        (*IN35 = True) And (WLEN31 <> *Blank)
     C     WCDWD1        LookUp    CODE2                                  36
 
      ** Additional information not allowed for codeword entered.
 
     C                   If        *IN36 = False
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   If        WSLSH1 = '/'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5501'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3220'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Else
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   EndIf
     C                   Goto      EndInCd
 
      ** Else, if additional information is allowed for codeword.
 
     C                   Else
     C                   If        (WSLSH1 <> '/') Or (WSLSH1 = *Blank) And
     C                             (WLEN31 <> *Blank)
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Bank operation code is 'SPRI', only 'SDVA', 'TELB', 'PHOB' or
      ** 'INTC' codeword is allowed.
 
     C                   If        SBOCD = 'SPRI'
     C*****WCDWD1        LookUp    CODE1(9)                               35                  CSW202
     C     WCDWD1        LOOKUP    CODE1(10)                              35                  CSW202
 
      ** Codeword not allowed
 
     C                   If        *IN35 = False
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   Movel     'FTM3221'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
 
      ** Instruction code must not be a 'CHQB' when first line of bene -
      ** ficiary contains an account identifier ('/')
 
     C                   If        (WCDWD1 = 'CHQB') And (WBENSL = '/')
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   Movel     'FTM3222'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
 
      ** 1st line is blank while other code lines have been entered
 
     C                   Else
     C                   If        WL2345 <> *Blank
     C                   Move      'N'           OKICD1
     C                   Add       1             Idx
     C                   Movel     'SICD1'       FldNamXAr(Idx)
     C                   Movel     'FTM3223'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Intermediary Bank field                               CSW201
      ** is not entered, codewords TELI and PHOI are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201='Y'                                                 CSW201
      *                                                                                       CSW201
     C                   IF        (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                      CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd1 = 'TELI')                 CSW201
     C                             OR (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                   CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd1 = 'PHOI')                 CSW201
     C                   EVAL      Okicd1 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD1'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = Wcdwd1                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(Wcdwd1))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(Wcdwd1)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Account with Bank field                               CSW201
      ** is not entered, codewords TELE and PHON are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                      CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd1 = 'TELE')                 CSW201
     C                             OR (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                   CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd1 = 'PHON')                 CSW201
     C                   EVAL      Okicd1 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD1'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WcdWd1                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WcdWd1))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WcdWd1)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
      ** Instruction code 2
 
     C                   If        SICD2 <> *Blank
 
      ** Check codeword if valid
 
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C     WCDWD2        LookUp    CODE1                                  35
 
      ** Invalid codeword
 
     C                   If        *IN35 = False
     C                             OR (WCDWD2 ='REPA' AND CSW202 = 'N')                       CSW202
     C                             OR (WCDWD2 ='BONL' AND CSW206 = 'Y')                       CSW206
     C                   Move      'N'           OKICD2
     C                   Add       1             Idx
     C                   Movel     'SICD2'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C**********         IF        WCDWD2 ='BONL' AND CSW206 = 'Y'                    CSW206 CSW206B
     C                   IF        CSW206 = 'Y'                                              CSW206B
     C                   Movel     'FTM5601'     MsgIdXAr(Idx)                                CSW206
     C                   ENDIF                                                                CSW206
     C                   Goto      EndInCd
     C                   EndIf
 
      ** Valid code word with additional information, check if additional
      ** information allowed.
 
     C                   Move      WSINC2        WLEN31
     C                   If        (*IN35 = True) And (WLEN31 <> *Blank)
     C     WCDWD2        LookUp    CODE2                                  36
 
      ** Additional information not allowed for codeword entered.
 
     C                   If        *IN36 = False
     C                   Move      'N'           OKICD2
     C                   Add       1             Idx
     C                   Movel     'SICD2'       FldNamXAr(Idx)
     C                   If        WSLSH2 = '/'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5501'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3220'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Else
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   EndIf
     C                   Goto      EndInCd
 
      ** Else, if additional information is allowed for codeword.
 
     C                   Else
     C                   If        (WSLSH2 <> '/') Or (WSLSH2 = *Blank) And
     C                             (WLEN31 <> *Blank)
     C                   Move      'N'           OKICD2
     C                   Add       1             Idx
     C                   Movel     'SICD2'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Bank operation code is 'SPRI', only 'SDVA', 'TELB', 'PHOB' or
      ** 'INTC' codeword is allowed.
 
     C                   If        SBOCD = 'SPRI'
     C*****WCDWD2        LookUp    CODE1(9)                               35                  CSW202
     C     WCDWD2        LOOKUP    CODE1(10)                              35                  CSW202
 
      ** Codeword not allowed
 
     C                   If        *IN35 = False
     C                   Move      'N'           OKICD2
     C                   Add       1             Idx
     C                   Movel     'SICD2'       FldNamXAr(Idx)
     C                   Movel     'FTM3221'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
 
      ** Instruction code must not be a 'CHQB' when first line of bene -
      ** ficiary contains an account identifier ('/')
 
     C                   If        (WCDWD2 = 'CHQB') And (WBENSL = '/')
     C                   Move      'N'           OKICD2
     C                   Add       1             Idx
     C                   Movel     'SICD2'       FldNamXAr(Idx)
     C                   Movel     'FTM3222'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
 
      ** 2nd line is blank while other code lines have been entered
 
     C                   Else
     C                   If        WL345 <> *Blank
     C                   Move      'N'           OKICD2
     C                   Add       1             Idx
     C                   Movel     'SICD2'       FldNamXAr(Idx)
     C                   Movel     'FTM3223'     MsgIdXAr(Idx)
     C                   Goto      EndIncd
     C                   EndIf
     C                   EndIf
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Intermediary Bank field                               CSW201
      ** is not entered, codewords TELI and PHOI are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201='Y'                                                 CSW201
      *                                                                                       CSW201
     C                   IF        (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                      CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd2 = 'TELI')                 CSW201
     C                             OR (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                   CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd2 = 'PHOI')                 CSW201
     C                   EVAL      Okicd2 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD2'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = Wcdwd2                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(Wcdwd2))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(Wcdwd2)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Account with Bank field                               CSW201
      ** is not entered, codewords TELE and PHON are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                      CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd2 = 'TELE')                 CSW201
     C                             OR (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                   CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd2 = 'PHON')                 CSW201
     C                   EVAL      Okicd2 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD2'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WcdWd2                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WcdWd2))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WcdWd2)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
      ** Instruction code 3
 
     C                   If        SICD3 <> *Blank
 
      ** Check codeword if valid
 
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C     WCDWD3        LookUp    CODE1                                  35
 
      ** Invalid codeword
 
     C                   If        *IN35 = False
     C                             OR (WCDWD3 ='REPA' AND CSW202 = 'N')                       CSW202
     C                             OR (WCDWD3 ='BONL' AND CSW206 = 'Y')                       CSW206
     C                   Move      'N'           OKICD3
     C                   Add       1             Idx
     C                   Movel     'SICD3'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C**********         IF        WCDWD3 ='BONL' AND CSW206 = 'Y'                    CSW206 CSW206B
     C                   IF        CSW206 = 'Y'                                              CSW206B
     C                   Movel     'FTM5601'     MsgIdXAr(Idx)                                CSW206
     C                   ENDIF                                                                CSW206
     C                   Goto      EndInCd
     C                   EndIf
 
      ** Valid code word with additional information, check if additional
      ** information allowed.
 
     C                   Move      WSINC3        WLEN31
     C                   If        (*IN35 = True) And (WLEN31 <> *Blank)
     C     WCDWD3        LookUp    CODE2                                  36
 
      ** Additional information not allowed for codeword entered.
 
     C                   If        *IN36 = False
     C                   Move      'N'           OKICD3
     C                   Add       1             Idx
     C                   Movel     'SICD3'       FldNamXAr(Idx)
     C                   If        WSLSH3 = '/'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5501'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3220'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Else
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   EndIf
     C                   Goto      EndInCd
 
      ** Else, if additional information is allowed for codeword.
 
     C                   Else
     C                   If        (WSLSH3 <> '/') Or (WSLSH3 = *Blank) And
     C                             (WLEN31 <> *Blank)
     C                   Move      'N'           OKICD3
     C                   Add       1             Idx
     C                   Movel     'SICD3'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Bank operation code is 'SPRI', only 'SDVA', 'TELB', 'PHOB' or
      ** 'INTC' codeword is allowed.
 
     C                   If        SBOCD = 'SPRI'
     C*****WCDWD3        LookUp    CODE1(9)                               35                  CSW202
     C     WCDWD3        LOOKUP    CODE1(10)                              35                  CSW202
 
      ** Codeword not allowed
 
     C                   If        *IN35 = False
     C                   Move      'N'           OKICD3
     C                   Add       1             Idx
     C                   Movel     'SICD3'       FldNamXAr(Idx)
     C                   Movel     'FTM3221'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
 
      ** Instruction code must not be a 'CHQB' when first line of bene -
      ** ficiary contains an account identifier ('/')
 
     C                   If        (WCDWD3 = 'CHQB') And (WBENSL = '/')
     C                   Move      'N'           OKICD3
     C                   Add       1             Idx
     C                   Movel     'SICD3'       FldNamXAr(Idx)
     C                   Movel     'FTM3222'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
 
      ** 3rd line is blank while other code lines have been entered
 
     C                   Else
     C                   If        WL45 <> *Blank
     C                   Move      'N'           OKICD3
     C                   Add       1             Idx
     C                   Movel     'SICD3'       FldNamXAr(Idx)
     C                   Movel     'FTM3223'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Intermediary Bank field                               CSW201
      ** is not entered, codewords TELI and PHOI are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201='Y'                                                 CSW201
      *                                                                                       CSW201
     C                   IF        (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                      CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd3 = 'TELI')                 CSW201
     C                             OR (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                   CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd3 = 'PHOI')                 CSW201
     C                   EVAL      Okicd3 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD3'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = Wcdwd3                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(Wcdwd3))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(Wcdwd3)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Account with Bank field                               CSW201
      ** is not entered, codewords TELE and PHON are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                      CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd3 = 'TELE')                 CSW201
     C                             OR (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                   CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd3 = 'PHON')                 CSW201
     C                   EVAL      Okicd3 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD3'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WcdWd3                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WcdWd3))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WcdWd3)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
      ** Instruction code 4
 
     C                   If        SICD4 <> *Blank
 
      ** Check codeword if valid
 
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C     WCDWD4        LookUp    CODE1                                  35
 
      ** Invalid codeword
 
     C                   If        *IN35 = False
     C                             OR (WCDWD4 ='REPA' AND CSW202 = 'N')                       CSW202
     C                             OR (WCDWD4 ='BONL' AND CSW206 = 'Y')                       CSW206
     C                   Move      'N'           OKICD4
     C                   Add       1             Idx
     C                   Movel     'SICD4'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C**********         IF        WCDWD4 ='BONL' AND CSW206 = 'Y'                    CSW206 CSW206B
     C                   IF        CSW206 = 'Y'                                              CSW206B
     C                   Movel     'FTM5601'     MsgIdXAr(Idx)                                CSW206
     C                   ENDIF                                                                CSW206
     C                   Goto      EndInCd
     C                   EndIf
 
      ** Valid code word with additional information, check if additional
      ** information allowed.
 
     C                   Move      WSINC4        WLEN31
     C                   If        (*IN35 = True) And (WLEN31 <> *Blank)
     C     WCDWD4        LookUp    CODE2                                  36
 
      ** Additional information not allowed for codeword entered.
 
     C                   If        *IN36 = False
     C                   Move      'N'           OKICD4
     C                   Add       1             Idx
     C                   Movel     'SICD4'       FldNamXAr(Idx)
     C                   If        WSLSH4 = '/'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5501'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3220'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Else
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   EndIf
     C                   Goto      EndInCd
 
      ** Else, if additional information is allowed for codeword.
 
     C                   Else
     C                   If        (WSLSH4 <> '/') Or (WSLSH4 = *Blank) And
     C                             (WLEN31 <> *Blank)
     C                   Move      'N'           OKICD4
     C                   Add       1             Idx
     C                   Movel     'SICD4'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Bank operation code is 'SPRI', only 'SDVA', 'TELB', 'PHOB' or
      ** 'INTC' codeword is allowed.
 
     C                   If        SBOCD = 'SPRI'
     C*****WCDWD4        LookUp    CODE1(9)                               35                  CSW202
     C     WCDWD4        LOOKUP    CODE1(10)                              35                  CSW202
 
      ** Codeword not allowed
 
     C                   If        *IN35 = False
     C                   Move      'N'           OKICD4
     C                   Add       1             Idx
     C                   Movel     'SICD4'       FldNamXAr(Idx)
     C                   Movel     'FTM3221'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
 
      ** Instruction code must not be a 'CHQB' when first line of bene -
      ** ficiary contains an account identifier ('/')
 
     C                   If        (WCDWD4 = 'CHQB') And (WBENSL = '/')
     C                   Move      'N'           OKICD4
     C                   Add       1             Idx
     C                   Movel     'SICD4'       FldNamXAr(Idx)
     C                   Movel     'FTM3222'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
 
      ** 4th line is blank while 5th line is entered.
 
     C                   Else
     C                   If        WSINC5 <> *Blank
     C                   Move      'N'           OKICD4
     C                   Add       1             Idx
     C                   Movel     'SICD4'       FldNamXAr(Idx)
     C                   Movel     'FTM3223'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Intermediary Bank field                               CSW201
      ** is not entered, codewords TELI and PHOI are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201='Y'                                                 CSW201
      *                                                                                       CSW201
     C                   IF        (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                      CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd4 = 'TELI')                 CSW201
     C                             OR (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                   CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd4 = 'PHOI')                 CSW201
     C                   EVAL      Okicd4 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD4'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = Wcdwd4                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(Wcdwd4))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(Wcdwd4)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Account with Bank field                               CSW201
      ** is not entered, codewords TELE and PHON are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                      CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd4 = 'TELE')                 CSW201
     C                             OR (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                   CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd4 = 'PHON')                 CSW201
     C                   EVAL      Okicd4 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD4'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WcdWd4                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WcdWd4))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WcdWd4)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
      ** Instruction code 5
 
     C                   If        SICD5 <> *Blank
 
      ** Check codeword if valid
 
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C     WCDWD5        LookUp    CODE1                                  35
 
      ** Invalid codeword
 
     C                   If        *IN35 = False
     C                             OR (WCDWD5 ='REPA' AND CSW202 = 'N')                       CSW202
     C                             OR (WCDWD5 ='BONL' AND CSW206 = 'Y')                       CSW206
     C                   Move      'N'           OKICD5
     C                   Add       1             Idx
     C                   Movel     'SICD5'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C**********         IF        WCDWD5 ='BONL' AND CSW206 = 'Y'                    CSW206 CSW206B
     C                   IF        CSW206 = 'Y'                                              CSW206B
     C                   Movel     'FTM5601'     MsgIdXAr(Idx)                                CSW206
     C                   ENDIF                                                                CSW206
     C                   Goto      EndInCd
     C                   EndIf
 
      ** Valid code word with additional information, check if additional
      ** information allowed.
 
     C                   Move      WSINC5        WLEN31
     C                   If        (*IN35 = True) And (WLEN31 <> *Blank)
     C     WCDWD5        LookUp    CODE2                                  36
 
      ** Additional information not allowed for codeword entered.
 
     C                   If        *IN36 = False
     C                   Move      'N'           OKICD5
     C                   Add       1             Idx
     C                   Movel     'SICD5'       FldNamXAr(Idx)
     C                   If        WSLSH5 = '/'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5501'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3220'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Else
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   EndIf
     C                   Goto      EndInCd
 
      ** Else, if additional information is allowed for codeword.
 
     C                   Else
     C                   If        (WSLSH5 <> '/') Or (WSLSH5 = *Blank) And
     C                             (WLEN31 <> *Blank)
     C                   Move      'N'           OKICD5
     C                   Add       1             Idx
     C                   Movel     'SICD5'       FldNamXAr(Idx)
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5505'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   Movel     'FTM3219'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW202
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** Bank operation code is 'SPRI', only 'SDVA', 'TELB', 'PHOB' or
      ** 'INTC' codeword is allowed.
 
     C                   If        SBOCD = 'SPRI'
     C*****WCDWD5        LookUp    CODE1(9)                               35                  CSW202
     C     WCDWD5        LOOKUP    CODE1(10)                              35                  CSW202
 
      ** Codeword not allowed
 
     C                   If        *IN35 = False
     C                   Move      'N'           OKICD5
     C                   Add       1             Idx
     C                   Movel     'SICD5'       FldNamXAr(Idx)
     C                   Movel     'FTM3221'     MsgIdXAr(Idx)
     C                   Goto      EndInCd
     C                   EndIf
     C                   EndIf
 
      ** Instruction code must not be a 'CHQB' when first line of bene -
      ** ficiary contains an account identifier ('/')
 
     C                   If        (WCDWD5 = 'CHQB') And (WBENSL = '/')
     C                   Move      'N'           OKICD5
     C                   Add       1             Idx
     C                   Movel     'SICD5'       FldNamXAr(Idx)
     C                   Movel     'FTM3222'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Intermediary Bank field                               CSW201
      ** is not entered, codewords TELI and PHOI are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201='Y'                                                 CSW201
      *                                                                                       CSW201
     C                   IF        (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                      CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd5 = 'TELI')                 CSW201
     C                             OR (Sinb1 = *BLANK) AND (Sinb2 = *BLANK)                   CSW201
     C                             AND (Sinb3 = *BLANK) AND (Sinb4 = *BLANK)                  CSW201
     C                             AND (Sinb5 = *BLANK) AND (Wcdwd5 = 'PHOI')                 CSW201
     C                   EVAL      Okicd5 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD5'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = Wcdwd5                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(Wcdwd5))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(Wcdwd5)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5046'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Account with Bank field                               CSW201
      ** is not entered, codewords TELE and PHON are prohibited                               CSW201
      *                                                                                       CSW201
     C                   IF        (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                      CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd5 = 'TELE')                 CSW201
     C                             OR (Sacb1 = *BLANK) AND (Sacb2 = *BLANK)                   CSW201
     C                             AND (Sacb3 = *BLANK) AND (Sacb4 = *BLANK)                  CSW201
     C                             AND (Sacb5 = *BLANK) AND (Wcdwd5 = 'PHON')                 CSW201
     C                   EVAL      Okicd5 = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'SICD5'                                   CSW201
     C**********         EVAL      MsgDtaXAr(Idx) = WcdWd5                           CSW201 MD000091
     C                   EVAL      BLen = %Len(%Trim(WcdWd5))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WcdWd5)                   MD000091
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5047'                                  CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed, check if there are any                                   CSW201
      ** duplicate codewords or if certain prohibited codeword                                CSW201
      ** combinations were entered.                                                           CSW201
      *                                                                                       CSW201
     C                   IF        CSW201='Y'                                                 CSW201
      *                                                                                       CSW201
     C                   EVAL      Codeword(1) = Wcdwd1                                       CSW201
     C                   EVAL      Codeword(2) = Wcdwd2                                       CSW201
     C                   EVAL      Codeword(3) = Wcdwd3                                       CSW201
     C                   EVAL      Codeword(4) = Wcdwd4                                       CSW201
     C                   EVAL      Codeword(5) = Wcdwd5                                       CSW201
     C                   EVAL      X = 5                                                      CSW201
     C                   EVAL      WDuplicate = 'N'                                           CSW201
     C                   EVAL      WInvalidCombi = 'N'                                        CSW201
      *                                                                                       CSW201
     C                   DOW       (X > 1)  AND (WDuplicate = 'N')                            CSW201
     C                             AND (WInvalidCombi = 'N')                                  CSW201
      *                                                                                       CSW201
     C                   IF        Codeword(X) <> *BLANK                                      CSW201
     C                   EVAL      Y = X - 1                                                  CSW201
      *                                                                                       CSW201
     C                   DOW       (Y >= 1) AND (WDuplicate = 'N')                            CSW201
     C                             AND (WInvalidCombi = 'N')                                  CSW201
      *                                                                                       CSW201
      ** Check for duplicate codewords                                                        CSW201
      *                                                                                       CSW201
     C                   IF        Codeword(X) = Codeword(Y)                                  CSW201
     C                   EVAL      WDuplicate = 'Y'                                           CSW201
     C                   EVAL      E = X                                                      CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Check for prohibited codeword combinations                                           CSW201
      *                                                                                       CSW201
     C                   IF        WDuplicate = 'N'                                           CSW201
      *                                                                                       CSW201
     C                   IF        Codeword(X) = 'SDVA' AND Codeword(Y) = 'HOLD'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'HOLD' AND Codeword(Y) = 'SDVA'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'SDVA' AND Codeword(Y) = 'CHQB'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CHQB' AND Codeword(Y) = 'SDVA'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'INTC' AND Codeword(Y) = 'BONL'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'BONL' AND Codeword(Y) = 'INTC'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'INTC' AND Codeword(Y) = 'HOLD'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'HOLD' AND Codeword(Y) = 'INTC'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'INTC' AND Codeword(Y) = 'CHQB'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CHQB' AND Codeword(Y) = 'INTC'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CORT' AND Codeword(Y) = 'BONL'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'BONL' AND Codeword(Y) = 'CORT'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CORT' AND Codeword(Y) = 'HOLD'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'HOLD' AND Codeword(Y) = 'CORT'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CORT' AND Codeword(Y) = 'CHQB'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CHQB' AND Codeword(Y) = 'CORT'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'HOLD' AND Codeword(Y) = 'CHQB'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'CHQB' AND Codeword(Y) = 'HOLD'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'PHOB' AND Codeword(Y) = 'TELB'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'TELB' AND Codeword(Y) = 'PHOB'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'PHON' AND Codeword(Y) = 'TELE'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'TELE' AND Codeword(Y) = 'PHON'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'PHOI' AND Codeword(Y) = 'TELI'              CSW201
     C                             OR                                                         CSW201
     C                             Codeword(X) = 'TELI' AND Codeword(Y) = 'PHOI'              CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, the following additional              CSW202
      ** combination of codes will be prohibited :  REPA with HOLD, REPA with                 CSW202
      ** CHQB, REPA with BONL, REPA with CORT.                                                CSW202
                                                                                              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'REPA' AND Codeword(Y) = 'HOLD'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'HOLD' AND Codeword(Y) = 'REPA'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'REPA' AND Codeword(Y) = 'CHQB'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'CHQB' AND Codeword(Y) = 'REPA'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'REPA' AND Codeword(Y) = 'BONL'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'BONL' AND Codeword(Y) = 'REPA'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'REPA' AND Codeword(Y) = 'CORT'              CSW202
     C                             OR                                                         CSW202
     C                             Codeword(X) = 'CORT' AND Codeword(Y) = 'REPA'              CSW202
     C                   EVAL      WInvalidCombi = 'Y'                                        CSW201
     C                   EVAL      E = X                                                      CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   EVAL      Y = Y - 1                                                  CSW201
     C                   ENDDO                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   EVAL      X = X - 1                                                  CSW201
     C                   ENDDO                                                                CSW201
      *                                                                                       CSW201
      ** If duplicate codewords and/or prohibited combinations                                CSW201
      ** exist, set appropriate error message.                                                CSW201
      *                                                                                       CSW201
     C                   IF        WDuplicate = 'Y' OR WInvalidCombi = 'Y'                    CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C**********         EVAL      FldNamXAr(Idx) = Codeword(Y)                        CSW201 198109
      *                                                                                       CSW201
     C                   IF        E = 1                                                      CSW201
     C                   EVAL      Okicd1 = 'N'                                               CSW201
     C                   EVAL      FldNamXAr(Idx) = SICD1                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        E = 2                                                      CSW201
     C                   EVAL      Okicd2 = 'N'                                               CSW201
     C                   EVAL      FldNamXAr(Idx) = SICD2                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        E = 3                                                      CSW201
     C                   EVAL      Okicd3 = 'N'                                               CSW201
     C                   EVAL      FldNamXAr(Idx) = SICD3                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        E = 4                                                      CSW201
     C                   EVAL      Okicd4 = 'N'                                               CSW201
     C                   EVAL      FldNamXAr(Idx) = SICD4                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        E = 5                                                      CSW201
     C                   EVAL      Okicd5 = 'N'                                               CSW201
     C                   EVAL      FldNamXAr(Idx) = SICD5                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        WDuplicate = 'Y'                                           CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5048'                                  CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        WInvalidCombi = 'Y'                                        CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5504'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5049'                                  CSW201
     C                   ENDIF                                                                CSW202
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If there is more than 1 instructinon code entered, check order                       CSW201
      ** of sequence.                                                                         CSW201
      *                                                                                       CSW201
     C                   Z-ADD     1             Wj                                           CSW201
     C     *BLANK        LOOKUP    Codeword(Wj)                           01                  CSW201
     C                   IF        *IN01                                                      CSW201
     C                   EVAL      Wj = Wj - 1                                                CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      Wj = 5                                                     CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        Wj <= 1                                                    CSW201
     C                   GOTO      EndInCd                                                    CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   Z-ADD     1             WIn                                          CSW201
     C                   DOW       WIn < Wj                                                   CSW201
      *                                                                                       CSW201
     C                   Z-ADD     1             Wx                                           CSW201
     C     Codeword(WIn) LOOKUP    WICOR(Wx)                              01                  CSW201
     C                   EVAL      WIz = WIn + 1                                              CSW201
      *                                                                                       CSW201
     C                   IF        *IN01 AND WIz <= (Wj + 1)                                  CSW201
     C     Codeword(WIz) LOOKUP    WICOR(Wx)                              01                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN01 = *OFF                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5503'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5210'                                  CSW201
     C                   ENDIF                                                                CSW202
     C                   IF        CSW206 = 'Y'                                               CSW206
     C                   EVAL      MsgIdXAr(Idx) = 'FTM5602'                                  CSW206
     C                   ENDIF                                                                CSW206
     C                   EVAL      FldNamXAr(Idx) = 'SICD1'                                   CSW201
     C                   EVAL      OKICD1 = 'N'                                               CSW201
     C                   EVAL      OKICD2 = 'N'                                               CSW201
     C                   EVAL      OKICD3 = 'N'                                               CSW201
     C                   EVAL      OKICD4 = 'N'                                               CSW201
     C                   EVAL      OKICD5 = 'N'                                               CSW201
     C                   LEAVE                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      WIn = WIn + 1                                              CSW201
      *                                                                                       CSW201
     C                   ENDDO                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C     EndInCd       EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    TranInSecA
     C                   Parm                    TranInSecB
     C                   Parm                    TranInThiA
     C                   Parm                    TranInThiB
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtXAr                                    CSD089
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    CSW201                                       CSW201
     C                   PARM                    PMode                                      MD021318
 
                                                                                              CSW202
      ** Check if switchable feature CSW202 is switched on                                    CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRetrnCde                                    CSW202
                                                                                              CSW202
     C                   IF        PRetrnCde = 'CSW2002'                                      CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW206
      ** Check if switchable feature CSW206 is switched on                                    CSW206
                                                                                              CSW206
     C                   CALL      'SWIF2006'                                                 CSW206
     C                   PARM      *BLANKS       PRetrnCde                                    CSW206
                                                                                              CSW206
     C                   IF        PRetrnCde = 'CSW2006'                                      CSW206
     C                   EVAL      CSW206 = 'Y'                                               CSW206
     C                   ELSE                                                                 CSW206
     C                   EVAL      CSW206 = 'N'                                               CSW206
     C                   ENDIF                                                                CSW206
     C                   EndSr
 
      *****************************************************************
      ** ADCHK subroutine
     C/COPY FTCPYSRC,SFTADDRCLE
 
      ** SWSET subroutine
     C/COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
                                                                                              CSW202
      ** CODE1 , CODE2 and WICOR were amended to add codeword REPA.                           CSW202
                                                                                              CSW202
**  CPY@
(c) Finastra International Limited 2001
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
**  WICOR                                                                                     CSW201
SDVAINTCREPACORTBONLHOLDCHQBPHOBTELBPHONTELEPHOITELI                                   CSW201 CSW202
**  CODE1 - Valid code words for MT103 messages
PHONPHOITELETELIHOLDBONLCHQBCORTREPATELBPHOBSDVAINTC                                          CSW202
**  CODE2 - Code words that could have an additional info.
PHONPHOBPHOITELETELBTELIHOLDREPA                                                              CSW202
