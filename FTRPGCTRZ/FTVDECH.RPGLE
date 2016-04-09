     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate details of charges')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVDECH  - Validate Details of Charges                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255428             Date 04Dec08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245882             Date 28Feb07               *
      *                 200949             Date 05Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 208219             Date 27Apr06               *
      *                 CGL014             Date 20Oct03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 06Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  255428 - Apply client fix 255930                             *
      *  245882 - @MT103 not set up in calling pgm so FTM5211 always  *
      *           occurs. Fix 200949 removed. Applied core fix 240415.*
      *  200949 - Do not allow 'SHA' if payment will not produce a    *
      *           MT103.  Applied core fix 197943.                    *
      *           Same fix as 208219.                                 *
      *  208219 - MT103 mandatory fields.
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
 
      * Incoming Transaction
     D*TranInThir****E*DS***               EXTNAME(FTOPY4PD)                    CFT014
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)                                  255428
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014
 
      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for Message Management ICD                                   219241
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
                                                                                              219241
      ** Second DS for Access Programs, long data structure                                   219241
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     219241
                                                                                              219241
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D PRTCD           S              7A                                                      219241
     D POPTN           S              7A                                                      219241
 
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
                                                                                              219241
      ** If CFT014 is installed, retrieve Message Management ICD                              219241
                                                                                              219241
     C                   IF        @CFT014 = 'Y'                                              219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       PRTCD                                        219241
     C                   PARM      '*FIRST'      POPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        PRTCD <> *BLANKS                                           219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 1                                                  219241
     C                   EVAL      DBKEY = POPTN                                              219241
     C                   EXSR      *PSSR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
 
      * Validate
     C                   EXSR      VDETCHG
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKDtch = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VDETCHG - DETAILS OF CHARGES VALIDATION
      *****************************************************************
     C*
     C     VDETCHG       BEGSR
 
      *  Details of Charges optional, Defaults to BEN
     C                   If        SDTCH = *Blank
                                                                                              219241
      ** If CFT014 is installed, use the default value from the                               219241
      ** Message Management ICD                                                               219241
                                                                                              219241
     C                   IF        @CFT014 = 'Y'                                              219241
     C                   EVAL      SDTCH = ENDCHG                                             219241
     C                   ELSE                                                                 219241
     C                   Eval      SDTCH = 'BEN'
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   End
 
      *   Valid entries are 'OUR' or 'BEN'
     C                   If        SDTCH <> 'OUR' and
     C                             SDTCH <> 'BEN'
     C                             And @CFT014 = 'N'                            CFT014
     C                             Or (@CFT014 = 'Y') And                       CFT014
     C                             (SDTCH <> 'OUR') And                         CFT014
     C                             (SDTCH <> 'BEN') And                         CFT014
     C                             (SDTCH <> 'SHA')                             CFT014
                                                                                CFT014
 
      * Send error to screen
     C                   Move      'N'           OKDtch
     C                   Add       1             Idx
     C                   Movel     'SDTCH'       FldNamXAr(Idx)
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Movel     'FTM5045'     MsgIdXAr(Idx)                  CFT014
     C                   Else                                                   CFT014
     C                   Movel     'MMA1083'     MsgIdXAr(Idx)
     C                   EndIf                                                  CFT014
     C                   End
     C     @CFT014       IFEQ      'Y'                                                        255428
     C     SADDC         IFEQ      'A'                                                        255428
     C     SDTCH         ANDEQ     'BEN'                                                      255428
     C     SADDC         OREQ      'D'                                                        255428
     C     SDTCH         ANDEQ     'OUR'                                                      255428
     C     SADDC         OREQ      'D'                                                        255428
     C     SDTCH         ANDEQ     'SHA'                                                      255428
     C                   MOVE      'N'           OKDtch                                       255428
     C                   ADD       1             Idx                                          255428
     C                   MOVEL     'SDTCH'       FldNamXAr(Idx)                               255428
     C                   MOVEL     'FTM5050'     MsgIDXAr(Idx)                                255428
     C                   ENDIF                                                                255428
     C                   ELSE                                                                 255428
     C     SADDC         IFEQ      'A'                                                        255428
     C     SDTCH         ANDEQ     'BEN'                                                      255428
     C     SADDC         OREQ      'D'                                                        255428
     C     SDTCH         ANDEQ     'OUR'                                                      255428
     C                   MOVE      'N'           OKDtch                                       255428
     C                   ADD       1             Idx                                          255428
     C                   MOVEL     'SDTCH'       FldNamXAr(Idx)                               255428
     C                   MOVEL     'FTM5051'     MsgIDXAr(Idx)                                255428
     C                   ENDIF                                                                255428
     C                   ENDIF                                                                255428
      **********                                                                       200949 240415
      ***Prohibit*inuput*of*'SHA'*if*payment*will*produce*a*MT100.*****                200949 240415
      **********                                                                       200949 240415
     C**********         If        SDTCH = 'SHA' and                                   200949 240415
     C**********                   @CFT014 = 'Y' and                                   200949 240415
     C**********                   @MT103 <> 'Y'                                       200949 240415
      **********                                                                       200949 240415
      ***Send*error*to*screen******************************************                200949 240415
      **********                                                                       200949 240415
     C**********         Move      'N'           OKDtch                                200949 240415
     C**********         Add       1             Idx                                   200949 240415
     C**********         Movel     'SDTCH'       FldNamXAr(Idx)                        200949 240415
     C**********         Movel     'FTM5211'     MsgIdXAr(Idx)                         200949 240415
     C**********         Endif                                                         200949 240415
 
     C                   ENDSR
      *****************************************************************
      * VDETCHG - END OF VALIDATION
      *****************************************************************
      /EJECT
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
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInFour                     CFT014
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C                   Parm                    TranInPrim                                   255428
 
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
(c) Misys International Banking Systems Ltd. 2001
