     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OP regulatory reporting')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVRRPT   - Validate OP Regulatory Reporting                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD025880           Date 19Aug14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255286             Date 07Jul08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025880 - Validation of Regulatory Reporting field on FT    *
      *             Outgoing Payments is incorrect.                   *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255286 - Allow lowercase characters on input.                *
      *           Recompile due to change in /copy SFTVALCSLE         *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCTRYL2  IF   E           K DISK                                                     MD025880
 
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
 
     D WORDER          C                   CONST('/ORDERRES/')
     D WBENEF          C                   CONST('/BENEFRES/')
 
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
                                                                                              CSD089
      ** Array of Fields in warning.                                                          CSD089
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CSD089
                                                                                              CSD089
      ** Array of warning message IDs                                                         CSD089
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CSD089
                                                                                              CSD089
      ** Array of warning message data.                                                       CSD089
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CSD089
 
      ** Incoming Transaction (Third screen level 2)
     D TranInThiB    E DS                  EXTNAME(FTOPY5PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data-structure for Country Codes file
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Short Data structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D/COPY FTCPYSRC,SFTADDRILE
 
     D WSRRPT          DS           105
     D  WSRRP1                 1     35
     D  WSRRP2                36     70
     D  WSRRP3                71    105
     D  WCWORD                 1     10
     D  WISOCD                11     12
     D  WADSLH                13     14
     D  WADINF                15     35
     D  WADIN2                38     70
     D  WADIN3                73    105
     D  WRL23                 36    105
 
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
 
     C                   Eval      WSRRP1 = SRRP1
     C                   Eval      WSRRP2 = SRRP2
     C                   Eval      WSRRP3 = SRRP3
 
      ** Regulatory Reporting validation
 
     C                   ExSr      SrRegRpt
 
      ** If an erro was found, set the return code appropriately
 
     C                   If        (OKRRP1 = 'N') Or (OKRRP2 = 'N') Or
     C                             (OKRRP3 = 'N')
     C                   Eval      RetCodeIn = 'Error'
     C                   Elseif    (OKRRP1 = 'W') Or (OKRRP2 = 'W') Or                        CSD089
     C                             (OKRRP3 = 'W')                                             CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrRegRpt
      *****************************************************************
      *                                                               *
      * SR/SrRegRpt   - Validate Regulatory Reporting                 *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ADCHK       - Address validation, checks for invalid char.    *
      *                                                               *
      *****************************************************************
 
     C     SrRegRpt      BegSr
 
      ** Entry is optional but if entered, it must follow the correct
      ** syntax (Codeword + ISO Country Code + Additional Info) entered on
      ** the first line.
 
     C                   If        (WSRRPT <> *Blank)
 
      ** Check if an invalid character exists
 
     C                   Eval      ADLINE = *Blank
     C                   Eval      ADFLDM = 'FTM3246'
     C                   Eval      ADFLDF = 'FTUSRMSG'
 
     C                   Eval      ADDRSS = *Blanks
     C                   Eval      ADDRSS = WSRRPT
 
     C                   ExSr      ADCHK
 
      ** Illigal Characters found
 
     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKRRP1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRRP1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRRP1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRRP1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKRRP2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRRP2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRRP2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRRP2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKRRP3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SRRP3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKRRP3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SRRP3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   EndIf
 
     C                   If        SRRP1 <> *Blank
 
      ** '?' not available
 
     C     '?'           Scan      SRRP1         Y#                3 0    90
      *
     C                   If        *IN90 = True
     C                   Move      'N'           OKRRP1
     C                   Add       1             Idx
     C                   Movel     'SRRP1'       FldNamXAr(Idx)
     C                   Movel     'FTM3225'     MsgIdXAr(Idx)
     C                   EndIf
 
      ** No error
 
     C                   If        OKRRP1 <> 'N'
     C                   If        (WCWORD = WORDER) Or (WCWORD = WBENEF)
 
      ***Access*ISO*Country*Code*via*access*object*AOCTRYR0***                              MD025880
 
     C**********         Call      'AOCTRYR0'                                               MD025880
     C**********         Parm      *Blanks       WRTRN             7                        MD025880
     C**********         Parm      '*KEY   '     WOPTN             7                        MD025880
     C**********         Parm      WISOCD        WCTCD             2                        MD025880
     C*****SDCTRY        Parm      SDCTRY        DSFDY                                      MD025880
 
      ** Validate Syntax
 
     C**********         If        (WRTRN <> *Blank) Or (WADSLH <> '//')                    MD025880
     C     WISOCD        CHAIN     SDCTRYL2                                                 MD025880
     C                   If        (NOT %FOUND(SDCTRYL2)) Or (WADSLH <> '//')               MD025880
     C                             And (WADSLH <> *Blank)
     C                   Move      'N'           OKRRP1
     C                   Add       1             Idx
     C                   Movel     'SRRP1'       FldNamXAr(Idx)
     C                   Movel     'FTM3227'     MsgIdXAr(Idx)
     C                   EndIf
 
     C**********         If        (WRTRN = *Blank) And (WADSLH = '//')                     MD025880
     C                   If        (%FOUND(SDCTRYL2)) And (WADSLH = '//')                   MD025880
     C                             And (WADINF = *Blank)
     C                   Move      'N'           OKRRP1
     C                   Add       1             Idx
     C                   Movel     'SRRP1'       FldNamXAr(Idx)
     C                   Movel     'FTM2170'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** 1st line is blank and the remaining lines are entered.
 
     C                   Else
     C                   If        WRL23 <> *Blank
     C                   Move      'N'           OKRRP1
     C                   Add       1             Idx
     C                   Movel     'SRRP1'       FldNamXAr(Idx)
     C                   Movel     'FTM3228'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
 
      ** Additional info line 2 is entered.
 
     C                   If        SRRP2 <> *Blank
     C                   If        (WCWORD = WORDER) Or (WCWORD = WBENEF)
     C                   If        (%Subst(SRRP2:1:2)) <> '//'
     C                   Move      'N'           OKRRP2
     C                   Add       1             Idx
     C                   Movel     'SRRP2'       FldNamXAr(Idx)
     C                   Movel     'FTM3230'     MsgIdXAr(Idx)
     C                   Else
     C                   If        WADIN2 = *Blank
     C                   Move      'N'           OKRRP2
     C                   Add       1             Idx
     C                   Movel     'SRRP2'       FldNamXAr(Idx)
     C                   Movel     'FTM2170'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
      ** 2nd line is blank and the remaining line is entered.
 
     C                   Else
     C                   If        SRRP3 <> *Blank
     C                   Move      'N'           OKRRP2
     C                   Add       1             Idx
     C                   Movel     'SRRP2'       FldNamXAr(Idx)
     C                   Movel     'FTM3229'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
 
      ** Additional info line 3 is entered.
 
     C                   If        SRRP3 <> *Blank
 
      ** Error, additional info must be preceded by '//'
 
     C                   If        (WCWORD = WORDER) Or (WCWORD = WBENEF)
     C                   If        (%Subst(SRRP3:1:2)) <> '//'
     C                   Move      'N'           OKRRP3
     C                   Add       1             Idx
     C                   Movel     'SRRP3'       FldNamXAr(Idx)
     C                   Movel     'FTM3230'     MsgIdXAr(Idx)
     C                   Else
     C                   If        WADIN3 = *Blank
     C                   Move      'N'           OKRRP3
     C                   Add       1             Idx
     C                   Movel     'SRRP3'       FldNamXAr(Idx)
     C                   Movel     'FTM2170'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   EndSr
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    TranInThiB
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtXAr                                    CSD089
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
