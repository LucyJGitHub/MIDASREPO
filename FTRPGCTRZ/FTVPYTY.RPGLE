     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate payment type/sub-type')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVPYTY  - Validate Payment Type/Sub Type fields.            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CDL038             Date 10May05               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
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
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** External data structure for deal types/sub types file
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
     D C#OPTN          S              7
     D C#PYST          S              2
     D C#RTCD          S              7
 
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
 
      * PYTPV - Payment Type Validation
     C                   EXSR      VTYPE
 
      * PYSTV - Payment Sub Type Validation
     C                   EXSR      VSUBTYP
 
      * PTPSV - Paymennt Type/ Payment Sub Type combined validation
     C                   If        OKPytp = 'Y' and
     C                             OKPyst = 'Y' and
     C                             SPYST <> *Blanks
     C                   EXSR      VPSTYPE
     C                   End
      *
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKPytp = 'N' or
     C                             OKPyst = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VTYPE - PAYMENT TYPE VALIDATION
      *****************************************************************
     C     VTYPE         BEGSR
      *
      * On insert only if Payment Type not entered set to 'OP'.
      *
     C                   If        SACTION = 'I' and
     C                             SPYTP   = *Blanks
      *
     C                   Move      'OP'          SPYTP
      *
     C                   Else
      *
      * Payment Type can't be blank for action codes other than 'I'
      *
     C                   If        SPYTP = *Blanks
      * Send error to screen
     C                   Move      'N'           OKPytp
     C                   Add       1             Idx
     C                   Movel     'SPYTP'       FldNamXAr(Idx)
     C                   Movel     'MMA0902'     MsgIdXAr(Idx)
     C                   Else
      *
      * If Payment Type is not blank it must take one of the following values
      *
     C                   If        SPYTP <> 'OP' and
     C                             SPYTP <> 'RP'
      * Send error to screen
     C                   Move      'N'           OKPytp
     C                   Add       1             Idx
     C                   Movel     'SPYTP'       FldNamXAr(Idx)
     C                   Movel     'MMA0903'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   End
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VSUBTYP - PAYMENT SUB TYPE VALIDATION
      *****************************************************************
     C     VSUBTYP       BEGSR
      *
      ** Payment sub type must be defined
      *
     C                   If        SPYST = *Blanks
      * Send error to screen
     C                   Move      'N'           OKPyst
     C                   Add       1             Idx
     C                   Movel     'SPYST'       FldNamXAr(Idx)
     C                   Movel     'MMA0904'     MsgIdXAr(Idx)
     C                   Else
      *
      ** Check that the payment subtype exists
      *
     C                   CALLB     'AODLSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*VERIFY'     C#OPTN
     C                   Parm      SPYST         C#PYST
     C     SDDLST        Parm      *Blanks       DSFDY
 
     C                   If        C#RTCD <> *Blanks
      * Send error to screen
     C                   Move      'N'           OKPyst
     C                   Add       1             Idx
     C                   Movel     'SPYST'       FldNamXAr(Idx)
     C                   Movel     'MMA0905'     MsgIdXAr(Idx)
     C                   Else
     C                   Move      C#PYST        SPYST
     C                   End
 
     C                   End
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VPSTYPY - PAYMENT TYPE/ PAYMENT SUB TYPE COMBINED VALIDATION
      *****************************************************************
     C     VPSTYPE       BEGSR
      *
      * The Payment type/sub-type combination must exist
      *
     C     FDDTSK        KLIST
     C                   Kfld                    SPYTP
     C                   Kfld                    SPYST
 
     C     FDDTSK        Chain     FDDTSTPD                           99
      *
      * If no record found,
      *
     C                   If        *IN99 = *ON or
     C                             RCID11 = '*'
      * Send error to screen
     C                   Move      'N'           OKPytp
     C                   Move      'N'           OKPyst
     C                   Add       1             Idx
     C                   Movel     'SPYTP'       FldNamXAr(Idx)
     C                   Movel     'MMA0906'     MsgIdXAr(Idx)
     C                   End
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
(c) Finastra International Limited 2001
