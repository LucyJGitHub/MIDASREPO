     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Instruction Code')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVISCD01 - Validate Instruction Code                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 10Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT006 - Funds Transfer : MT101 messages                     *
      *                                                               *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      * Detail record from screen
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for third screen
     D OKFlags       E DS                  EXTNAME(FTE101S3PD)
 
      * Valid instruction code array
     D ValCde          S              4    DIM(8) CTDATA PERRCD(8)
     D Found           S              4    DIM(5)
 
     D RespMode        S              1
     D DDSName         S             10
     D PPtype          S              2
                                                                                              CSW201
      * Additional valid instruction code array                                               CSW201
     D WValcde2        S              4    DIM(3) CTDATA PERRCD(3)                            CSW201
                                                                                              CSW201
      ** Group Order 1                                                                        CSW202
     D WGrpOrd1        S              4    DIM(7) CTDATA PERRCD(7)                            CSW202
                                                                                              CSW202
      ** Group Order 2                                                                        CSW202
     D WGrpOrd2        S              4    DIM(2) CTDATA PERRCD(2)                            CSW202
                                                                                              CSW202
      ** Group Order 3                                                                        CSW202
     D WGrpOrd3        S              4    DIM(2) CTDATA PERRCD(2)                            CSW202
                                                                                              CSW202
      ** Group Order 4                                                                        CSW202
     D WGrpOrd4        S              4    DIM(1) CTDATA PERRCD(1)                            CSW202
                                                                                              CSW202
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D i               S              2  0 INZ(0)
     D X               S              1  0                                                    CSW202
     D Y               S              1  0                                                    CSW202
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D DecA31          S             30
     D DecB31          S             30
     D TestField       S             30
     D PPTYP           S              2
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
      ** Return code when calling SWIF2001                                                    CSW201
     D PRTCD           S              7A                                                      CSW201
 
      ** SWIFT 2007 Switchable Feature Indicator                                              CSW207
     D CSW207          S              1A                                                      CSW207
                                                                                              CSW207
      ** SWIFT 2002 Switchable Feature Indicator                                              CSW202
     D CSW202          S              1A                                                      CSW202
                                                                                              CSW202
      ** Return Code when calling SWIF2002                                                    CSW202
     D PRetrnCde       S              7A                                                      CSW202
                                                                                              CSW202
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
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      OKINCA4    = 'Y'
     C                   Eval      OKINCB4    = 'Y'
     C                   Eval      OKINCC4    = 'Y'
     C                   Eval      OKINCD4    = 'Y'
     C                   Eval      OKINCE4    = 'Y'
     C                   Eval      OKINA31    = 'Y'
     C                   Eval      OKINB31    = 'Y'
 
     C                   Clear                   Found
     C                   Eval      i = 0
 
      * If instruction code (5 fields) entered, ensure that correct
     C                   If        PINSCA4 <> *Blanks
     C     PINSCA4       Lookup    ValCde                                 99
      *                                                                                       CSW201
      ** If CSW201 is on and Outgoing Request for Transfers,                                  CSW201
      ** accept codewords CMSW, CMTO, CMZB                                                    CSW201
      *                                                                                       CSW201
     C                   IF        NOT *IN99 AND CSW201 = 'Y'                                 CSW201
     C     PINSCA4       LOOKUP    WValCde2                               99                  CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C                   If        *In99 = *On
     C                             OR  CSW202 = 'Y' AND PINSCA4='REPA'                        CSW202
     C                             OR  (CSW207 = 'Y' AND PINSCA4='EQUI')                      CSW207
     C                   Eval      i=i+1
     C                   Movea     PINSCA4       Found(i)
     C                   Else
     C                   Eval      OKINCA4 = 'N'
     C                   Exsr      InvldCode
     C                   Endif
     C                   Endif
 
     C                   If        PINSCB4 <> *Blanks
     C     PINSCB4       Lookup    ValCde                                 99
      *                                                                                       CSW201
      ** If CSW201 is on and Outgoing Request for Transfers,                                  CSW201
      ** accept codewords CMSW, CMTO, CMZB                                                    CSW201
      *                                                                                       CSW201
     C                   IF        NOT *IN99 AND CSW201 = 'Y'                                 CSW201
     C     PINSCB4       LOOKUP    WValCde2                               99                  CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C                   If        *In99 = *On
     C                             OR  CSW202 = 'Y' AND PINSCB4='REPA'                        CSW202
     C                             OR  (CSW207 = 'Y' AND PINSCB4='EQUI')                      CSW207
     C     PINSCB4       Lookup    Found                                  99
     C                   If        *In99 = *On
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, instruction code 'OTHR'               CSW202
      ** may be repeated.                                                                     CSW202
                                                                                              CSW202
     C                             AND (CSW202 = 'N' OR PINSCB4 <> 'OTHR')                    CSW202
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0906'                               CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0051'
     C                   ENDIF                                                                CSW202
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   Eval      FldNamXAr(Idx) =   'PINSCB4'                               CAP084
     C                   Eval      OKINCB4 = 'N'
     C                   Else
     C                   Eval      i=i+1
     C                   Movea     PINSCB4       Found(i)
     C                   Endif
     C                   Else
     C                   Eval      OKINCB4 = 'N'
     C                   Exsr      InvldCode
     C                   Eval      FldNamXAr(Idx)  =   'PINSCB4'                              CAP084
     C                   Endif
     C                   Endif
 
     C                   If        PINSCC4 <> *Blanks
     C     PINSCC4       Lookup    ValCde                                 99
      *                                                                                       CSW201
      ** If CSW201 is on and Outgoing Request for Transfers,                                  CSW201
      ** accept codewords CMSW, CMTO, CMZB                                                    CSW201
      *                                                                                       CSW201
     C                   IF        NOT *IN99 AND CSW201 = 'Y'                                 CSW201
     C     PINSCC4       LOOKUP    WValCde2                               99                  CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C                   If        *In99 = *On
     C                             OR  CSW202 = 'Y' AND PINSCC4='REPA'                        CSW202
     C                             OR (CSW207 = 'Y' AND PINSCC4='EQUI')                       CSW207
     C     PINSCC4       Lookup    Found                                  99
     C                   If        *In99 = *On
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, instruction code 'OTHR'               CSW202
      ** may be repeated.                                                                     CSW202
                                                                                              CSW202
     C                             AND (CSW202 = 'N' OR PINSCC4 <> 'OTHR')                    CSW202
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0906'                               CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0051'
     C                   ENDIF                                                                CSW202
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   Eval      FldNamXAr(Idx) =   'PINSCC4'                               CAP084
     C                   Eval      OKINCC4 = 'N'
     C                   Else
     C                   Eval      i=i+1
     C                   Movea     PINSCC4       Found(i)
     C                   Endif
     C                   Else
     C                   Eval      OKINCC4 = 'N'
     C                   Exsr      InvldCode
     C                   Eval      FldNamXAr(Idx)  =   'PINSCC4'                              CAP084
     C                   Endif
     C                   Endif
 
     C                   If        PINSCD4 <> *Blanks
     C     PINSCD4       Lookup    ValCde                                 99
      *                                                                                       CSW201
      ** If CSW201 is on and Outgoing Request for Transfers,                                  CSW201
      ** accept codewords CMSW, CMTO, CMZB                                                    CSW201
      *                                                                                       CSW201
     C                   IF        NOT *IN99 AND CSW201 = 'Y'                                 CSW201
     C     PINSCD4       LOOKUP    WValCde2                               99                  CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C                   If        *In99 = *On
     C                             OR  CSW202 = 'Y' AND PINSCD4='REPA'                        CSW202
     C                             OR (CSW207 = 'Y' AND PINSCD4='EQUI')                       CSW207
     C     PINSCD4       Lookup    Found                                  99
     C                   If        *In99 = *On
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, instruction code 'OTHR'               CSW202
      ** may be repeated.                                                                     CSW202
                                                                                              CSW202
     C                             AND (CSW202 = 'N' OR PINSCD4 <> 'OTHR')                    CSW202
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0906'                               CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0051'
     C                   ENDIF                                                                CSW202
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   Eval      FldNamXAr(Idx) =   'PINSCD4'                               CAP084
     C                   Eval      OKINCD4 = 'N'
     C                   Else
     C                   Eval      i=i+1
     C                   Movea     PINSCD4       Found(i)
     C                   Endif
     C                   Else
     C                   Eval      OKINCD4 = 'N'
     C                   Exsr      InvldCode
     C                   Eval      FldNamXAr(Idx) =   'PINSCD4'                               CAP084
     C                   Endif
     C                   Endif
 
     C                   If        PINSCE4 <> *Blanks
     C     PINSCE4       Lookup    ValCde                                 99
      *                                                                                       CSW201
      ** If CSW201 is on and Outgoing Request for Transfers,                                  CSW201
      ** accept codewords CMSW, CMTO, CMZB                                                    CSW201
      *                                                                                       CSW201
     C                   IF        NOT *IN99 AND CSW201 = 'Y'                                 CSW201
     C     PINSCE4       LOOKUP    WValCde2                               99                  CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, new code 'REPA'                       CSW202
      ** - Payment has related E-Payments reference may also be used.                         CSW202
                                                                                              CSW202
     C                   If        *In99 = *On
     C                             OR  CSW202 = 'Y' AND PINSCE4='REPA'                        CSW202
     C                             OR (CSW207 = 'Y' AND PINSCE4='EQUI')                       CSW207
     C     PINSCE4       Lookup    Found                                  99
     C                   If        *In99 = *On
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, instruction code 'OTHR'               CSW202
      ** may be repeated.                                                                     CSW202
                                                                                              CSW202
     C                             AND (CSW202 = 'N' OR PINSCE4 <> 'OTHR')                    CSW202
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0906'                               CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0051'
     C                   ENDIF                                                                CSW202
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   Eval      FldNamXAr(Idx) =   'PINSCE4'                               CAP084
     C                   Eval      OKINCE4 = 'N'
     C                   Else
     C                   Eval      i=i+1
     C                   Movea     PINSCE4       Found(i)
     C                   Endif
     C                   Else
     C                   Eval      OKINCE4 = 'N'
     C                   Exsr      InvldCode
     C                   Eval      FldNamXAr(Idx) =   'PINSCE4'                               CAP084
     C                   Endif
     C                   Endif
 
      * If the 1st or 2nd instruction code is PHON or OTHR, then the
      *  must be begin with a '/'.
 
     C                   Select
     C                   When      PINSCA4 = 'PHON'            and
     C                             PINSA31 <> *Blanks          and
     C                             %Subst(PINSA31:1:1) <> '/'   or
     C                             PINSCB4 = 'PHON'            and
     C                             PINSB31 <> *Blanks          and
     C                             %Subst(PINSB31:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202         =   'Y'                                     CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0904'                               CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0052'
     C                   ENDIF                                                                CSW202
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   If        PINSCA4 = 'PHON'
     C                   Eval      OKINA31 = 'N'
     C                   Eval      FldNamXAr(Idx) =   'PINSA31'                               CAP084
     C                   Else
     C                   Eval      OKINB31 = 'N'
     C                   Eval      FldNamXAr(Idx) =   'PINSB31'                               CAP084
     C                   EndIf
 
     C                   When      PINSCA4 = 'OTHR'            and
     C                             PINSA31 <> *Blanks          and
     C                             %Subst(PINSA31:1:1) <> '/'   or
     C                             PINSCB4 = 'OTHR'            and
     C                             PINSB31 <> *Blanks          and
     C                             %Subst(PINSB31:1:1) <> '/'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202         =   'Y'                                     CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0904'                               CSW202
     C                   ELSE                                                                 CSW202
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0052'
     C                   ENDIF                                                                CSW202
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   If        PINSCA4 = 'OTHR'
     C                   Eval      OKINA31 = 'N'
     C                   Eval      FldNamXAr(Idx) =   'PINSA31'                               CAP084
     C                   Else
     C                   Eval      OKINB31 = 'N'
     C                   Eval      FldNamXAr(Idx) =   'PINSB31'                               CAP084
     C                   EndIf
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, additional                            CSW202
      ** information of instruction code 'CMTO' must begin with '/'.                          CSW202
                                                                                              CSW202
     C                   WHEN      CSW202 = 'Y' AND PINSCA4 = 'CMTO' AND                      CSW202
     C                             PINSA31 <> *BLANKS AND                                     CSW202
     C                             %SUBST(PINSA31:1:1) <> '/' OR                              CSW202
     C                             CSW202 = 'Y' AND PINSCB4 = 'CMTO' AND                      CSW202
     C                             PINSB31 <> *BLANKS AND                                     CSW202
     C                             %SUBST(PINSB31:1:1) <> '/'                                 CSW202
     C                   EVAL      Idx            =   Idx+1                                   CSW202
     C                   Eval      RetCodeIn      =   '*Error'                                CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0904'                               CSW202
     C                   Eval      FldNamXAr(Idx) =   DDSName                                 CSW202
     C                   IF        PINSCA4 = 'CMTO'                                           CSW202
     C                   EVAL      OKINA31 = 'N'                                              CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      OKINB31 = 'N'                                              CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, additional                            CSW202
      ** information may also be entered if codeword REPA is used.                            CSW202
      ** It must begin with '/'.                                                              CSW202
                                                                                              CSW202
     C                   WHEN      CSW202 = 'Y' AND PINSCA4 = 'REPA' AND                      CSW202
     C                             PINSA31 <> *BLANKS AND                                     CSW202
     C                             %SUBST(PINSA31:1:1) <> '/' OR                              CSW202
     C                             CSW202 = 'Y' AND PINSCB4 = 'REPA' AND                      CSW202
     C                             PINSB31 <> *BLANKS AND                                     CSW202
     C                             %SUBST(PINSB31:1:1) <> '/'                                 CSW202
     C                   EVAL      Idx            =   Idx+1                                   CSW202
     C                   Eval      RetCodeIn      =   '*Error'                                CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0904'                               CSW202
     C                   Eval      FldNamXAr(Idx) =   DDSName                                 CSW202
     C                   IF        PINSCA4 = 'REPA'                                           CSW202
     C                   EVAL      OKINA31 = 'N'                                              CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      OKINB31 = 'N'                                              CSW202
     C                   ENDIF                                                                CSW202
 
     C                   When      PINSCA4 = 'CHQB'      AND
     C                             PINSA31 <> *Blanks    OR
     C                             PINSCA4 = 'CORT'      AND
     C                             PINSA31 <> *Blanks    OR
     C                             PINSCA4 = 'INTC'      AND
     C                             PINSA31 <> *Blanks    OR
     C                             PINSCA4 = 'NETS'      AND
     C                             PINSA31 <> *Blanks    OR
     C                             PINSCA4 = 'RTGS'      AND
     C                             PINSA31 <> *Blanks    OR
     C                             PINSCA4 = 'URGP'      AND
     C                             PINSA31 <> *Blanks
     C                             OR CSW201 = 'Y' AND                                        CSW201
     C                             (PINSCA4 = 'CMSW' OR                                       CSW201
     C                             PINSCA4 = 'CMZB') AND                                      CSW201
     C                             PINSA31 <> *BLANKS                                         CSW201
     C                   Eval      OKINCA4    = 'N'
     C                   Eval      OKINA31    = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0293'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   When      PINSCB4 = 'CHQB'      AND
     C                             PINSB31 <> *Blanks    OR
     C                             PINSCB4 = 'CORT'      AND
     C                             PINSB31 <> *Blanks    OR
     C                             PINSCB4 = 'INTC'      AND
     C                             PINSB31 <> *Blanks    OR
     C                             PINSCB4 = 'NETS'      AND
     C                             PINSB31 <> *Blanks    OR
     C                             PINSCB4 = 'RTGS'      AND
     C                             PINSB31 <> *Blanks    OR
     C                             PINSCB4 = 'URGP'      AND
     C                             PINSB31 <> *Blanks
     C                             OR CSW201 = 'Y' AND                                        CSW201
     C                             (PINSCB4 = 'CMSW' OR                                       CSW201
     C                             PINSCB4 = 'CMZB') AND                                      CSW201
     C                             PINSA31 <> *BLANKS                                         CSW201
     C                             AND CSW202 = 'N'                                           CSW202
     C                             OR CSW202 = 'Y' AND                                        CSW202
     C                             (PINSCB4 = 'CMSW' OR                                       CSW202
     C                             PINSCB4 = 'CMZB') AND                                      CSW202
     C                             PINSB31 <> *BLANKS                                         CSW202
     C                   Eval      OKINCB4    = 'N'
     C                   Eval      OKINB31    = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0293'
     C**********         Eval      FldNamXAr(Idx) =   DDSName                                 CAP084
     C                   Eval      FldNamXAr(Idx) =   'PINSCB4'                               CAP084
 
     C                   Endsl
 
      * Certain combinations of instruction codes are not permitted:
      *  CHQB with URGP
      *  CHQB with RTGS
      *  CHQB with NETS
      *  CHQB with PHON
      *  NETS with RTGS
     C     'CHQB'        Lookup    Found                                  99
     C                   If        *IN99 = *On
     C     'URGP'        Lookup    Found                                  98
     C     'RTGS'        Lookup    Found                                  97
     C     'NETS'        Lookup    Found                                  96
     C     'PHON'        Lookup    Found                                  95
     C                   If        *IN98 = *On             OR
     C                             *IN97 = *On             OR
     C                             *IN96 = *On             OR
     C                             *IN95 = *On
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0903'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0504'                                  CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0054'
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW202
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKINCA4 = 'N'
     C                   Eval      OKINCB4 = 'N'
     C                   Eval      OKINCC4 = 'N'
     C                   Eval      OKINCD4 = 'N'
     C                   Eval      OKINCE4 = 'N'
     C                   Endif
     C                   Endif
 
     C     'NETS'        Lookup    Found                                  99
     C                   If        *IN99 = *On
     C     'RTGS'        Lookup    Found                                  98
     C                   If        *IN98 = *On
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   '*Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0055'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      OKINCA4 = 'N'
     C                   Eval      OKINCB4 = 'N'
     C                   Eval      OKINCC4 = 'N'
     C                   Eval      OKINCD4 = 'N'
     C                   Eval      OKINCE4 = 'N'
     C                   Endif
     C                   Endif
      *                                                                                       CSW201
      ** If CSW201 is on, the following codeword combination                                  CSW201
      ** will be restricted                                                                   CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** CHQB with CMSW                                                                       CSW201
      ** CHQB with CMTO                                                                       CSW201
      ** CHQB with CMZB                                                                       CSW201
      ** CHQB with CORT                                                                       CSW201
      *                                                                                       CSW201
     C     'CHQB'        LOOKUP    Found                                  99                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN99                                                      CSW201
     C     'CMSW'        LOOKUP    Found                                  98                  CSW201
     C     'CMTO'        LOOKUP    Found                                  97                  CSW201
     C     'CMZB'        LOOKUP    Found                                  96                  CSW201
     C     'CORT'        LOOKUP    Found                                  95                  CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, 'CHQB' with                           CSW202
      ** 'REPA' will be prohibited.                                                           CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C     'REPA'        LOOKUP    Found                                  94                  CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
     C                   IF        *IN98 OR *IN97 OR *IN96 OR *IN95                           CSW201
     C                             OR CSW202 = 'Y' AND *IN94                                  CSW202
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      RetCodeIn = '*Error'                                       CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0903'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0504'                                  CSW201
     C                   ENDIF                                                                CSW202
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      OKINCA4 = 'N'                                              CSW201
     C                   EVAL      OKINCB4 = 'N'                                              CSW201
     C                   EVAL      OKINCC4 = 'N'                                              CSW201
     C                   EVAL      OKINCD4 = 'N'                                              CSW201
     C                   EVAL      OKINCE4 = 'N'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** CMSW with CMTO                                                                       CSW201
      ** CMSW with CMZB                                                                       CSW201
      *                                                                                       CSW201
     C     'CMSW'        LOOKUP    Found                                  99                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN99                                                      CSW201
     C     'CMTO'        LOOKUP    Found                                  98                  CSW201
     C     'CMZB'        LOOKUP    Found                                  97                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN98 OR *IN97                                             CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      RetCodeIn = '*Error'                                       CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0505'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      OKINCA4 = 'N'                                              CSW201
     C                   EVAL      OKINCB4 = 'N'                                              CSW201
     C                   EVAL      OKINCC4 = 'N'                                              CSW201
     C                   EVAL      OKINCD4 = 'N'                                              CSW201
     C                   EVAL      OKINCE4 = 'N'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** CMTO with CMZB                                                                       CSW201
      *                                                                                       CSW201
     C     'CMTO'        LOOKUP    Found                                  99                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN99                                                      CSW201
     C     'CMZB'        LOOKUP    Found                                  98                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN98                                                      CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      RetCodeIn = '*Error'                                       CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0506'                                  CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      OKINCA4 = 'N'                                              CSW201
     C                   EVAL      OKINCB4 = 'N'                                              CSW201
     C                   EVAL      OKINCC4 = 'N'                                              CSW201
     C                   EVAL      OKINCD4 = 'N'                                              CSW201
     C                   EVAL      OKINCE4 = 'N'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** CORT with CMSW                                                                       CSW201
      ** CORT with CMTO                                                                       CSW201
      ** CORT with CMZB                                                                       CSW201
      *                                                                                       CSW201
     C     'CORT'        LOOKUP    Found                                  99                  CSW201
      *                                                                                       CSW201
     C                   IF        *IN99                                                      CSW201
     C     'CMSW'        LOOKUP    Found                                  98                  CSW201
     C     'CMTO'        LOOKUP    Found                                  97                  CSW201
     C     'CMZB'        LOOKUP    Found                                  96                  CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, 'CORT' with                           CSW202
      ** 'REPA' will be prohibited.                                                           CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C     'REPA'        LOOKUP    Found                                  95                  CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
     C                   IF        *IN98 OR *IN97 OR *IN96                                    CSW201
     C                             OR CSW202 = 'Y' AND *IN95                                  CSW202
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      RetCodeIn = '*Error'                                       CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0905'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0507'                                  CSW201
     C                   ENDIF                                                                CSW202
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      OKINCA4 = 'N'                                              CSW201
     C                   EVAL      OKINCB4 = 'N'                                              CSW201
     C                   EVAL      OKINCC4 = 'N'                                              CSW201
     C                   EVAL      OKINCD4 = 'N'                                              CSW201
     C                   EVAL      OKINCE4 = 'N'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** If SWIFT 2002 Standards Update is switched on, the codes must                        CSW202
      ** be in the following group order:                                                     CSW202
      ** 1. CMSW, CMTO, CMZB, INTC, REPA, CORT, URGP                                          CSW202
      ** 2. NETS, RTGS                                                                        CSW202
      ** 3. CHQB, PHON                                                                        CSW202
      ** 3. OTHR                                                                              CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y' AND i > 1                                     CSW202
     C                   EXSR      SrOrder                                                    CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW207
     C                   IF        CSW207 = 'Y'                                               CSW207
      *                                                                                       CSW207
      ** Another instruction can't be CMSW, CMTO or CMZB when one                             CSW207
      ** instruction  is EQUI.                                                                CSW207
      *                                                                                       CSW207
     C                   IF        PINSCA4 = 'EQUI' OR                                        CSW207
     C                             PINSCB4 = 'EQUI' OR                                        CSW207
     C                             PINSCC4 = 'EQUI' OR                                        CSW207
     C                             PINSCD4 = 'EQUI' OR                                        CSW207
     C                             PINSCE4 = 'EQUI'                                           CSW207
      *                                                                                       CSW207
     C                   IF        PINSCA4 = 'CMSW' OR                                        CSW207
     C                             PINSCA4 = 'CMTO' OR                                        CSW207
     C                             PINSCA4 = 'CMZB'                                           CSW207
     C                   EVAL      OKINCA4 = 'N'                                              CSW207
     C                   EVAL      Idx            = Idx + 1                                   CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PINSCA4'                                 CSW207
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0940'                                 CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   IF        PINSCB4 = 'CMSW' OR                                        CSW207
     C                             PINSCB4 = 'CMTO' OR                                        CSW207
     C                             PINSCB4 = 'CMZB'                                           CSW207
     C                   EVAL      OKINCB4 = 'N'                                              CSW207
     C                   EVAL      Idx            = Idx + 1                                   CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PINSCB4'                                 CSW207
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0940'                                 CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   IF        PINSCC4 = 'CMSW' OR                                        CSW207
     C                             PINSCC4 = 'CMTO' OR                                        CSW207
     C                             PINSCC4 = 'CMZB'                                           CSW207
     C                   EVAL      OKINCC4 = 'N'                                              CSW207
     C                   EVAL      Idx            = Idx + 1                                   CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PINSCC4'                                 CSW207
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0940'                                 CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   IF        PINSCD4 = 'CMSW' OR                                        CSW207
     C                             PINSCD4 = 'CMTO' OR                                        CSW207
     C                             PINSCD4 = 'CMZB'                                           CSW207
     C                   EVAL      OKINCD4 = 'N'                                              CSW207
     C                   EVAL      Idx            = Idx + 1                                   CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PINSCD4'                                 CSW207
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0940'                                 CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   IF        PINSCE4 = 'CMSW' OR                                        CSW207
     C                             PINSCE4 = 'CMTO' OR                                        CSW207
     C                             PINSCE4 = 'CMZB'                                           CSW207
     C                   EVAL      OKINCE4 = 'N'                                              CSW207
     C                   EVAL      Idx            = Idx + 1                                   CSW207
     C                   EVAL      FldNamXAr(Idx) = 'PINSCE4'                                 CSW207
     C                   EVAL      MsgIdXAr(Idx)  = 'RFV0940'                                 CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   ENDIF                                                                CSW207
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * InvldCode                                                     *
      *****************************************************************
     C     InvldCode     Begsr
     C                   Eval      Idx             =   Idx+1
     C                   Eval      RetCodeIn       =   '*Error'
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0902'                                  CSW202
     C                   ELSE                                                                 CSW202
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0944'                                  CSW207
     C                   ELSE                                                                 CSW207
     C                   Eval      MsgIdXAr(Idx)   =   'RFV0209'
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW202
     C                   Eval      FldNamXAr(Idx)  =   DDSName
     C                   Endsr
      *****************************************************************                       CSW202
      /EJECT                                                                                  CSW202
      *****************************************************************                       CSW202
      *  SrOrder - Check Order of Sequence                            *                       CSW202
      *****************************************************************                       CSW202
     C     SrOrder       BEGSR                                                                CSW202
                                                                                              CSW202
     C                   EVAL      X = 1                                                      CSW202
                                                                                              CSW202
     C                   DOW       RetCodeIn = *BLANKS AND X<=4                               CSW202
     C                   EVAL      Y = X + 1                                                  CSW202
     C     Found(X)      LOOKUP    WGrpOrd2                               02                  CSW202
     C     Found(X)      LOOKUP    WGrpOrd3                               03                  CSW202
     C     Found(X)      LOOKUP    WGrpOrd4                               04                  CSW202
     C     Found(Y)      LOOKUP    WGrpOrd1                               05                  CSW202
     C     Found(Y)      LOOKUP    WGrpOrd2                               06                  CSW202
     C     Found(Y)      LOOKUP    WGrpOrd3                               07                  CSW202
                                                                                              CSW202
     C                   IF        (*IN02 AND *IN05) OR                                       CSW202
     C                             (*IN03 AND (*IN05 OR *IN06)) OR                            CSW202
     C                             (*IN04 AND (*IN05 OR *IN06 OR *IN07))                      CSW202
     C                   EVAL      Idx            =   Idx+1                                   CSW202
     C                   EVAL      RetCodeIn      =   '*Error'                                CSW202
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0907'                               CSW202
     C                   EVAL      FldNamXAr(Idx) =   DDSName                                 CSW202
     C                   EVAL      OKINCA4 = 'N'                                              CSW202
     C                   EVAL      OKINCB4 = 'N'                                              CSW202
     C                   EVAL      OKINCC4 = 'N'                                              CSW202
     C                   EVAL      OKINCD4 = 'N'                                              CSW202
     C                   EVAL      OKINCE4 = 'N'                                              CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   EVAL      X = X + 1                                                  CSW202
                                                                                              CSW202
     C                   ENDDO                                                                CSW202
                                                                                              CSW202
     C                   ENDSR                                                                CSW202
                                                                                              CSW202
      *****************************************************************                       CSW202
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
      *  Screen fields
     C                   Parm                    DtlRcdIn
     C                   Parm                    PPTYP
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName
     C                   PARM                    OKFlags
 
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
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
                                                                                              CSW207
      ** Check if switchable feature CSW207 is switched on                                    CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRetrnCde                                    CSW207
                                                                                              CSW207
     C                   IF        PRetrnCde = 'CSW2007'                                      CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
 
      *
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
**  Valid instruction code array
CHQBCORTINTCNETSRTGSURGPPHONOTHR
**  Additional valid instruction code array                                                   CSW201
CMSWCMTOCMZB                                                                                  CSW201
**  Group Order 1                                                                             CSW202
CMSWCMTOCMZBINTCREPACORTURGP                                                                  CSW202
**  Group Order 2                                                                             CSW202
NETSRTGS                                                                                      CSW202
**  Group Order 3                                                                             CSW202
CHQBPHON                                                                                      CSW202
**  Group Order 4                                                                             CSW202
OTHR                                                                                          CSW202
