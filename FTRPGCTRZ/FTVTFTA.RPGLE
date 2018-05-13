     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate transfer commission tariff')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTFTA  - Validate Transfer Commission Tariff               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD034973           Date 16Jul15               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
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
      *  MD034973 - FT Payment Charges defaulting error               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
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
      *
     F***PYCHGDB   IF   E           K DISK    INFSR(*PSSR)                                  MD034973
     FPYCHGL1   IF   E           K DISK    INFSR(*PSSR)                                     MD034973
      *
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
     D*TranInSeca****E*DS***               EXTNAME(FTOPY2PD)                    CFT014
     D TranInThia    E DS                  EXTNAME(FTOPY4PD)                    CFT014

      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)                   CFT014

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
      * Valid Payments layout                                                               MD034973
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)                               MD034973

      *                                                                                     MD034973
     D P0DTA           DS           256                                                     MD034973
      ** Calling parameter DS for FT0035                                                    MD034973
     D  WIPT1                  1      1                                                     MD034973
     D  WIPTY1                 2     36                                                     MD034973
     D  WIPT2                 37     37                                                     MD034973
     D  WIPTY2                38     72                                                     MD034973
     D  WICCY                 73     75                                                     MD034973
     D  WOCUST                76     81                                                     MD034973
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
     D PCNUM           S              6A                                                    MD034973
     D PPYTP           S              2A                                                    MD034973
     D PPYST           S              2A                                                    MD034973

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

      *                                                                                     MD034973
      ** Get Charge Customer number                                                         MD034973
      *                                                                                     MD034973
     C                   Exsr      GetChargeCust                                            MD034973
      * Validate Transfer Commission Tariff
      * only if CFT009 Fees & Charges feature is off                            CFT009
                                                                                CFT009
     C                   IF        @CFT009 <> 'Y'                               CFT009
     C                   EXSR      VTRFCT
     C                   ELSE                                                   CFT009
     C                   EVAL      STRCT = *BLANKS                              CFT009
     C                   ENDIF                                                  CFT009

      * If an error was found, set the return code appropriately
     C                   If        OKTrct = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VTRFCT - Transfer Commission Tariff
      *****************************************************************
     C*
     C     VTRFCT        BEGSR

      *  If transfer commission blank and action insert default
      *
     C     SACTION       IFEQ      'I'
     C     STRCT         ANDEQ     *BLANKS
      *
     C                   EVAL      PPYTP = 'OP'                                             MD034973
     C                   EVAL      PPYST = SPYST                                            MD034973
     C     PPYKEY        CHAIN     PYCHGL1                            90                    MD034973
     C   90              EVAL      PPYTP = *BLANKS                                          MD034973
     C   90              EVAL      PPYST = *BLANKS                                          MD034973
     C   90PPYKEY        CHAIN     PYCHGL1                            90                    MD034973
     C   90              EVAL      PPYTP = 'OP'                                             MD034973
     C   90              EVAL      PCNUM = *BLANKS                                          MD034973
     C   90              EVAL      PPYST = SPYST                                            MD034973
     C   90PPYKEY        CHAIN     PYCHGL1                            90                    MD034973
     C   90              EVAL      PPYST = *BLANKS                                          MD034973
     C   90PPYKEY        CHAIN     PYCHGL1                            90                    MD034973
     C*****@PYBR         CHAIN     PYCHGDB                            90        Get defaultsMD034973
     C   90@PYBR         CHAIN     PYCHGL1                            90                    MD034973
      *
      *  No record found - DB error only if not multibranched
      *
     C     *IN90         IFEQ      '1'
     C     @MBIN         ANDNE     'Y'
     C**********         MOVEL     'PYCHGDB '    DBFILE                         ************MD034973
     C                   MOVEL     'PYCHGL1 '    DBFILE                                     MD034973
     C                   MOVEL     PYBR          DBKEY                          * DB ERROR 22 *
     C                   MOVEL     '022'         DBASE                          ***************
     C                   EXSR      *PSSR
     C                   END
      *
      *  No payment charges information
      *
     C     *IN90         IFEQ      '1'
      *
     C                   Move      'N'           OKTrct
     C                   Add       1             Idx
     C                   Movel     'STRCT'       FldNamXAr(Idx)
     C                   Movel     'FTM2001'     MsgIdXAr(Idx)
     C                   END
      *
      *  Payment charges information
      *
     C     *IN90         IFEQ      '0'
     C/COPY WNCPYSRC,FT0345C034
     C                   MOVEL     DFTRCT        STRCT
     C                   END
     C                   END

      *  Tariff  if entered must be 1/2/3/4/5.

     C                   If        STRCT <> '1' and
     C                             STRCT <> '2' and
     C                             STRCT <> '3' and
     C                             STRCT <> '4' and
     C                             STRCT <> '5'

      * Send error to screen
     C                   Move      'N'           OKTrct
     C                   Add       1             Idx
     C                   Movel     'STRCT'       FldNamXAr(Idx)
     C                   Movel     'MMA1025'     MsgIdXAr(Idx)
     C                   End

     C                   ENDSR
      *****************************************************************
      * VOVRRDE - END OF OVERRIDE FLAG VALIDATION                     *
      *****************************************************************
      *****************************************************************                     MD034973
      ** GetChargeCust- Get Customer to Default Charges                                     MD034973 
      ** 
      *****************************************************************                     MD034973
     C     GetChargeCust BEGSR                                                              MD034973
                                                                                            MD034973 
      *                                                                                     MD034973
      ** Get Customer                                                                       MD034973
      *                                                                                     MD034973
     C                   MOVE      *BLANKS       P0DTA                                      MD034973
     C                   SELECT                                                             MD034973
                                                                                            MD034973
      * Only use ordering customer if S01506                                                MD034973
     C     @01506        WHENEQ    'Y'                                                      MD034973
     C                   MOVEL     OTORCT        WIPT1                                      MD034973
     C                   MOVEL     SORC1         WIPTY1                                     MD034973
     C                   MOVEL     SSMCY         WICCY                                      MD034973
                                                                                            MD034973
      * If add use ordering side                                                            MD034973
     C     OTADDC        WHENEQ    'A'                                                      MD034973
     C                   MOVEL     OTORCT        WIPT1                                      MD034973
     C                   MOVEL     SORC1         WIPTY1                                     MD034973
     C                   MOVEL     SSMCY         WICCY                                      MD034973
     C     OTORBT        IFNE      *BLANKS                                                  MD034973
     C                   MOVE      *BLANKS       WORBKC           15                        MD034973
     C                   MOVEL     OTORBK        WFLDO            12                        MD034973
     C     WFLDO         CAT       OTORBB        WORBKC                                     MD034973
     C                   MOVEL     OTORBT        WIPT2                                      MD034973
     C                   MOVEL     WORBKC        WIPTY2                                     MD034973
     C                   END                                                                MD034973
                                                                                            MD034973
      * If deduct use pay to instructions                                                   MD034973
     C     OTADDC        WHENEQ    'D'                                                      MD034973
     C                   MOVEL     OTDSTT        WIPT1                                      MD034973
     C                   MOVEL     OTDST1        WIPTY1                                     MD034973
     C                   MOVEL     OTPCCY        WICCY                                      MD034973
     C     OTSNCT        IFNE      *BLANKS                                                  MD034973
     C                   MOVEL     OTSNCT        WIPT2                                      MD034973
     C                   MOVEL     OTSNCO        WIPTY2                                     MD034973
     C                   END                                                                MD034973
     C                   ENDSL                                                              MD034973
      ** Call FT0035 to get customer number to be debited the charges.                      MD034973
      *                                                                                     MD034973
     C                   CALL      'FT0035'                             9090                MD034973
     C                   PARM      *BLANKS       PRTCD             7                        MD034973
     C                   PARM                    P0DTA                                      MD034973
     C                   PARM                    P0MSG           256                        MD034973
      *                                                                                     MD034973
     C     OTODMT        IFNE      *BLANKS                                                  MD034973
     C     OTADDC        ANDEQ     'A'                                                      MD034973
     C                   MOVE      OTODMT        PCNUM                                      MD034973
     C                   ELSE                                                               MD034973
     C                   IF        (PRTCD = *BLANKS)                                        MD034973
     C                   MOVE      WOCUST        PCNUM                                      MD034973
     C                   ELSE                                                               MD034973
     C                   MOVE      *BLANKS       PCNUM                                      MD034973
     C                   ENDIF                                                              MD034973
     C                   ENDIF                                                              MD034973
      *                                                                                     MD034973
     C                   ENDSR                                                              MD034973
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

      *  Primary Screen fields
     C                   Parm                    TranInPrim

      *  Screen fields
     C***********        Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInThiA                     CFT014

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
      * Valid Deals layout (DS) from/to caller                                              MD034973
     C                   PARM                    ValidPmnt                                  MD034973


     C     PPYKEY        KLIST                                                              MD034973
     C                   KFLD                    @PYBR                                      MD034973
     C                   KFLD                    PCNUM                                      MD034973
     C                   KFLD                    PPYTP                                      MD034973
     C                   KFLD                    PPYST                                      MD034973
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
