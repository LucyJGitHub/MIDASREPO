     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate book code')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVBKCD  - Validate Book Code field.                         *
      *                                                               *
      *  Component of: FT**** (Outgoing Payments)                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. AR1096475          Date 22Mar13               *
      *  Prev Amend No. AR1006885          Date 19Nov12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 06Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1096475 - Incorrect error message is shown when book code  *
      *              is left blank_45099999 Event                     *
      *  AR1006885 - No validation done on book code when it is blank *
      *              and system value is also blank.                  *
      *              (Child: AR1006888)                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.  (Recompiled)           *
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
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** Midas SD Book details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WBookCode       C                   Const('DftBookCodeforOPAY  ')                      CRE067
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A                                                      CRE067
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D C#RTCD          S              7
     D C#OPTN          S              7
     D C#BOKC          S              2
                                                                                              CRE067
      ** Parameters for AOSVALR0                                                              CRE067
     D PSysVal01       S             20A                                                      CRE067
     D PCurSet01       S            200A                                                      CRE067
     D PSysVal02       S             20A                                                      CRE067
     D PCurSet02       S            200A                                                      CRE067
     D PSysVal03       S             20A                                                      CRE067
     D PCurSet03       S            200A                                                      CRE067
     D PSysVal04       S             20A                                                      CRE067
     D PCurSet04       S            200A                                                      CRE067
     D PSysVal05       S             20A                                                      CRE067
     D PCurSet05       S            200A                                                      CRE067
     D PSysVal06       S             20A                                                      CRE067
     D PCurSet06       S            200A                                                      CRE067
     D PSysVal07       S             20A                                                      CRE067
     D PCurSet07       S            200A                                                      CRE067
     D PSysVal08       S             20A                                                      CRE067
     D PCurSet08       S            200A                                                      CRE067
     D PSysVal09       S             20A                                                      CRE067
     D PCurSet09       S            200A                                                      CRE067
     D PSysVal10       S             20A                                                      CRE067
     D PCurSet10       S            200A                                                      CRE067
                                                                                              CRE067
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
 
      * Initialization
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
 
      * Validate Book Code
     C                   EXSR      VBOOKCD
 
      * If an error was found, set the return code appropriately
     C                   If        OKBokc = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VBOOKCD - BOOK CODE VALIDATION
      *****************************************************************
     C     VBOOKCD       BEGSR
 
      * Book Code must be entered
     C                   If        SBOKC = *Blanks
     C**********         Move      'N'           OKBokc                                       CRE067
     C**********         Add       1             Idx                                          CRE067
     C**********         Movel     'SBOKC'       FldNamXAr(Idx)                               CRE067
     C**********         Movel     'MMA0900'     MsgIdXAr(Idx)                                CRE067
     C                   EXSR      SrGetSysVal                                                CRE067
     C                   EVAL      SBOKC = %TRIM(PCurSet01)                                   CRE067
     C                   End
 
      *  Access the Book Code file for validation
     C                   If        SBOKC <> *Blanks
 
     C                   CALLB     'AOBOOKR0'                             90
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      SBOKC         C#BOKC
     C     SDBOOK        Parm      SDBOOK        DSFDY
 
 
      * If return code is not blank - process for an error
      * else map the book code from the data structure to screen field
     C                   If        C#RTCD <> *Blanks
     C                   Move      'N'           OKBokc
     C                   Add       1             Idx
     C                   Movel     'SBOKC'       FldNamXAr(Idx)
     C                   Movel     'MMA0901'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      SBOKC = BDBKCD
     C                   End
      *                                                                                    AR1006885
      ** If SBOKC is still blank, issue error message                                      AR1006885
      *                                                                                    AR1006885
     C                   ELSE                                                              AR1006885
     C                   MOVE      'N'           OKBokc                                    AR1006885
     C                   ADD       1             Idx                                       AR1006885
     C                   MOVEL     'SBOKC'       FldNamXAr(Idx)                            AR1006885
     C**********         MOVEL     'MMA0900'     MsgIdXAr(Idx)                   AR1006885 AR1096475
     C                   Movel     '5045908'     MsgIdXAr(Idx)                             AR1096475
 
     C                   End
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CRE067
      *                                                               *                       CRE067
      * SrGetSysVal - Subroutine to get the system value for Default  *                       CRE067
      *               Book Code for OPAY                              *                       CRE067
      *                                                               *                       CRE067
      * Called by: VBOOKCD                                            *                       CRE067
      *                                                               *                       CRE067
      * Calls: AOSVALR0                                               *                       CRE067
      *                                                               *                       CRE067
      *****************************************************************                       CRE067
     C     SrGetSysVal   BEGSR                                                                CRE067
                                                                                              CRE067
     C                   CALLB     'AOSVALR0'                                                 CRE067
     C                   PARM      *BLANKS       PRTCD                                        CRE067
     C                   PARM      WBookCode     PSysVal01                                    CRE067
     C                   PARM                    PCurSet01                                    CRE067
     C                   PARM                    PSysVal02                                    CRE067
     C                   PARM                    PCurSet02                                    CRE067
     C                   PARM                    PSysVal03                                    CRE067
     C                   PARM                    PCurSet03                                    CRE067
     C                   PARM                    PSysVal04                                    CRE067
     C                   PARM                    PCurSet04                                    CRE067
     C                   PARM                    PSysVal05                                    CRE067
     C                   PARM                    PCurSet05                                    CRE067
     C                   PARM                    PSysVal06                                    CRE067
     C                   PARM                    PCurSet06                                    CRE067
     C                   PARM                    PSysVal07                                    CRE067
     C                   PARM                    PCurSet07                                    CRE067
     C                   PARM                    PSysVal08                                    CRE067
     C                   PARM                    PCurSet08                                    CRE067
     C                   PARM                    PSysVal09                                    CRE067
     C                   PARM                    PCurSet09                                    CRE067
     C                   PARM                    PSysVal10                                    CRE067
     C                   PARM                    PCurSet10                                    CRE067
                                                                                              CRE067
     C                   IF        PRTCD <> *BLANKS AND                                       CRE067
     C                             PRTCD <> '*NRF   '                                         CRE067
     C                   EVAL      DBKEY = PSysVal01                                          CRE067
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CRE067
     C                   EVAL      DBASE = 1                                                  CRE067
     C                   EXSR      *PSSR                                                      CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ENDSR                                                                CRE067
      *****************************************************************                       CRE067
      /EJECT                                                                                  CRE067
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      ** OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
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
