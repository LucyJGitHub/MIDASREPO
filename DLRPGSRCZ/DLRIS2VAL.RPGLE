     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 2 Validate')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRIS2VAL - Midas DL Reporting Information Screen 2 Validate *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 MD024179           Date 19Dec13               *
      *                 MD024166           Date 19Dec13               *
      *                 MD024151           Date 18Dec13               *
      *                 MD024146           Date 17Dec13               *
      *                 MD022251A          Date 02Oct13               *
      *                 MD022633           Date 01Oct13               *
      *                 MD022429           Date 17Sep13               *
      *                 MD022393           Date 16Sep13               *
      *                 MD022359           Date 13Sep13               *
      *                 MD021933           Date 05Sep13               *
      *                 MD022251           Date 04Sep13               *
      *                 MD022120           Date 29Aug13               *
      *                 MD022024           Date 28Aug13               *
      *                 CSW213 *CREATE     Date 03Jun12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD024179 - Reporting party party ID defaulted again after    *
      *             it was amended to blank.                          *
      *  MD024166 - Reporting Party ID value returns back to its      *
      *             initial value before amended to blank.            *
      *  MD024151 - Missing parameter for DLRPIFDFT/DLRPIFVU.         *
      *  MD024146 - Reporting Party IDs blanked out after confirm     *
      *             complete.                                         *
      *  MD022251A - Redeliver missing MD022251 codes.                *
      *  MD022633 - Allow reporting details with '0' Transaction      *
      *             Identifier type for different reporting           *
      *             jurisdiction and reporting party ID combinations. *
      *  MD022429 - Serious midasplus error when reporting info       *
      *             2-4 is populated                                  *
      *  MD022393 - Reporting Party details not defaulted in amend    *
      *             mode for Transaction Id Type '0'.                 *
      *  MD022359 - Reporting party SWIFT ID accepts invalid chars    *
      *  MD021933 - Link Swap ID, UTI Namespace, and Transaction ID   *
      *             of the 2nd leg swap deal not defaulted from       *
      *             first leg swap deal.                              *
      *  MD022251 - Transaction Id Type defaulted to 0 but Namespace  *
      *             and Id are validated first and will cause error.  *
      *  MD022120 - Reporting party details not populated             *
      *  MD022024 - Full upload issue on Bank Directory Plus Loader   *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Bank Directory Plus
     F***MEBIB3L1  IF   E           K DISK                                                  MD022024
     FMEBIB3L1  IF   E           K DISK    USROPN                                           MD022024
 
      ** Dealing Reporting Info
     FDLRPIFL0  IF   E           K DISK
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      * Named Constant used to determine if a field contains invalid
      * characters for Telex and S.W.I.F.T.
 
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                      abcdefghijklmnopqrstuvwxyz-
     D                                      1234567890 /+-?:().,'''
 
      * Named Constant used to determine if a field contains
      * characters which are not AlphaNumeric
 
     D AlphaN          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     1234567890'
 
      * Reporting Party LEI and Reporting Party SWIFT is invalid
 
     D Alpha           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      * Named Constant used to determine if an input for
      * Reporting Party LEI and Reporting Party SWIFT is invalid
 
     D Digits          C                   '1234567890'
 
      * Named Constant used to determine if an input for
      * Event type is invalid
 
     D EvnTyp          C                   '012345'
 
      * Named Constant used to determine if an input for
      * Transaction Identifier type is invalid
 
     D TrnTyp          C                   '0123'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Transaction Reporting Information Link file
     D DLRILKPDIn    E DS                  EXTNAME(DLRILKPD)
 
      ** Fields to validate in screen 1
     D DLRDetail1    E DS                  EXTNAME(DLRIS1PD)
 
      ** Fields to validate in screen 2
     D DLRDetail2    E DS                  EXTNAME(DLRIS2PD)
     D COMBI1                  1     45A                                                    MD022633
     D***COMBI2                185    229A                                           MD022633 CSW214
     D***COMBI3                369    413A                                           MD022633 CSW214
     D***COMBI4                553    597A                                           MD022633 CSW214
     D***COMBI2                195    239A                                             CSW214 CSW216
     D***COMBI3                389    433A                                             CSW214 CSW216
     D***COMBI4                583    627A                                             CSW214 CSW216
     D COMBI2                205    249A                                                      CSW216
     D COMBI3                409    453A                                                      CSW216
     D COMBI4                613    657A                                                      CSW216
                                                                                            MD022633
     D ArrTType        S              1A   DIM(3)                                           MD022633
 
      ** Fields to validate in screen 2
     D DLRError2     E DS                  EXTNAME(DLERI2PD)
 
      ** Fields for defaulting (Screen 1)                                                   MD022393
     D DLDefault1    E DS                  EXTNAME(DLRIS1PD) PREFIX(D_)                     MD022393
                                                                                            MD022393
      ** Fields for defaulting (Screen 2)                                                   MD022393
     D DLDefault2    E DS                  EXTNAME(DLRIS2PD) PREFIX(D_)                     MD022393
                                                                                            MD022393
      ** Fields for defaulting (Screen 3)                                                   MD022393
     D DLDefault3    E DS                  EXTNAME(DLRIS3PD) PREFIX(D_)                     MD022393
                                                                                            MD022393
      ** Fields for defaulting (Screen 4)                                                     CSW214
     D DLDefault4    E DS                  EXTNAME(DLRIS4PD) PREFIX(D_)                       CSW214
                                                                                              CSW214
      ** Valid Deals layout
     D DLVRFileFmt   E DS                  EXTNAME(DLVRPIPD)
 
      ** Customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Customer Extension SWIFT Details
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
 
      ** Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D BQQDFAC       E                     EXTFLD(QQDFAC)
 
      ** First DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Long DS for Access programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Fields in error
     D FldNamXAr       S             10A
 
      ** Error message IDs
     D MsgIDXAr        S                   LIKE(#MsgId)
 
      ** Error message data
     D MsgDtaXAr       S                   LIKE(#MsgData)
 
      ** Field with warning
     D WFldNmXAr       S             10A
 
      ** Warning message ID
     D WMsgIDXAr       S                   LIKE(#MsgId)
 
      ** Warning message data
     D WMsgDtXAr       S                   LIKE(#MsgData)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Work Variables
     D WRetCode        S             10A
     D WRpSwf          S             11A   INZ
     D F18Chr          S             18A
     D F6Char          S              6A
     D WLength         S              2S 0
     D FValid          S             10A
     D FValFld         S              6A
     D FValidOK        S              1A
     D R2RPSOK         S              1A
     D R2CUS1          S              6A
     D R2CUS2          S              6A
     D R2CUS3          S              6A
     D R2CUS4          S              6A
     D FldChk          S             35A
     D WCustn          S              6A
     D WStr            S              5S 0
     D WLen            S              5S 0
     D I               S              3S 0
     D WInvalChar      S              2S 0
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PCusn           S             10A
     D PKySt           S              7A
     D PBrCd           S              3A
     D PSard           S              6A
      *
     D KB3BIC          S              8A   INZ
     D KB3BRC          S              3A   INZ
     D WR2DFTR1        S              1A                                                    MD022120
     D WR2DFTR2        S              1A                                                    MD022120
     D WR2DFTR3        S              1A                                                    MD022120
     D WR2DFTR4        S              1A                                                    MD022120
      *
     D WR2DFT1         S              1A
     D WR2RPA1         S             34A
     D WR2RPL1         S             20A
     D WR2RPN1         S             20A
     D WR2RPP1         S             10A
     D WR2RPS1         S             11A
     D WR2TRC1         S             10A
     D WR2DFT2         S              1A
     D WR2RPA2         S             34A
     D WR2RPL2         S             20A
     D WR2RPN2         S             20A
     D WR2RPP2         S             10A
     D WR2RPS2         S             11A
     D WR2TRC2         S             10A
     D WR2DFT3         S              1A
     D WR2RPA3         S             34A
     D WR2RPL3         S             20A
     D WR2RPN3         S             20A
     D WR2RPP3         S             10A
     D WR2RPS3         S             11A
     D WR2TRC3         S             10A
     D WR2DFT4         S              1A
     D WR2RPA4         S             34A
     D WR2RPL4         S             20A
     D WR2RPN4         S             20A
     D WR2RPP4         S             10A
     D WR2RPS4         S             11A
     D WR2TRC4         S             10A
 
     D WRLTRRF         S             10A
                                                                                            MD022633
     D X               S              1S 0                                                  MD022633
     D WR2TTY1         S              1A                                                    MD022633
     D WR2TTY2         S              1A                                                    MD022633
     D WR2TTY3         S              1A                                                    MD022633
     D WR2TTY4         S              1A                                                    MD022633
     D WCUSNO1         S              6A                                                    MD022633
     D WCUSNO2         S              6A                                                    MD022633
     D WCUSNO3         S              6A                                                    MD022633
     D WCUSNO4         S              6A                                                    MD022633
     D WRType1         S              1A                                                    MD024179
     D WRType2         S              1A                                                    MD024179
     D WRType3         S              1A                                                    MD024179
     D WRType4         S              1A                                                    MD024179
     D CSW214          S              1A                                                      CSW214
     D CSW216          S              1A                                                      CSW216
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Call Validation Modules in Sequence
      *
     C                   IF        RLACTN = 'A' AND
     C                             RLTRRF <> WRLTRRF
     C                   EVAL      WRLTRRF = RLTRRF
 
     C     KRPIF         CHAIN     DLRPIFL0
     C                   IF        %FOUND
     C                   EVAL      WR2RPA1 = RIRA01
     C                   EVAL      WR2RPL1 = RIRL01
     C                   EVAL      WR2RPN1 = RIRN01
     C                   EVAL      WR2RPP1 = RIRP01
     C                   EVAL      WR2RPS1 = RIRS01
     C                   EVAL      WR2TRC1 = RIRC01
     C                   EVAL      WR2RPA2 = RIRA02
     C                   EVAL      WR2RPL2 = RIRL02
     C                   EVAL      WR2RPN2 = RIRN02
     C                   EVAL      WR2RPP2 = RIRP02
     C                   EVAL      WR2RPS2 = RIRS02
     C                   EVAL      WR2TRC2 = RIRC02
     C                   EVAL      WR2RPA3 = RIRA03
     C                   EVAL      WR2RPL3 = RIRL03
     C                   EVAL      WR2RPN3 = RIRN03
     C                   EVAL      WR2RPP3 = RIRP03
     C                   EVAL      WR2RPS3 = RIRS03
     C                   EVAL      WR2TRC3 = RIRC03
     C                   EVAL      WR2RPA4 = RIRA04
     C                   EVAL      WR2RPL4 = RIRL04
     C                   EVAL      WR2RPN4 = RIRN04
     C                   EVAL      WR2RPP4 = RIRP04
     C                   EVAL      WR2RPS4 = RIRS04
     C                   EVAL      WR2TRC4 = RIRC04
     C                   EVAL      WRType1 = RITIT1                                         MD024179
     C                   EVAL      WRType2 = RITIT2                                         MD024179
     C                   EVAL      WRType3 = RITIT3                                         MD024179
     C                   EVAL      WRType4 = RITIT4                                         MD024179
     C                   ENDIF
 
     C                   ENDIF
     C
     C                   EXSR      SRTransType                                              MD022633
                                                                                            MD022633
     C                   IF        R2TTY1 = '0'                                             MD022393
     C**********                   AND R2TTY2 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY3 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY4 <> '0'                               MD022393 MD022633
     C                             AND WR2TTY1 <> '0'                                       MD022633
     C                             AND RLACTN = 'A'                                         MD022393
     C                             AND (R2RPJ1 = *BLANKS OR                                 MD022393
     C                                  R2RPP1 = *BLANKS OR                                 MD022393
     C                                  R2RPA1 = *BLANKS)                                   MD022393
     C                             AND WRType1 <> '0'                                       MD024179
                                                                                            MD022393
     C                   EVAL      WRType1 = '0'                                            MD024179
     C                   CALLB     'DLRPIFDFT'                                              MD022393
     C                   PARM      *BLANKS       PRtCd                                      MD022393
     C                   PARM                    DLRILKPDIn                                 MD022393
     C                   PARM                    DLDefault1                                 MD022393
     C                   PARM                    DLDefault2                                 MD022393
     C                   PARM                    DLDefault3                                 MD022393
     C                   PARM                    DLDefault4                                   CSW214
     C                   PARM                    PayAmount        14                        MD024151
                                                                                            MD022393
     C                   IF        R2RPJ1 = *BLANKS                                         MD022393
     C                   EVAL      R2RPJ1 = D_R2RPJ1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPA1 = *BLANKS                                         MD022393
     C                   EVAL      R2RPA1 = D_R2RPA1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   EXSR      SRDftRp1Flds                                             MD022393
     C                   IF        R2RPP1 = *BLANKS                                         MD022393
     C                             AND R2RPN1 = *BLANKS                                     MD024166
     C                             AND R2TRC1 = *BLANKS                                     MD024166
     C                             AND R2RPS1 = *BLANKS                                     MD024166
     C                             AND R2RPL1 = *BLANKS                                     MD024166
     C                   EVAL      R2RPP1 = D_R2RPP1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPP1 <> *BLANKS                                        MD022393
     C                             AND WR2DFT1 = 'N'                                        MD022393
     C                   EVAL      WR2DFTR1 = 'N'                                           MD022393
     C                   MOVE      R2RPP1        FValid                                     MD022393
     C                   MOVE      'R2RPP1'      FValFld                                    MD022393
     C                   EXSR      VRppt                                                    MD022393
     C                   MOVE      FValidOK      R2RPP1OK                                   MD022393
     C                   MOVE      BBCUST        R2CUS1                                     MD022393
     C                   IF        R2RPP1OK = *BLANKS                                       MD022393
     C                   IF        R2RPN1 = *BLANKS AND                                     MD022393
     C                             R2TRC1 = *BLANKS AND                                     MD022393
     C                             R2RPS1 = *BLANKS AND                                     MD022393
     C                             R2RPL1 = *BLANKS OR                                      MD022393
     C                             R2RPN1 = BBCRNM AND                                      MD022393
     C                             R2TRC1 = BBCRTN AND                                      MD022393
     C                             R2RPS1 = BBCSID AND                                      MD022393
     C                             R2RPL1 = CSLEIC                                          MD022393
     C                   EVAL      R2RPN1 = BBCRNM                                          MD022393
     C                   EVAL      R2TRC1 = BBCRTN                                          MD022393
     C                   EVAL      R2RPS1 = BBCSID                                          MD022393
     C                   EVAL      R2RPL1 = CSLEIC                                          MD022393
     C                   EVAL      WR2DFTR1 = 'Y'                                           MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
                                                                                            MD022393
     C                   ENDIF                                                              MD022393
                                                                                            MD022393
      ** Validate Reporting Jurisdiction 1
      *
     C                   IF        R2RPJ1 = *BLANKS
 
     C                   IF        R2RPP1 <> *BLANKS OR
     C                             R2RPN1 <> *BLANKS OR
     C                             R2TRC1 <> *BLANKS OR
     C                             R2RPS1 <> *BLANKS OR
     C                             R2RPL1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ1'
     C                   EVAL      MsgIDXAr  = '5046058'
     C                   EVAL      R2RPJ1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     R2RPJ1        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ1'
     C                   EVAL      MsgIDXAr  = '5046059'
     C                   EVAL      R2RPJ1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Reporting Party 1
      *
      ** Default other Reporting fields first before validation
      *
     C                   EXSR      SRDftRp1Flds
      *
     C                   EVAL      WR2DFTR1 = 'N'                                           MD022359
     C                   IF        R2RPP1 <> *BLANKS
     C                             AND WR2DFT1 = 'N'
      *
     C                   IF        R2RPJ1 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPP1'
     C                   EVAL      MsgIDXAr  = '5046060'
     C                   EVAL      R2RPP1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   EVAL      WR2DFTR1 = 'N'                                           MD022120
                                                                                            MD022120
     C                   EVAL      FValid  = R2RPP1
     C                   EVAL      FValFld = 'R2RPP1'
     C                   EXSR      VRppt
     C                   EVAL      R2RPP1OK = FValidOK
     C                   MOVE      BBCUST        R2CUS1
     C                   IF        R2RPP1OK = *BLANKS                                       MD022120
     C                   IF        R2RPN1 = *BLANKS AND                                     MD022120
     C                             R2TRC1 = *BLANKS AND                                     MD022120
     C                             R2RPS1 = *BLANKS AND                                     MD022120
     C                             R2RPL1 = *BLANKS OR                                      MD022120
     C                             R2RPN1 = BBCRNM AND                                      MD022120
     C                             R2TRC1 = BBCRTN AND                                      MD022120
     C                             R2RPS1 = BBCSID AND                                      MD022120
     C                             R2RPL1 = CSLEIC                                          MD022120
     C                   EVAL      R2RPN1 = BBCRNM                                          MD022120
     C                   EVAL      R2TRC1 = BBCRTN                                          MD022120
     C                   EVAL      R2RPS1 = BBCSID                                          MD022120
     C                   EVAL      R2RPL1 = CSLEIC                                          MD022120
     C                   EVAL      WR2DFTR1 = 'Y'                                           MD022120
     C                   ENDIF                                                              MD022120
     C                   ENDIF                                                              MD022120
      *
     C                   ENDIF
                                                                                            MD022633
     C                   IF        WCUSNO1 <> R2RPP1                                        MD022633
     C                   EXSR      SRTransType                                              MD022633
     C                   ENDIF                                                              MD022633
      *
      ** Validate Reporting Party Name 1
      *
     C                   IF        R2RPN1 <> *BLANKS
     C                             AND WR2DFT1 = 'N'
     C                             AND WR2DFTR1 = 'N'                                       MD022120
      *
     C                   IF        R2RPP1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPN1'
     C                   EVAL      MsgIDXAr  = '5046062'
     C                   EVAL      R2RPN1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   MOVEL     R2RPN1        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPN1'
     C                   EVAL      MsgIDXAr  = '5046063'
     C                   EVAL      R2RPN1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     MD022251
      ** Default Transaction Id type first before validating                                MD022251
      ** UTI Namespace and Transaction Id                                                   MD022251
      *                                                                                     MD022251
     C                   IF        R2TTY1 = *BLANKS AND                                     MD022251
     C                              R2TRI1 <> *BLANKS AND                                   MD022251
     C**********                    R2UTI2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT4 = *BLANKS                               MD022251 MD022633
     C                              *IN12 = *OFF AND                                        MD022633
     C                              *IN13 = *OFF AND                                        MD022633
     C                              *IN14 = *OFF                                            MD022633
     C                   EVAL      R2TTY1 = '0'                                             MD022251
     C                   ENDIF                                                              MD022251
      *
      ** Validate Namespace 1
      *
     C                   IF        R2UTI1 = *BLANKS
      *
     C                   IF        R2TRI1 <> *BLANKS OR
     C                             R2TTY1 <> *BLANKS OR
     C                             R2EVT1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI1'
     C                   EVAL      MsgIDXAr  = '5046064'
     C                   EVAL      R2UTI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        R2TRI1 = *BLANKS OR
     C                             R2TTY1 = *BLANKS OR
     C                             R2EVT1 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI1'
     C                   EVAL      MsgIDXAr  = '5046087'
     C                   EVAL      R2UTI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   IF        R2RPJ1 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI1'
     C                   EVAL      MsgIDXAr  = '5046065'
     C                   EVAL      R2UTI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   MOVEL     R2UTI1        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI1'
     C                   EVAL      MsgIDXAr  = '5046066'
     C                   EVAL      R2UTI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                              CSW216
     C                   IF        CSW216 <> 'Y'                                              CSW216
     C                   IF        %SUBST(R2UTI1:21:10) <> *BLANKS                            CSW216
     C                   EXSR      ResetErrs                                                  CSW216
     C                   EVAL      FldNamXAr = 'R2UTI1'                                       CSW216
     C                   EVAL      MsgIDXAr  = '5048669'                                      CSW216
     C                   EVAL      R2UTI1OK  = 'N'                                            CSW216
     C                   EXSR      UpdatErrs                                                  CSW216
     C                   ENDIF                                                                CSW216
                                                                                              CSW216
     C                   ELSE                                                                 CSW216
                                                                                              CSW214
     C                   IF        CSW214 <> 'Y'                                              CSW214
     C                   IF        %SUBST(R2UTI1:11:10) <> *BLANKS                            CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R2UTI1'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047319'                                      CSW214
     C                   EVAL      R2UTI1OK  = 'N'                                            CSW214
     C                   EXSR      UpdatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
      *
     C                   ENDIF                                                                CSW216
                                                                                              CSW216
     C                   ENDIF
      *
      ** Validate Transaction Identifier 1
      *
     C                   IF        R2TRI1 = *BLANKS
      *
     C                   IF        R2UTI1 <> *BLANKS OR
     C                             R2TTY1 <> *BLANKS OR
     C                             R2EVT1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI1'
     C                   EVAL      MsgIDXAr  = '5046067'
     C                   EVAL      R2TRI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        R2UTI1 = *BLANKS OR
     C                             R2TTY1 = *BLANKS OR
     C                             R2EVT1 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI1'
     C                   EVAL      MsgIDXAr  = '5046088'
     C                   EVAL      R2TRI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   MOVEL     R2TRI1        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI1'
     C                   EVAL      MsgIDXAr  = '5046068'
     C                   EVAL      R2TRI1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Reporting Party City 1
      *
     C                   IF        R2TRC1 <> *BLANKS
     C                             AND WR2DFT1 = 'N'
     C                             AND WR2DFTR1 = 'N'                                       MD022120
      *
     C                   IF        R2RPN1 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC1'
     C                   EVAL      MsgIDXAr  = '5046069'
     C                   EVAL      R2TRC1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   IF        R2RPP1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC1'
     C                   EVAL      MsgIDXAr  = '5046070'
     C                   EVAL      R2TRC1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   MOVEL     R2TRC1        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC1'
     C                   EVAL      MsgIDXAr  = '5046071'
     C                   EVAL      R2TRC1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Transaction Identifier Type 1
      *
     C**********         IF        R2TTY1 = *BLANKS AND                                    MD022251A
     C**********                    R2TRI1 <> *BLANKS AND                                  MD022251A
     C**********                    R2UTI2 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI2 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY2 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT2 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI3 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI3 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY3 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT3 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI4 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI4 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY4 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT4 = *BLANKS                                       MD022251A
     C**********         EVAL      R2TTY1 = '0'                                            MD022251A
     C**********         ENDIF                                                             MD022251A
     C                   IF        R2TTY1 <> *BLANKS AND
     C                             (R2UTI1 = *BLANKS OR
     C                              R2TRI1 = *BLANKS OR
     C                              R2EVT1 = *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY1'
     C                   EVAL      MsgIDXAr  = '5046072'
     C                   EVAL      R2TTY1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF                                                              MD022633
      *
     C**********         ELSE                                                               MD022633
      *
     C                   IF        R2TTY1 = '0'
                                                                                            MD022633
     C**********         IF        R2TTY2 = '0' OR                                          MD022633
     C**********                   R2TTY3 = '0' OR                                          MD022633
     C**********                   R2TTY4 = '0'                                             MD022633
     C                   IF        WR2TTY1 = '0'                                            MD022633
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY1'
     C                   EVAL      MsgIDXAr  = '5046073'
     C                   EVAL      R2TTY1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                            MD022633
     C                   ELSE                                                               MD022633
                                                                                            MD022633
     C                   Z-ADD     1             X                                          MD022633
     C                   MOVEA     *BLANKS       ArrTType                                   MD022633
     C   12              EVAL      ArrTType(X) = R2TTY2                                     MD022633
     C   12              ADD       1             X                                          MD022633
     C   13              EVAL      ArrTType(X) = R2TTY3                                     MD022633
     C   13              ADD       1             X                                          MD022633
     C   14              EVAL      ArrTType(X) = R2TTY4                                     MD022633
     C   14              ADD       1             X                                          MD022633
     C     '0'           LOOKUP    ArrTType                               01                MD022633
     C                   IF        *IN01 = *OFF                                             MD022633
     C                             AND R2TTY1 <> *BLANKS                                    MD022633
     C                   EXSR      ResetErrs                                                MD022633
     C                   EVAL      FldNamXAr = 'R2TTY1'                                     MD022633
     C                   EVAL      MsgIDXAr  = '5046113'                                    MD022633
     C                   EVAL      R2TTY1OK  = 'N'                                          MD022633
     C                   EXSR      UpdatErrs                                                MD022633
     C                   ENDIF                                                              MD022633
                                                                                            MD022633
     C                   ENDIF
 
     C     TrnTyp        CHECK     R2TTY1                                 99
     C                   IF        *IN99 = *ON
     C                             AND R2TTY1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY1'
     C                   EVAL      MsgIDXAr  = '5046074'
     C                   EVAL      R2TTY1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C**********         ENDIF                                                              MD022633
     C                   IF        R2TTY1 = *BLANKS AND
     C                             (R2UTI1 <> *BLANKS OR
     C                              R2TRI1 <> *BLANKS OR
     C                              R2EVT1 <> *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY1'
     C                   EVAL      MsgIDXAr  = '5046089'
     C                   EVAL      R2TTY1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
      ** Validate Event Type 1
      *
     C                   IF        R2EVT1 <> *BLANKS
      *
     C                   IF        R2UTI1 = *BLANKS OR
     C                             R2TRI1 = *BLANKS OR
     C                             R2TTY1 = *BLANKS
      *
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT1'
     C                   EVAL      MsgIDXAr  = '5046075'
     C                   EVAL      R2EVT1OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C     EvnTyp        CHECK     R2EVT1                                 99
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT1'
     C                   EVAL      MsgIDXAr  = '5046076'
     C                   EVAL      R2EVT1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2UTI1 <> *BLANKS OR
     C                             R2TRI1 <> *BLANKS OR
     C                             R2TTY1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT1'
     C                   EVAL      MsgIDXAr  = '5046090'
     C                   EVAL      R2EVT1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party SWIFT Identification 1
      *
     C                   IF        R2RPS1 <> *BLANKS
     C                             AND WR2DFT1 = 'N'
     C                             AND WR2DFTR1 = 'N'                                       MD022120
      *
     C                   EXSR      ResetErrs
      *
     C                   IF        R2RPP1 <> *BLANKS
     C
     C                   EVAL      FldNamXAr = 'R2RPS1'
     C                   EVAL      MsgIDXAr  = '5046090'
     C                   EVAL      R2RPS1OK  = 'N'
     C                   EXSR      UpdatErrs
      *
     C                   ELSE
      *
     C                   EVAL      WRpSwf  = R2RPS1
     C                   EVAL      FValFld = 'R2RPS1'
     C                   EXSR      VRpSwft
     C                   EVAL      R2RPS1OK = R2RPSOK
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Reporting Party LEI 1
      *
     C                   IF        R2RPL1 <> *BLANKS
     C                             AND WR2DFT1 = 'N'
     C                             AND WR2DFTR1 = 'N'                                       MD022120
      *
     C                   IF        R2RPN1 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL1'
     C                   EVAL      MsgIDXAr  = '5046080'
     C                   EVAL      R2RPL1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   IF        R2RPP1 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL1'
     C                   EVAL      MsgIDXAr  = '5046081'
     C                   EVAL      R2RPL1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   MOVEL     R2RPL1        F18Chr
     C     AlphaN        CHECK     F18Chr                                 98
     C     Digits        CHECK     R2RPL1:19                              99
      *
     C                   IF        *IN98 = *ON OR *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL1'
     C                   EVAL      MsgIDXAr  = '5046082'
     C                   EVAL      R2RPL1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party's Party ID 1
      *
     C                   IF        R2RPA1 <> *BLANKS
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP1 = *BLANKS AND
     C                             R2RPN1 = *BLANKS
 
     C                   EVAL      FldNamXAr = 'R2RPA1'
     C                   EVAL      MsgIDXAr  = '5046083'
     C                   EVAL      R2RPA1OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   MOVEL     R2RPA1        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPA1'
     C                   EVAL      MsgIDXAr  = '5046084'
     C                   EVAL      R2RPA1OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                            MD022393
     C                   IF        R2TTY2 = '0'                                             MD022393
     C**********                   AND R2TTY1 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY3 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY4 <> '0'                               MD022393 MD022633
     C                             AND WR2TTY2 <> '0'                                       MD022633
     C                             AND RLACTN = 'A'                                         MD022393
     C                             AND (R2RPJ2 = *BLANKS OR                                 MD022393
     C                                  R2RPP2 = *BLANKS OR                                 MD022393
     C                                  R2RPA2 = *BLANKS)                                   MD022393
     C                             AND WRType2 <> '0'                                       MD024179
                                                                                            MD022393
     C                   EVAL      WRType2 = '0'                                            MD024179
     C                   CALLB     'DLRPIFDFT'                                              MD022393
     C                   PARM      *BLANKS       PRtCd                                      MD022393
     C                   PARM                    DLRILKPDIn                                 MD022393
     C                   PARM                    DLDefault1                                 MD022393
     C                   PARM                    DLDefault2                                 MD022393
     C                   PARM                    DLDefault3                                 MD022393
     C                   PARM                    DLDefault4                                   CSW214
     C                   PARM                    PayAmount                                  MD024151
                                                                                            MD022393
     C                   IF        R2RPJ2 = *BLANKS                                         MD022393
     C                   EVAL      R2RPJ2 = D_R2RPJ1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPA2 = *BLANKS                                         MD022393
     C                   EVAL      R2RPA2 = D_R2RPA1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   EXSR      SRDftRp2Flds                                             MD022393
     C                   IF        R2RPP2 = *BLANKS                                         MD022393
     C                             AND R2RPN2 = *BLANKS                                     MD024166
     C                             AND R2TRC2 = *BLANKS                                     MD024166
     C                             AND R2RPS2 = *BLANKS                                     MD024166
     C                             AND R2RPL2 = *BLANKS                                     MD024166
     C                   EVAL      R2RPP2 = D_R2RPP1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPP2 <> *BLANKS                                        MD022393
     C                             AND WR2DFT2 = 'N'                                        MD022393
     C                   EVAL      WR2DFTR2 = 'N'                                           MD022393
     C                   MOVE      R2RPP2        FValid                                     MD022393
     C                   MOVE      'R2RPP2'      FValFld                                    MD022393
     C                   EXSR      VRppt                                                    MD022393
     C                   MOVE      FValidOK      R2RPP2OK                                   MD022393
     C                   MOVE      BBCUST        R2CUS2                                     MD022393
     C                   IF        R2RPP2OK = *BLANKS                                       MD022393
     C                   IF        R2RPN2 = *BLANKS AND                                     MD022393
     C                             R2TRC2 = *BLANKS AND                                     MD022393
     C                             R2RPS2 = *BLANKS AND                                     MD022393
     C                             R2RPL2 = *BLANKS OR                                      MD022393
     C                             R2RPN2 = BBCRNM AND                                      MD022393
     C                             R2TRC2 = BBCRTN AND                                      MD022393
     C                             R2RPS2 = BBCSID AND                                      MD022393
     C                             R2RPL2 = CSLEIC                                          MD022393
     C                   EVAL      R2RPN2 = BBCRNM                                          MD022393
     C                   EVAL      R2TRC2 = BBCRTN                                          MD022393
     C                   EVAL      R2RPS2 = BBCSID                                          MD022393
     C                   EVAL      R2RPL2 = CSLEIC                                          MD022393
     C                   EVAL      WR2DFTR2 = 'Y'                                           MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
                                                                                            MD022393
     C                   ENDIF                                                              MD022393
      *
      ** Validate Reporting Jurisdiction 2
      *
     C                   IF        R2RPJ2 = *BLANKS
 
     C                   IF        R2RPP2 <> *BLANKS OR
     C                             R2RPN2 <> *BLANKS OR
     C                             R2TRC2 <> *BLANKS OR
     C                             R2RPS2 <> *BLANKS OR
     C                             R2RPL2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ2'
     C                   EVAL      MsgIDXAr  = '5046058'
     C                   EVAL      R2RPJ2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVEL     R2RPJ2        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ2'
     C                   EVAL      MsgIDXAr  = '5046059'
     C                   EVAL      R2RPJ2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party 2
      *
      ** Default other Reporting fields first before validation
      *
     C                   EXSR      SRDftRp2Flds
 
     C                   EVAL      WR2DFTR2 = 'N'                                           MD022359
     C                   IF        R2RPP2 <> *BLANKS
     C                             AND WR2DFT2 = 'N'
 
     C                   IF        R2RPJ2 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPP2'
     C                   EVAL      MsgIDXAr  = '5046060'
     C                   EVAL      R2RPP2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   EVAL      WR2DFTR2 = 'N'                                           MD022120
                                                                                            MD022120
     C                   MOVE      R2RPP2        FValid
     C                   MOVE      'R2RPP2'      FValFld
     C                   EXSR      VRppt
     C                   MOVE      FValidOK      R2RPP2OK
     C                   MOVE      BBCUST        R2CUS2
     C                   IF        R2RPP2OK = *BLANKS                                       MD022120
     C                   IF        R2RPN2 = *BLANKS AND                                     MD022120
     C                             R2TRC2 = *BLANKS AND                                     MD022120
     C                             R2RPS2 = *BLANKS AND                                     MD022120
     C                             R2RPL2 = *BLANKS OR                                      MD022120
     C                             R2RPN2 = BBCRNM AND                                      MD022120
     C                             R2TRC2 = BBCRTN AND                                      MD022120
     C                             R2RPS2 = BBCSID AND                                      MD022120
     C                             R2RPL2 = CSLEIC                                          MD022120
     C                   EVAL      R2RPN2 = BBCRNM                                          MD022120
     C                   EVAL      R2TRC2 = BBCRTN                                          MD022120
     C                   EVAL      R2RPS2 = BBCSID                                          MD022120
     C                   EVAL      R2RPL2 = CSLEIC                                          MD022120
     C                   EVAL      WR2DFTR2 = 'Y'                                           MD022120
     C                   ENDIF                                                              MD022120
     C                   ENDIF                                                              MD022120
 
     C                   ENDIF
                                                                                            MD022633
     C                   IF        WCUSNO2 <> R2RPP2                                        MD022633
     C                   EXSR      SRTransType                                              MD022633
     C                   ENDIF                                                              MD022633
      *
      ** Validate Reporting Party Name 2
      *
     C                   IF        R2RPN2 <> *BLANKS
     C                             AND WR2DFT2 = 'N'
     C                             AND WR2DFTR2 = 'N'                                       MD022120
 
     C                   IF        R2RPP2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPN2'
     C                   EVAL      MsgIDXAr  = '5046062'
     C                   EVAL      R2RPN2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2RPN2        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPN2'
     C                   EVAL      MsgIDXAr  = '5046063'
     C                   EVAL      R2RPN2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                     MD022251
      ** Default Transaction Id type first before validating                                MD022251
      ** UTI Namespace and Transaction Id                                                   MD022251
      *                                                                                     MD022251
     C                   IF        R2TTY2 = *BLANKS AND                                     MD022251
     C                              R2TRI2 <> *BLANKS AND                                   MD022251
     C**********                    R2UTI1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT4 = *BLANKS                               MD022251 MD022633
     C                              *IN12 = *OFF AND                                        MD022633
     C                              *IN23 = *OFF AND                                        MD022633
     C                              *IN24 = *OFF                                            MD022633
     C                   EVAL      R2TTY2 = '0'                                             MD022251
     C                   ENDIF                                                              MD022251
      *
      ** Validate Namespace 2
      *
     C                   IF        R2UTI2 = *BLANKS
 
     C                   IF        R2TRI2 <> *BLANKS OR
     C                             R2TTY2 <> *BLANKS OR
     C                             R2EVT2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI2'
     C                   EVAL      MsgIDXAr  = '5046064'
     C                   EVAL      R2UTI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2TRI2 = *BLANKS OR
     C                             R2TTY2 = *BLANKS OR
     C                             R2EVT2 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI2'
     C                   EVAL      MsgIDXAr  = '5046087'
     C                   EVAL      R2UTI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   IF        R2RPJ2 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI2'
     C                   EVAL      MsgIDXAr  = '5046065'
     C                   EVAL      R2UTI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2UTI2        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI2'
     C                   EVAL      MsgIDXAr  = '5046066'
     C                   EVAL      R2UTI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                              CSW216
     C                   IF        CSW216 <> 'Y'                                              CSW216
     C                   IF        %SUBST(R2UTI2:21:10) <> *BLANKS                            CSW216
     C                   EXSR      ResetErrs                                                  CSW216
     C                   EVAL      FldNamXAr = 'R2UTI2'                                       CSW216
     C                   EVAL      MsgIDXAr  = '5048669'                                      CSW216
     C                   EVAL      R2UTI2OK  = 'N'                                            CSW216
     C                   EXSR      UpdatErrs                                                  CSW216
     C                   ENDIF                                                                CSW216
                                                                                              CSW216
     C                   ELSE                                                                 CSW216
                                                                                              CSW214
     C                   IF        CSW214 <> 'Y'                                              CSW214
     C                   IF        %SUBST(R2UTI2:11:10) <> *BLANKS                            CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R2UTI2'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047319'                                      CSW214
     C                   EVAL      R2UTI2OK  = 'N'                                            CSW214
     C                   EXSR      UpdatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW216
     C                   ENDIF                                                                CSW216
 
     C                   ENDIF
      *
      ** Validate Transaction Identifier 2
      *
     C                   IF        R2TRI2 = *BLANKS
 
     C                   IF        R2UTI2 <> *BLANKS OR
     C                             R2TTY2 <> *BLANKS OR
     C                             R2EVT2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI2'
     C                   EVAL      MsgIDXAr  = '5046067'
     C                   EVAL      R2TRI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
      *
     C                   IF        R2UTI2 = *BLANKS OR
     C                             R2TTY2 = *BLANKS OR
     C                             R2EVT2 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI2'
     C                   EVAL      MsgIDXAr  = '5046088'
     C                   EVAL      R2TRI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2TRI2        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI2'
     C                   EVAL      MsgIDXAr  = '5046068'
     C                   EVAL      R2TRI2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party City 2
      *
     C                   IF        R2TRC2 <> *BLANKS
     C                             AND WR2DFT2 = 'N'
     C                             AND WR2DFTR2 = 'N'                                       MD022120
 
     C                   IF        R2RPN2 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC2'
     C                   EVAL      MsgIDXAr  = '5046069'
     C                   EVAL      R2TRC2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   IF        R2RPP2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC2'
     C                   EVAL      MsgIDXAr  = '5046070'
     C                   EVAL      R2TRC2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2TRC2        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = '1'
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC2'
     C                   EVAL      MsgIDXAr  = '5046071'
     C                   EVAL      R2TRC2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Transaction Identifier Type 2
      *
     C**********         IF        R2TTY2 = *BLANKS AND                                    MD022251A
     C**********                    R2TRI2 <> *BLANKS AND                                  MD022251A
     C**********                    R2UTI1 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI1 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY1 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT1 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI3 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI3 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY3 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT3 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI4 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI4 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY4 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT4 = *BLANKS                                       MD022251A
     C**********         EVAL      R2TTY2 = '0'                                            MD022251A
     C**********         ENDIF                                                             MD022251A
     C                   IF        R2TTY2 <> *BLANKS AND
     C                             (R2UTI2 = *BLANKS OR
     C                              R2TRI2 = *BLANKS OR
     C                              R2EVT2 = *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY2'
     C                   EVAL      MsgIDXAr  = '5046072'
     C                   EVAL      R2TTY2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF                                                              MD022633
 
     C**********         ELSE                                                               MD022633
 
     C                   IF        R2TTY2 = '0'
                                                                                            MD022633
     C**********         IF        R2TTY1 = '0' OR                                          MD022633
     C**********                   R2TTY3 = '0' OR                                          MD022633
     C**********                   R2TTY4 = '0'                                             MD022633
     C                   IF        WR2TTY2 = '0'                                            MD022633
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY2'
     C                   EVAL      MsgIDXAr  = '5046073'
     C                   EVAL      R2TTY2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                            MD022633
     C                   ELSE                                                               MD022633
                                                                                            MD022633
     C                   Z-ADD     1             X                                          MD022633
     C                   MOVEA     *BLANKS       ArrTType                                   MD022633
     C   12              EVAL      ArrTType(X) = R2TTY1                                     MD022633
     C   12              ADD       1             X                                          MD022633
     C   23              EVAL      ArrTType(X) = R2TTY3                                     MD022633
     C   23              ADD       1             X                                          MD022633
     C   24              EVAL      ArrTType(X) = R2TTY4                                     MD022633
     C   24              ADD       1             X                                          MD022633
     C     '0'           LOOKUP    ArrTType                               01                MD022633
     C                   IF        *IN01 = *OFF                                             MD022633
     C                             AND R2TTY2 <> *BLANKS                                    MD022633
     C                   EXSR      ResetErrs                                                MD022633
     C                   EVAL      FldNamXAr = 'R2TTY2'                                     MD022633
     C                   EVAL      MsgIDXAr  = '5046113'                                    MD022633
     C                   EVAL      R2TTY1OK  = 'N'                                          MD022633
     C                   EXSR      UpdatErrs                                                MD022633
     C                   ENDIF                                                              MD022633
                                                                                            MD022633
     C                   ENDIF
 
     C     TrnTyp        CHECK     R2TTY2                                 99
     C                   IF        *IN99 = *ON
     C                             AND R2TTY2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY2'
     C                   EVAL      MsgIDXAr  = '5046074'
     C                   EVAL      R2TTY2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C**********         ENDIF                                                              MD022633
     C                   IF        R2TTY2 = *BLANKS AND
     C                             (R2UTI2 <> *BLANKS OR
     C                              R2TRI2 <> *BLANKS OR
     C                              R2EVT2 <> *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY2'
     C                   EVAL      MsgIDXAr  = '5046089'
     C                   EVAL      R2TTY2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
      ** Validate Event Type 2
      *
     C                   IF        R2EVT2 <> *BLANKS
 
     C                   IF        R2UTI2 =  *BLANKS OR
     C                             R2TRI2 =  *BLANKS OR
     C                             R2TTY2 =  *BLANKS
     C
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT2'
     C                   EVAL      MsgIDXAr  = '5046075'
     C                   EVAL      R2EVT2OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C     EvnTyp        CHECK     R2EVT2                                 99
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT2'
     C                   EVAL      MsgIDXAr  = '5046076'
     C                   EVAL      R2EVT2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2UTI2 <> *BLANKS OR
     C                             R2TRI2 <> *BLANKS OR
     C                             R2TTY2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT2'
     C                   EVAL      MsgIDXAr  = '5046090'
     C                   EVAL      R2EVT2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party SWIFT Identification 2
      *
     C                   IF        R2RPS2 <> *BLANKS
     C                             AND WR2DFT2 = 'N'
     C                             AND WR2DFTR2 = 'N'                                       MD022120
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP2 <> *BLANKS
     C
     C                   EVAL      FldNamXAr = 'R2RPS2'
     C                   EVAL      MsgIDXAr  = '5046077'
     C                   EVAL      R2RPS2OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   EVAL      WRpSwf  = R2RPS2
     C                   EVAL      FValFld = 'R2RPS2'
     C                   EXSR      VRpSwft
     C                   EVAL      R2RPS2OK = R2RPSOK
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party LEI 2
      *
     C                   IF        R2RPL2 <> *BLANKS
     C                             AND WR2DFT2 = 'N'
     C                             AND WR2DFTR2 = 'N'                                       MD022120
 
     C                   IF        R2RPN2 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL2'
     C                   EVAL      MsgIDXAr  = '5046080'
     C                   EVAL      R2RPL2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   IF        R2RPP2 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL2'
     C                   EVAL      MsgIDXAr  = '5046081'
     C                   EVAL      R2RPL2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2RPL2        F18Chr
     C     AlphaN        CHECK     F18Chr                                 98
     C     Digits        CHECK     R2RPL2:19                              99
     C
     C                   IF        *IN98 = *ON OR *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL2'
     C                   EVAL      MsgIDXAr  = '5046082'
     C                   EVAL      R2RPL2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party's Party ID 2
      *
     C                   IF        R2RPA2 <> *BLANKS
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP2 = *BLANKS AND
     C                             R2RPN2 = *BLANKS
 
     C                   EVAL      FldNamXAr = 'R2RPA2'
     C                   EVAL      MsgIDXAr  = '5046083'
     C                   EVAL      R2RPA2OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   MOVEL     R2RPA2        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPA2'
     C                   EVAL      MsgIDXAr  = '5046084'
     C                   EVAL      R2RPA2OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                            MD022393
     C                   IF        R2TTY3 = '0'                                             MD022393
     C**********                   AND R2TTY1 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY2 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY4 <> '0'                               MD022393 MD022633
     C                             AND WR2TTY3 <> '0'                                       MD022633
     C                             AND RLACTN = 'A'                                         MD022393
     C                             AND (R2RPJ3 = *BLANKS OR                                 MD022393
     C                                  R2RPP3 = *BLANKS OR                                 MD022393
     C                                  R2RPA3 = *BLANKS)                                   MD022393
     C                             AND WRType3 <> '0'                                       MD024179
                                                                                            MD022393
     C                   EVAL      WRType3 = '0'                                            MD024179
     C                   CALLB     'DLRPIFDFT'                                              MD022393
     C                   PARM      *BLANKS       PRtCd                                      MD022393
     C                   PARM                    DLRILKPDIn                                 MD022393
     C                   PARM                    DLDefault1                                 MD022393
     C                   PARM                    DLDefault2                                 MD022393
     C                   PARM                    DLDefault3                                 MD022393
     C                   PARM                    DLDefault4                                   CSW214
     C                   PARM                    PayAmount                                  MD024151
                                                                                            MD022393
     C                   IF        R2RPJ3 = *BLANKS                                         MD022393
     C                   EVAL      R2RPJ3 = D_R2RPJ1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPA3 = *BLANKS                                         MD022393
     C                   EVAL      R2RPA3 = D_R2RPA1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   EXSR      SRDftRp3Flds                                             MD022393
     C                   IF        R2RPP3 = *BLANKS                                         MD022393
     C                             AND R2RPN3 = *BLANKS                                     MD024166
     C                             AND R2TRC3 = *BLANKS                                     MD024166
     C                             AND R2RPS3 = *BLANKS                                     MD024166
     C                             AND R2RPL3 = *BLANKS                                     MD024166
     C                   EVAL      R2RPP3 = D_R2RPP1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPP3 <> *BLANKS                                        MD022393
     C                             AND WR2DFT3 = 'N'                                        MD022393
     C                   EVAL      WR2DFTR3 = 'N'                                           MD022393
     C                   MOVE      R2RPP3        FValid                                     MD022393
     C                   MOVE      'R2RPP3'      FValFld                                    MD022393
     C                   EXSR      VRppt                                                    MD022393
     C                   MOVE      FValidOK      R2RPP3OK                                   MD022393
     C                   MOVE      BBCUST        R2CUS3                                     MD022393
     C                   IF        R2RPP3OK = *BLANKS                                       MD022393
     C                   IF        R2RPN3 = *BLANKS AND                                     MD022393
     C                             R2TRC3 = *BLANKS AND                                     MD022393
     C                             R2RPS3 = *BLANKS AND                                     MD022393
     C                             R2RPL3 = *BLANKS OR                                      MD022393
     C                             R2RPN3 = BBCRNM AND                                      MD022393
     C                             R2TRC3 = BBCRTN AND                                      MD022393
     C                             R2RPS3 = BBCSID AND                                      MD022393
     C                             R2RPL3 = CSLEIC                                          MD022393
     C                   EVAL      R2RPN3 = BBCRNM                                          MD022393
     C                   EVAL      R2TRC3 = BBCRTN                                          MD022393
     C                   EVAL      R2RPS3 = BBCSID                                          MD022393
     C                   EVAL      R2RPL3 = CSLEIC                                          MD022393
     C                   EVAL      WR2DFTR3 = 'Y'                                           MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
                                                                                            MD022393
     C                   ENDIF                                                              MD022393
      *
      ** Validate Reporting Jurisdiction 3
      *
     C                   IF        R2RPJ3 =  *BLANKS
 
     C                   IF        R2RPP3 <> *BLANKS OR
     C                             R2RPN3 <> *BLANKS OR
     C                             R2TRC3 <> *BLANKS OR
     C                             R2RPS3 <> *BLANKS OR
     C                             R2RPL3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ3'
     C                   EVAL      MsgIDXAr  = '5046058'
     C                   EVAL      R2RPJ3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVEL     R2RPJ3        FldChk
     C                   EXSR      SWSet
     C     *IN99         IFEQ      '1'
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ3'
     C                   EVAL      MsgIDXAr  = '5046059'
     C                   EVAL      R2RPJ3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party 3
      *
      ** Default other Reporting fields first before validation
      *
     C                   EXSR      SRDftRp3Flds
      *
     C                   EVAL      WR2DFTR3 = 'N'                                           MD022359
     C                   IF        R2RPP3 <> *BLANKS
     C                             AND WR2DFT3 = 'N'
 
     C                   IF        R2RPJ3 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPP3'
     C                   EVAL      MsgIDXAr  = '5046060'
     C                   EVAL      R2RPP3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   EVAL      WR2DFTR3 = 'N'                                           MD022120
                                                                                            MD022120
     C                   EVAL      FValid  = R2RPP3
     C                   EVAL      FValFld = 'R2RPP3'
     C                   EXSR      VRppt
     C**********         EVAL      R2RPP2OK = FValidOK                                      MD024146
     C                   EVAL      R2RPP3OK = FValidOK                                      MD024146
     C                   MOVE      BBCUST        R2CUS3
     C                   IF        R2RPP3OK = *BLANKS                                       MD022120
     C                   IF        R2RPN3 = *BLANKS AND                                     MD022120
     C                             R2TRC3 = *BLANKS AND                                     MD022120
     C                             R2RPS3 = *BLANKS AND                                     MD022120
     C                             R2RPL3 = *BLANKS OR                                      MD022120
     C                             R2RPN3 = BBCRNM AND                                      MD022120
     C                             R2TRC3 = BBCRTN AND                                      MD022120
     C                             R2RPS3 = BBCSID AND                                      MD022120
     C                             R2RPL3 = CSLEIC                                          MD022120
     C                   EVAL      R2RPN3 = BBCRNM                                          MD022120
     C                   EVAL      R2TRC3 = BBCRTN                                          MD022120
     C                   EVAL      R2RPS3 = BBCSID                                          MD022120
     C                   EVAL      R2RPL3 = CSLEIC                                          MD022120
     C                   EVAL      WR2DFTR3 = 'Y'                                           MD022120
     C                   ENDIF                                                              MD022120
                                                                                            MD022120
     C                   ENDIF                                                              MD022120
 
     C                   ENDIF
                                                                                            MD022633
     C                   IF        WCUSNO3 <> R2RPP3                                        MD022633
     C                   EXSR      SRTransType                                              MD022633
     C                   ENDIF                                                              MD022633
      *
      ** Validate Reporting Party Name 3
      *
     C                   IF        R2RPN3 <> *BLANKS
     C                             AND WR2DFT3 = 'N'
     C                             AND WR2DFTR3 = 'N'                                       MD022120
 
     C                   IF        R2RPP3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPN3'
     C                   EVAL      MsgIDXAr  = '5046062'
     C                   EVAL      R2RPN3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2RPN3        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPN3'
     C                   EVAL      MsgIDXAr  = '5046063'
     C                   EVAL      R2RPN3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                     MD022251
      ** Default Transaction Id type first before validating                                MD022251
      ** UTI Namespace and Transaction Id                                                   MD022251
      *                                                                                     MD022251
     C                   IF        R2TTY3 = *BLANKS AND                                     MD022251
     C                              R2TRI3 <> *BLANKS AND                                   MD022251
     C**********                    R2UTI1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY4 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT4 = *BLANKS                               MD022251 MD022633
     C                              *IN13 = *OFF AND                                        MD022633
     C                              *IN23 = *OFF AND                                        MD022633
     C                              *IN34 = *OFF                                            MD022633
     C                   EVAL      R2TTY3 = '0'                                             MD022251
     C                   ENDIF                                                              MD022251
      *
      ** Validate Namespace 3
      *
     C                   IF        R2UTI3 = *BLANKS
 
     C                   IF        R2TRI3 <> *BLANKS OR
     C                             R2TTY3 <> *BLANKS OR
     C                             R2EVT3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI3'
     C                   EVAL      MsgIDXAr  = '5046064'
     C                   EVAL      R2UTI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2TRI3 = *BLANKS OR
     C                             R2TTY3 = *BLANKS OR
     C                             R2EVT3 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI3'
     C                   EVAL      MsgIDXAr  = '5046087'
     C                   EVAL      R2UTI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   IF        R2RPJ3 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI3'
     C                   EVAL      MsgIDXAr  = '5046065'
     C                   EVAL      R2UTI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2UTI3        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI3'
     C                   EVAL      MsgIDXAr  = '5046066'
     C                   EVAL      R2UTI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                              CSW216
     C                   IF        CSW216 <> 'Y'                                              CSW216
     C                   IF        %SUBST(R2UTI3:21:10) <> *BLANKS                            CSW216
     C                   EXSR      ResetErrs                                                  CSW216
     C                   EVAL      FldNamXAr = 'R2UTI3'                                       CSW216
     C                   EVAL      MsgIDXAr  = '5048669'                                      CSW216
     C                   EVAL      R2UTI3OK  = 'N'                                            CSW216
     C                   EXSR      UpdatErrs                                                  CSW216
     C                   ENDIF                                                                CSW216
                                                                                              CSW216
     C                   ELSE                                                                 CSW216
                                                                                              CSW214
     C                   IF        CSW214 <> 'Y'                                              CSW214
     C                   IF        %SUBST(R2UTI3:11:10) <> *BLANKS                            CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R2UTI3'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047319'                                      CSW214
     C                   EVAL      R2UTI3OK  = 'N'                                            CSW214
     C                   EXSR      UpdatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW216
     C                   ENDIF                                                                CSW216
 
     C                   ENDIF
      *
      ** Validate Transaction Identifier 3
      *
     C                   IF        R2TRI3 = *BLANKS
 
     C                   IF        R2UTI3 <> *BLANKS OR
     C                             R2TTY3 <> *BLANKS OR
     C                             R2EVT3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI3'
     C                   EVAL      MsgIDXAr  = '5046067'
     C                   EVAL      R2TRI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
      *
     C                   IF        R2UTI3 = *BLANKS OR
     C                             R2TTY3 = *BLANKS OR
     C                             R2EVT3 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI3'
     C                   EVAL      MsgIDXAr  = '5046088'
     C                   EVAL      R2TRI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2TRI3        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI3'
     C                   EVAL      MsgIDXAr  = '5046068'
     C                   EVAL      R2TRI3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party City 3
      *
     C                   IF        R2TRC3 <> *BLANKS
     C                             AND WR2DFT3 = 'N'
     C                             AND WR2DFTR3 = 'N'                                       MD022120
 
     C                   IF        R2RPN3 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC3'
     C                   EVAL      MsgIDXAr  = '5046069'
     C                   EVAL      R2TRC3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   IF        R2RPP3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC3'
     C                   EVAL      MsgIDXAr  = '5046070'
     C                   EVAL      R2TRC3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2TRC3        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC3'
     C                   EVAL      MsgIDXAr  = '5046071'
     C                   EVAL      R2TRC3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Transaction Identifier Type 3
      *
     C**********         IF        R2TTY3 = *BLANKS AND                                    MD022251A
     C**********                    R2TRI3 <> *BLANKS AND                                  MD022251A
     C**********                    R2UTI1 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI1 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY1 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT1 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI2 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI2 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY2 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT2 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI4 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI4 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY4 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT4 = *BLANKS                                       MD022251A
     C**********         EVAL      R2TTY3 = '0'                                            MD022251A
     C**********         ENDIF                                                             MD022251A
     C                   IF        R2TTY3 <> *BLANKS AND
     C                             (R2UTI3 = *BLANKS OR
     C                              R2TRI3 = *BLANKS OR
     C                              R2EVT3 = *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY3'
     C                   EVAL      MsgIDXAr  = '5046072'
     C                   EVAL      R2TTY3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF                                                              MD022633
 
     C**********         ELSE                                                               MD022633
 
     C                   IF        R2TTY3 = '0'
                                                                                            MD022633
     C**********         IF        R2TTY1 = '0' OR                                          MD022633
     C**********                   R2TTY2 = '0' OR                                          MD022633
     C**********                   R2TTY4 = '0'                                             MD022633
     C                   IF        WR2TTY3 = '0'                                            MD022633
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY3'
     C                   EVAL      MsgIDXAr  = '5046073'
     C                   EVAL      R2TTY3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                            MD022633
     C                   ELSE                                                               MD022633
                                                                                            MD022633
     C                   Z-ADD     1             X                                          MD022633
     C                   MOVEA     *BLANKS       ArrTType                                   MD022633
     C   13              EVAL      ArrTType(X) = R2TTY1                                     MD022633
     C   13              ADD       1             X                                          MD022633
     C   23              EVAL      ArrTType(X) = R2TTY2                                     MD022633
     C   23              ADD       1             X                                          MD022633
     C   34              EVAL      ArrTType(X) = R2TTY4                                     MD022633
     C   34              ADD       1             X                                          MD022633
     C     '0'           LOOKUP    ArrTType                               01                MD022633
     C                   IF        *IN01 = *OFF                                             MD022633
     C                             AND R2TTY3 <> *BLANKS                                    MD022633
     C                   EXSR      ResetErrs                                                MD022633
     C                   EVAL      FldNamXAr = 'R2TTY3'                                     MD022633
     C                   EVAL      MsgIDXAr  = '5046113'                                    MD022633
     C                   EVAL      R2TTY1OK  = 'N'                                          MD022633
     C                   EXSR      UpdatErrs                                                MD022633
     C                   ENDIF                                                              MD022633
                                                                                            MD022633
     C                   ENDIF
 
     C     TrnTyp        CHECK     R2TTY3                                 99
     C                   IF        *IN99 = *ON
     C                             AND R2TTY3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY3'
     C                   EVAL      MsgIDXAr  = '5046074'
     C                   EVAL      R2TTY3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C**********         ENDIF                                                              MD022633
     C                   IF        R2TTY3 = *BLANKS AND
     C                             (R2UTI3 <> *BLANKS OR
     C                              R2TRI3 <> *BLANKS OR
     C                              R2EVT3 <> *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY3'
     C                   EVAL      MsgIDXAr  = '5046089'
     C                   EVAL      R2TTY3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
      ** Validate Event Type 3
      *
     C                   IF        R2EVT3 <> *BLANKS
 
     C                   IF        R2UTI3 =  *BLANKS OR
     C                             R2TRI3 =  *BLANKS OR
     C                             R2TTY3 =  *BLANKS
     C
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT3'
     C                   EVAL      MsgIDXAr  = '5046075'
     C                   EVAL      R2EVT3OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C     EvnTyp        CHECK     R2EVT3                                 99
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT3'
     C                   EVAL      MsgIDXAr  = '5046076'
     C                   EVAL      R2EVT3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2UTI3 <> *BLANKS OR
     C                             R2TRI3 <> *BLANKS OR
     C                             R2TTY3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT3'
     C                   EVAL      MsgIDXAr  = '5046090'
     C                   EVAL      R2EVT3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party SWIFT Identification 3
      *
     C                   IF        R2RPS3 <> *BLANKS
     C                             AND WR2DFT3 = 'N'
     C                             AND WR2DFTR3 = 'N'                                       MD022120
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP3 <> *BLANKS
     C
     C                   EVAL      FldNamXAr = 'R2RPS3'
     C                   EVAL      MsgIDXAr  = '5046077'
     C                   EVAL      R2RPS3OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   EVAL      WRpSwf  = R2RPS3
     C                   EVAL      FValFld = 'R2RPS3'
     C                   EXSR      VRpSwft
     C                   EVAL      R2RPS3OK = R2RPSOK
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party LEI 3
      *
     C                   IF        R2RPL3 <> *BLANKS
     C                             AND WR2DFT3 = 'N'
     C                             AND WR2DFTR3 = 'N'                                       MD022120
 
     C                   IF        R2RPN3 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL3'
     C                   EVAL      MsgIDXAr  = '5046080'
     C                   EVAL      R2RPL3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   IF        R2RPP3 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL3'
     C                   EVAL      MsgIDXAr  = '5046081'
     C                   EVAL      R2RPL3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2RPL3        F18Chr
     C     AlphaN        CHECK     F18Chr                                 98
     C     Digits        CHECK     R2RPL3:19                              99
     C
     C                   IF        *IN98 = *ON OR *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL3'
     C                   EVAL      MsgIDXAr  = '5046082'
     C                   EVAL      R2RPL3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party's Party ID 3
      *
     C                   IF        R2RPA3 <> *BLANKS
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP3 = *BLANKS AND
     C                             R2RPN3 = *BLANKS
 
     C                   EVAL      FldNamXAr = 'R2RPA3'
     C                   EVAL      MsgIDXAr  = '5046083'
     C                   EVAL      R2RPA3OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   MOVEL     R2RPA3        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPA3'
     C                   EVAL      MsgIDXAr  = '5046084'
     C                   EVAL      R2RPA3OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                            MD022393
     C                   IF        R2TTY4 = '0'                                             MD022393
     C**********                   AND R2TTY1 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY2 <> '0'                               MD022393 MD022633
     C**********                   AND R2TTY3 <> '0'                               MD022393 MD022633
     C                             AND WR2TTY4 <> '0'                                       MD022633
     C                             AND RLACTN = 'A'                                         MD022393
     C                             AND (R2RPJ4 = *BLANKS OR                                 MD022393
     C                                  R2RPP4 = *BLANKS OR                                 MD022393
     C                                  R2RPA4 = *BLANKS)                                   MD022393
     C                             AND WRType4 <> '0'                                       MD024179
                                                                                            MD022393
     C                   EVAL      WRType4 = '0'                                            MD024179
     C                   CALLB     'DLRPIFDFT'                                              MD022393
     C                   PARM      *BLANKS       PRtCd                                      MD022393
     C                   PARM                    DLRILKPDIn                                 MD022393
     C                   PARM                    DLDefault1                                 MD022393
     C                   PARM                    DLDefault2                                 MD022393
     C                   PARM                    DLDefault3                                 MD022393
     C                   PARM                    DLDefault4                                   CSW214
     C                   PARM                    PayAmount                                  MD024151
                                                                                            MD022393
     C                   IF        R2RPJ4 = *BLANKS                                         MD022393
     C                   EVAL      R2RPJ4 = D_R2RPJ1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPA4 = *BLANKS                                         MD022393
     C                   EVAL      R2RPA4 = D_R2RPA1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   EXSR      SRDftRp4Flds                                             MD022393
     C                   IF        R2RPP4 = *BLANKS                                         MD022393
     C                             AND R2RPN4 = *BLANKS                                     MD024166
     C                             AND R2TRC4 = *BLANKS                                     MD024166
     C                             AND R2RPS4 = *BLANKS                                     MD024166
     C                             AND R2RPL4 = *BLANKS                                     MD024166
     C                   EVAL      R2RPP4 = D_R2RPP1                                        MD022393
     C                   ENDIF                                                              MD022393
     C                   IF        R2RPP4 <> *BLANKS                                        MD022393
     C                             AND WR2DFT4 = 'N'                                        MD022393
     C                   EVAL      WR2DFTR4 = 'N'                                           MD022393
     C                   MOVE      R2RPP4        FValid                                     MD022393
     C                   MOVE      'R2RPP4'      FValFld                                    MD022393
     C                   EXSR      VRppt                                                    MD022393
     C                   MOVE      FValidOK      R2RPP4OK                                   MD022393
     C                   MOVE      BBCUST        R2CUS4                                     MD022393
     C                   IF        R2RPP4OK = *BLANKS                                       MD022393
     C                   IF        R2RPN4 = *BLANKS AND                                     MD022393
     C                             R2TRC4 = *BLANKS AND                                     MD022393
     C                             R2RPS4 = *BLANKS AND                                     MD022393
     C                             R2RPL4 = *BLANKS OR                                      MD022393
     C                             R2RPN4 = BBCRNM AND                                      MD022393
     C                             R2TRC4 = BBCRTN AND                                      MD022393
     C                             R2RPS4 = BBCSID AND                                      MD022393
     C                             R2RPL4 = CSLEIC                                          MD022393
     C                   EVAL      R2RPN4 = BBCRNM                                          MD022393
     C                   EVAL      R2TRC4 = BBCRTN                                          MD022393
     C                   EVAL      R2RPS4 = BBCSID                                          MD022393
     C                   EVAL      R2RPL4 = CSLEIC                                          MD022393
     C                   EVAL      WR2DFTR4 = 'Y'                                           MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
     C                   ENDIF                                                              MD022393
                                                                                            MD022393
     C                   ENDIF                                                              MD022393
      *
      ** Validate Reporting Jurisdiction 4
      *
     C                   IF        R2RPJ4 =  *BLANKS
 
     C                   IF        R2RPP4 <> *BLANKS OR
     C                             R2RPN4 <> *BLANKS OR
     C                             R2TRC4 <> *BLANKS OR
     C                             R2RPS4 <> *BLANKS OR
     C                             R2RPL4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ4'
     C                   EVAL      MsgIDXAr  = '5046058'
     C                   EVAL      R2RPJ4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVEL     R2RPJ4        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPJ4'
     C                   EVAL      MsgIDXAr  = '5046059'
     C                   EVAL      R2RPJ4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party 4
      *
      ** Default other Reporting fields first before validation
      *
     C                   EXSR      SRDftRp4Flds
      *
     C                   EVAL      WR2DFTR4 = 'N'                                           MD022359
     C                   IF        R2RPP4 <> *BLANKS
     C                             AND WR2DFT4 = 'N'
 
     C                   IF        R2RPJ4 =  *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPP4'
     C                   EVAL      MsgIDXAr  = '5046060'
     C                   EVAL      R2RPP4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   EVAL      WR2DFTR4 = 'N'                                           MD022120
                                                                                            MD022120
     C                   MOVE      R2RPP4        FValid
     C                   MOVE      'R2RPP4'      FValFld
     C                   EXSR      VRppt
     C                   MOVE      FValidOK      R2RPP4OK
     C                   MOVE      BBCUST        R2CUS4
     C                   IF        R2RPP4OK = *BLANKS                                       MD022120
     C                   IF        R2RPN4 = *BLANKS AND                                     MD022120
     C                             R2TRC4 = *BLANKS AND                                     MD022120
     C                             R2RPS4 = *BLANKS AND                                     MD022120
     C                             R2RPL4 = *BLANKS OR                                      MD022120
     C                             R2RPN4 = BBCRNM AND                                      MD022120
     C                             R2TRC4 = BBCRTN AND                                      MD022120
     C                             R2RPS4 = BBCSID AND                                      MD022120
     C                             R2RPL4 = CSLEIC                                          MD022120
     C                   EVAL      R2RPN4 = BBCRNM                                          MD022120
     C                   EVAL      R2TRC4 = BBCRTN                                          MD022120
     C                   EVAL      R2RPS4 = BBCSID                                          MD022120
     C                   EVAL      R2RPL4 = CSLEIC                                          MD022120
     C                   EVAL      WR2DFTR4 = 'Y'                                           MD022120
     C                   ENDIF                                                              MD022120
                                                                                            MD022120
     C                   ENDIF                                                              MD022120
 
     C                   ENDIF
                                                                                            MD022633
     C                   IF        WCUSNO4 <> R2RPP4                                        MD022633
     C                   EXSR      SRTransType                                              MD022633
     C                   ENDIF                                                              MD022633
      *
      ** Validate Reporting Party Name 4
      *
     C                   IF        R2RPN4 <> *BLANKS
     C                             AND WR2DFT4 = 'N'
     C                             AND WR2DFTR4 = 'N'                                       MD022120
 
     C                   IF        R2RPP4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPN4'
     C                   EVAL      MsgIDXAr  = '5046062'
     C                   EVAL      R2RPN4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2RPN4        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPN4'
     C                   EVAL      MsgIDXAr  = '5046063'
     C                   EVAL      R2RPN4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *                                                                                     MD022251
      ** Default Transaction Id type first before validating                                MD022251
      ** UTI Namespace and Transaction Id                                                   MD022251
      *                                                                                     MD022251
     C                   IF        R2TTY4 = *BLANKS AND                                     MD022251
     C                              R2TRI4 <> *BLANKS AND                                   MD022251
     C**********                    R2UTI1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT1 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT2 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2UTI3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TRI3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2TTY3 = *BLANKS AND                           MD022251 MD022633
     C**********                    R2EVT3 = *BLANKS                               MD022251 MD022633
     C                              *IN14 = *OFF AND                                        MD022633
     C                              *IN24 = *OFF AND                                        MD022633
     C                              *IN34 = *OFF                                            MD022633
     C                   EVAL      R2TTY4 = '0'                                             MD022251
     C                   ENDIF                                                              MD022251
      *
      ** Validate Namespace 4
      *
     C                   IF        R2UTI4 =  *BLANKS
 
     C                   IF        R2TRI4 <> *BLANKS OR
     C                             R2TTY4 <> *BLANKS OR
     C                             R2EVT4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI4'
     C                   EVAL      MsgIDXAr  = '5046064'
     C                   EVAL      R2UTI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2TRI4 = *BLANKS OR
     C                             R2TTY4 = *BLANKS OR
     C                             R2EVT4 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI4'
     C                   EVAL      MsgIDXAr  = '5046087'
     C                   EVAL      R2UTI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
     C                   IF        R2RPJ4 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI4'
     C                   EVAL      MsgIDXAr  = '5046065'
     C                   EVAL      R2UTI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2UTI4        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2UTI4'
     C                   EVAL      MsgIDXAr  = '5046066'
     C                   EVAL      R2UTI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                              CSW216
     C                   IF        CSW216 <> 'Y'                                              CSW216
     C                   IF        %SUBST(R2UTI4:21:10) <> *BLANKS                            CSW216
     C                   EXSR      ResetErrs                                                  CSW216
     C                   EVAL      FldNamXAr = 'R2UTI4'                                       CSW216
     C                   EVAL      MsgIDXAr  = '5048669'                                      CSW216
     C                   EVAL      R2UTI4OK  = 'N'                                            CSW216
     C                   EXSR      UpdatErrs                                                  CSW216
     C                   ENDIF                                                                CSW216
                                                                                              CSW216
     C                   ELSE                                                                 CSW216     
                                                                                              CSW214
     C                   IF        CSW214 <> 'Y'                                              CSW214
     C                   IF        %SUBST(R2UTI4:11:10) <> *BLANKS                            CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      FldNamXAr = 'R2UTI4'                                       CSW214
     C                   EVAL      MsgIDXAr  = '5047319'                                      CSW214
     C                   EVAL      R2UTI4OK  = 'N'                                            CSW214
     C                   EXSR      UpdatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW216
     C                   ENDIF                                                                CSW216
 
     C                   ENDIF
      *
      ** Validate Transaction Identifier 4
      *
     C                   IF        R2TRI4 =  *BLANKS
 
     C                   IF        R2UTI4 <> *BLANKS OR
     C                             R2TTY4 <> *BLANKS OR
     C                             R2EVT4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI4'
     C                   EVAL      MsgIDXAr  = '5046067'
     C                   EVAL      R2TRI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
      *
     C                   IF        R2UTI4 = *BLANKS OR
     C                             R2TTY4 = *BLANKS OR
     C                             R2EVT4 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI4'
     C                   EVAL      MsgIDXAr  = '5046088'
     C                   EVAL      R2TRI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2TRI4        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRI4'
     C                   EVAL      MsgIDXAr  = '5046068'
     C                   EVAL      R2TRI4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party City 4
      *
     C                   IF        R2TRC4 <> *BLANKS
     C                             AND WR2DFT4 = 'N'
     C                             AND WR2DFTR4 = 'N'                                       MD022120
 
     C                   IF        R2RPN4 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC4'
     C                   EVAL      MsgIDXAr  = '5046069'
     C                   EVAL      R2TRC4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   IF        R2RPP4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC4'
     C                   EVAL      MsgIDXAr  = '5046070'
     C                   EVAL      R2TRC4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2TRC4        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TRC4'
     C                   EVAL      MsgIDXAr  = '5046071'
     C                   EVAL      R2TRC4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Transaction Identifier Type 4
      *
     C**********         IF        R2TTY4 = *BLANKS AND                                    MD022251A
     C**********                    R2TRI4 <> *BLANKS AND                                  MD022251A
     C**********                    R2UTI1 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI1 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY1 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT1 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI2 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI2 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY2 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT2 = *BLANKS AND                                   MD022251A
     C**********                    R2UTI3 = *BLANKS AND                                   MD022251A
     C**********                    R2TRI3 = *BLANKS AND                                   MD022251A
     C**********                    R2TTY3 = *BLANKS AND                                   MD022251A
     C**********                    R2EVT3 = *BLANKS                                       MD022251A
     C**********         EVAL      R2TTY4 = '0'                                            MD022251A
     C**********         ENDIF                                                             MD022251A
     C                   IF        R2TTY4 <> *BLANKS AND
     C                             (R2UTI4 = *BLANKS OR
     C                              R2TRI4 = *BLANKS OR
     C                              R2EVT4 = *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY4'
     C                   EVAL      MsgIDXAr  = '5046072'
     C                   EVAL      R2TTY4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF                                                              MD022633
 
     C**********         ELSE                                                               MD022633
 
     C                   IF        R2TTY4 =  '0'
                                                                                            MD022633
     C**********         IF        R2TTY1 =  '0' OR                                         MD022633
     C**********                   R2TTY2 =  '0' OR                                         MD022633
     C**********                   R2TTY3 =  '0'                                            MD022633
     C                   IF        WR2TTY4 = '0'                                            MD022633
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY4'
     C                   EVAL      MsgIDXAr  = '5046073'
     C                   EVAL      R2TTY4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
                                                                                            MD022633
     C                   ELSE                                                               MD022633
                                                                                            MD022633
     C                   Z-ADD     1             X                                          MD022633
     C                   MOVEA     *BLANKS       ArrTType                                   MD022633
     C   14              EVAL      ArrTType(X) = R2TTY1                                     MD022633
     C   14              ADD       1             X                                          MD022633
     C   24              EVAL      ArrTType(X) = R2TTY2                                     MD022633
     C   24              ADD       1             X                                          MD022633
     C   34              EVAL      ArrTType(X) = R2TTY3                                     MD022633
     C   34              ADD       1             X                                          MD022633
     C     '0'           LOOKUP    ArrTType                               01                MD022633
     C                   IF        *IN01 = *OFF                                             MD022633
     C                             AND R2TTY4 <> *BLANKS                                    MD022633
     C                   EXSR      ResetErrs                                                MD022633
     C                   EVAL      FldNamXAr = 'R2TTY4'                                     MD022633
     C                   EVAL      MsgIDXAr  = '5046113'                                    MD022633
     C                   EVAL      R2TTY1OK  = 'N'                                          MD022633
     C                   EXSR      UpdatErrs                                                MD022633
     C                   ENDIF                                                              MD022633
                                                                                            MD022633
     C                   ENDIF
 
     C     TrnTyp        CHECK     R2TTY4                                 99
     C                   IF        *IN99 = *ON
     C                             AND R2TTY4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY4'
     C                   EVAL      MsgIDXAr  = '5046074'
     C                   EVAL      R2TTY4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C**********         ENDIF                                                              MD022633
     C                   IF        R2TTY4 = *BLANKS AND
     C                             (R2UTI4 <> *BLANKS OR
     C                              R2TRI4 <> *BLANKS OR
     C                              R2EVT4 <> *BLANKS)
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2TTY4'
     C                   EVAL      MsgIDXAr  = '5046089'
     C                   EVAL      R2TTY4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
      *
      ** Validate Event Type 4
      *
     C                   IF        R2EVT4 <> *BLANKS
 
     C                   IF        R2UTI4 =  *BLANKS OR
     C                             R2TRI4 =  *BLANKS OR
     C                             R2TTY4 =  *BLANKS
     C
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT4'
     C                   EVAL      MsgIDXAr  = '5046075'
     C                   EVAL      R2EVT4OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C     EvnTyp        CHECK     R2EVT4                                 99
     C                   IF        *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT4'
     C                   EVAL      MsgIDXAr  = '5046076'
     C                   EVAL      R2EVT4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R2UTI4 <> *BLANKS OR
     C                             R2TRI4 <> *BLANKS OR
     C                             R2TTY4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2EVT4'
     C                   EVAL      MsgIDXAr  = '5046090'
     C                   EVAL      R2EVT4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party SWIFT Identification 4
      *
     C                   IF        R2RPS4 <> *BLANKS
     C                             AND WR2DFT4 = 'N'
     C                             AND WR2DFTR4 = 'N'                                       MD022120
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP4 <> *BLANKS
     C
     C                   EVAL      FldNamXAr = 'R2RPS4'
     C                   EVAL      MsgIDXAr  = '5046077'
     C                   EVAL      R2RPS4OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   EVAL      WRpSwf  = R2RPS4
     C                   EVAL      FValFld = 'R2RPS4'
     C                   EXSR      VRpSwft
     C                   EVAL      R2RPS4OK = R2RPSOK
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party LEI 4
      *
     C                   IF        R2RPL4 <> *BLANKS
     C                             AND WR2DFT4 = 'N'
     C                             AND WR2DFTR4 = 'N'                                       MD022120
 
     C                   IF        R2RPN4 = *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL4'
     C                   EVAL      MsgIDXAr  = '5046080'
     C                   EVAL      R2RPL4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   IF        R2RPP4 <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL4'
     C                   EVAL      MsgIDXAr  = '5046081'
     C                   EVAL      R2RPL4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   MOVEL     R2RPL4        F18Chr
     C     AlphaN        CHECK     F18Chr                                 98
     C     Digits        CHECK     R2RPL4:19                              99
     C
     C                   IF        *IN98 = *ON OR *IN99 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      FldNamXAr = 'R2RPL4'
     C                   EVAL      MsgIDXAr  = '5046082'
     C                   EVAL      R2RPL4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Reporting Party's Party ID 4
      *
     C                   IF        R2RPA4 <> *BLANKS
 
     C                   EXSR      ResetErrs
 
     C                   IF        R2RPP4 = *BLANKS AND
     C                             R2RPN4 = *BLANKS
 
     C                   EVAL      FldNamXAr = 'R2RPA4'
     C                   EVAL      MsgIDXAr  = '5046083'
     C                   EVAL      R2RPA4OK  = 'N'
     C                   EXSR      UpdatErrs
 
     C                   ELSE
 
     C                   MOVEL     R2RPA4        FldChk
     C                   EXSR      SWSet
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNamXAr = 'R2RPA4'
     C                   EVAL      MsgIDXAr  = '5046084'
     C                   EVAL      R2RPA4OK  = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
                                                                                            MD022024
     C                   CLOSE     MEBIB3L1                                                 MD022024
      *
      ** Return to calling program
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     VRppt         BEGSR
      *
     C                   EVAL      FValidOK = ' '
      *
      ** Check if the value entered is a valid customer
      *
     C**********         CALL      'AOCUSTR0'                                               MD022120
     C**********         PARM      *BLANKS       PRtcd                                      MD022120
     C**********         PARM      '*KEY'        POptn                                      MD022120
     C**********         PARM      FValid        PCusn                                      MD022120
     C**********         PARM      *BLANKS       PKySt                                      MD022120
     C*****SDCUST        PARM      SDCUST        DSSDY                                      MD022120
      *                                                                                     MD022120
     C                   CALL      'AOCSSWR0'                                               MD022120
     C                   PARM      *BLANKS       PRtCd                                      MD022120
     C                   PARM      '*KEY'        POptn                                      MD022120
     C                   PARM      FValid        PCusn                                      MD022120
     C                   PARM                    PKySt                                      MD022120
     C                   PARM                    DSLDY                                      MD022120
 
     C                   IF        PRtCd <> *BLANKS
 
     C                   EXSR      ResetErrs
     C                   EVAL      FValidOK  = 'N'
     C                   EVAL      FldNamXAr = FValFld
     C                   EVAL      MsgIdXAr  = '5046061'
     C                   EXSR      UpdatErrs
 
     C                   ELSE                                                               MD022120
                                                                                            MD022120
     C                   EVAL      WStr = %Len(SDCUST) + 1                                  MD022120
     C                   EVAL      WLen = %Len(SDCSSW)                                      MD022120
     C                   EVAL      SDCUST = DSLDY                                           MD022120
     C                   EVAL      SDCSSW = %Subst(DSLDY:WStr:WLen)                         MD022120
                                                                                            MD022120
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     VRpSwft       BEGSR
 
     C                   EVAL      R2RPSOK = ' '
      *
     C                   IF        NOT %OPEN(MEBIB3L1)                                      MD022429
     C                   OPEN      MEBIB3L1                                                 MD022024
     C                   ENDIF                                                              MD022429
     C     *LOVAL        SETLL     MEBIB3L1
     C                   IF        CFT050 = 'Y'
     C                             AND %FOUND
 
     C                   MOVEL     WRpSwf        KB3BIC
     C                   MOVE      WRpSwf        KB3BRC
     C     KBICBR        CHAIN     MEBIB3L1
     C                   IF        NOT %FOUND
     C                   EVAL      FldNamXAr = FValFld
     C                   EVAL      MsgIDXAr  = '5046078'
     C                   EVAL      R2RPSOK   = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVEL     WRpSwf        F6Char
     C     Alpha         CHECK     F6Char                                 98
     C     AlphaN        CHECK     WRPSWF:7      WInvalChar               99
     C                   EVAL      WLength= %LEN(%TRIM(WRPSWF))
     C
     C                   IF        WLength<> 8 AND WLength<> 11
     C                             OR *IN98 = *ON OR *IN99 = *ON
     C                             AND WInvalChar <= WLength
     C                   EVAL      FldNamXAr = FValFld
     C                   EVAL      MsgIDXAr  = '5046079'
     C                   EVAL      R2RPSOK   = 'N'
     C                   EXSR      UpdatErrs
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     SWSet         BEGSR
 
      * Reset variables updated by each module
 
     C                   SETOFF                                       99
 
     C     ISO           CHECK     FldChk                                 99
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     SETUPVALID    BEGSR
      *
      ** Move validated fields to DLVRPIPD fields
      *
     C                   MOVEL     R2RPJ1        RVRJ01
     C                   MOVEL     R2CUS1        RVRP01
     C                   MOVEL     R2RPN1        RVRN01
     C                   MOVEL     R2UTI1        RVUT01
     C                   IF        %SUBST(R2TRI1:8:6) = '999999'                            MD021933
     C                              AND RLTRRF <> *BLANKS                                   MD021933
     C                   EVAL      %SUBST(R2TRI1:8:6) = RLTRRF                              MD021933
     C                   ENDIF                                                              MD021933
     C                   MOVEL     R2TRI1        RVTNI1
     C                   MOVEL     R2TRC1        RVRC01
     C                   MOVEL     R2TTY1        RVTIT1
     C                   MOVEL     R2EVT1        RVETT1
     C                   MOVEL     R2RPS1        RVRS01
     C                   MOVEL     R2RPL1        RVRL01
     C                   MOVEL     R2RPA1        RVRA01
     C                   MOVEL     R2RPJ2        RVRJ02
     C                   MOVEL     R2CUS2        RVRP02
     C                   MOVEL     R2RPN2        RVRN02
     C                   MOVEL     R2UTI2        RVUT02
     C                   MOVEL     R2TRI2        RVTNI2
     C                   MOVEL     R2TRC2        RVRC02
     C                   MOVEL     R2TTY2        RVTIT2
     C                   MOVEL     R2EVT2        RVETT2
     C                   MOVEL     R2RPS2        RVRS02
     C                   MOVEL     R2RPL2        RVRL02
     C                   MOVEL     R2RPA2        RVRA02
     C                   MOVEL     R2RPJ3        RVRJ03
     C                   MOVEL     R2CUS3        RVRP03
     C                   MOVEL     R2RPN3        RVRN03
     C                   MOVEL     R2UTI3        RVUT03
     C                   MOVEL     R2TRI3        RVTNI3
     C                   MOVEL     R2TRC3        RVRC03
     C                   MOVEL     R2TTY3        RVTIT3
     C                   MOVEL     R2EVT3        RVETT3
     C                   MOVEL     R2RPS3        RVRS03
     C                   MOVEL     R2RPL3        RVRL03
     C                   MOVEL     R2RPA3        RVRA03
     C                   MOVEL     R2RPJ4        RVRJ04
     C                   MOVEL     R2CUS4        RVRP04
     C                   MOVEL     R2RPN4        RVRN04
     C                   MOVEL     R2UTI4        RVUT04
     C                   MOVEL     R2TRI4        RVTNI4
     C                   MOVEL     R2TRC4        RVRC04
     C                   MOVEL     R2TTY4        RVTIT4
     C                   MOVEL     R2EVT4        RVETT4
     C                   MOVEL     R2RPS4        RVRS04
     C                   MOVEL     R2RPL4        RVRL04
     C                   MOVEL     R2RPA4        RVRA04
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDftRp1Flds                                                  *
      *****************************************************************
 
     C     SRDftRp1Flds  BEGSR
      *
     C                   EVAL      WR2DFT1 = 'N'
     C                   EVAL      R2CUS1 = *BLANKS                                         MD021933
     C                   IF        R2RPP1 =  *BLANKS  AND
     C                             R2RPA1 <> *BLANKS AND
     C                             R2RPJ1 <> *BLANKS
     C                             AND R2RPN1 = *BLANKS
     C                             AND R2TRC1 = *BLANKS
     C                             AND R2RPS1 = *BLANKS
     C                             AND R2RPL1 = *BLANKS
      *
     C                   CLEAR                   SDBRCH
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RLBRCA        PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCustn = A8BICN
      *
     C                   CLEAR                   DSLDY
      *
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustn        PCusn
     C                   PARM                    PKySt
     C                   PARM                    DSLDY
      *
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      WStr = %Len(SDCUST) + 1
     C                   EVAL      WLen = %Len(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   EVAL      R2RPN1 = BBCRNM
     C                   EVAL      R2TRC1 = BBCRTN
     C                   EVAL      R2RPS1 = BBCSID
     C                   EVAL      R2RPL1 = CSLEIC
     C                   EVAL      R2RPP1 = WCustn
     C                   EVAL      WR2RPN1 = BBCRNM
     C                   EVAL      WR2TRC1 = BBCRTN
     C                   EVAL      WR2RPS1 = BBCSID
     C                   EVAL      WR2RPL1 = CSLEIC
     C                   EVAL      WR2RPP1 = WCustn
     C                   EVAL      WR2RPA1 = R2RPA1
     C                   EVAL      WR2DFT1 = 'Y'
     C                   EVAL      R2CUS1 = WCustn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WR2RPN1 = R2RPN1 AND
     C                             WR2TRC1 = R2TRC1 AND
     C                             WR2RPS1 = R2RPS1 AND
     C                             WR2RPL1 = R2RPL1 AND
     C                             WR2RPP1 = R2RPP1 AND
     C                             WR2RPA1 = R2RPA1
     C                   EVAL      WR2DFT1 = 'Y'
     C                   EVAL      R2CUS1 = R2RPP1                                          MD024146
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDftRp2Flds                                                  *
      *****************************************************************
 
     C     SRDftRp2Flds  BEGSR
      *
     C                   EVAL      WR2DFT2 = 'N'
     C                   EVAL      R2CUS2 = *BLANKS                                         MD021933
     C                   IF        R2RPP2 =  *BLANKS  AND
     C                             R2RPA2 <> *BLANKS AND
     C                             R2RPJ2 <> *BLANKS
     C                             AND R2RPN2 = *BLANKS
     C                             AND R2TRC2 = *BLANKS
     C                             AND R2RPS2 = *BLANKS
     C                             AND R2RPL2 = *BLANKS
      *
     C                   CLEAR                   SDBRCH
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RLBRCA        PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCustn = A8BICN
      *
     C                   CLEAR                   DSLDY
      *
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustn        PCusn
     C                   PARM                    PKySt
     C                   PARM                    DSLDY
      *
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      WStr = %Len(SDCUST) + 1
     C                   EVAL      WLen = %Len(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   EVAL      R2RPN2 = BBCRNM
     C                   EVAL      R2TRC2 = BBCRTN
     C                   EVAL      R2RPS2 = BBCSID
     C                   EVAL      R2RPL2 = CSLEIC
     C                   EVAL      R2RPP2 = WCustn
     C                   EVAL      WR2RPN2 = BBCRNM
     C                   EVAL      WR2TRC2 = BBCRTN
     C                   EVAL      WR2RPS2 = BBCSID
     C                   EVAL      WR2RPL2 = CSLEIC
     C                   EVAL      WR2RPP2 = WCustn
     C                   EVAL      WR2RPA2 = R2RPA2
     C                   EVAL      WR2DFT2 = 'Y'
     C                   EVAL      R2CUS2 = WCustn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WR2RPN2 = R2RPN2 AND
     C                             WR2TRC2 = R2TRC2 AND
     C                             WR2RPS2 = R2RPS2 AND
     C                             WR2RPL2 = R2RPL2 AND
     C                             WR2RPP2 = R2RPP2 AND
     C                             WR2RPA2 = R2RPA2
     C                   EVAL      WR2DFT2 = 'Y'
     C                   EVAL      R2CUS2 = R2RPP2                                          MD024146
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDftRp3Flds                                                  *
      *****************************************************************
 
     C     SRDftRp3Flds  BEGSR
      *
     C                   EVAL      WR2DFT3 = 'N'
     C                   EVAL      R2CUS3 = *BLANKS                                         MD021933
     C                   IF        R2RPP3 =  *BLANKS  AND
     C                             R2RPA3 <> *BLANKS AND
     C                             R2RPJ3 <> *BLANKS
     C                             AND R2RPN3 = *BLANKS
     C                             AND R2TRC3 = *BLANKS
     C                             AND R2RPS3 = *BLANKS
     C                             AND R2RPL3 = *BLANKS
      *
     C                   CLEAR                   SDBRCH
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RLBRCA        PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCustn = A8BICN
      *
     C                   CLEAR                   DSLDY
      *
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustn        PCusn
     C                   PARM                    PKySt
     C                   PARM                    DSLDY
      *
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      WStr = %Len(SDCUST) + 1
     C                   EVAL      WLen = %Len(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   EVAL      R2RPN3 = BBCRNM
     C                   EVAL      R2TRC3 = BBCRTN
     C                   EVAL      R2RPS3 = BBCSID
     C                   EVAL      R2RPL3 = CSLEIC
     C                   EVAL      R2RPP3 = WCustn
     C                   EVAL      WR2RPN3 = BBCRNM
     C                   EVAL      WR2TRC3 = BBCRTN
     C                   EVAL      WR2RPS3 = BBCSID
     C                   EVAL      WR2RPL3 = CSLEIC
     C                   EVAL      WR2RPP3 = WCustn
     C                   EVAL      WR2RPA3 = R2RPA3
     C                   EVAL      WR2DFT3 = 'Y'
     C                   EVAL      R2CUS3 = WCustn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WR2RPN3 = R2RPN3 AND
     C                             WR2TRC3 = R2TRC3 AND
     C                             WR2RPS3 = R2RPS3 AND
     C                             WR2RPL3 = R2RPL3 AND
     C                             WR2RPP3 = R2RPP3 AND
     C                             WR2RPA3 = R2RPA3
     C                   EVAL      WR2DFT3 = 'Y'
     C                   EVAL      R2CUS3 = R2RPP3                                          MD024146
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDftRp4Flds                                                  *
      *****************************************************************
 
     C     SRDftRp4Flds  BEGSR
      *
     C                   EVAL      WR2DFT4 = 'N'
     C                   EVAL      R2CUS4 = *BLANKS                                         MD021933
     C                   IF        R2RPP4 =  *BLANKS  AND
     C                             R2RPA4 <> *BLANKS AND
     C                             R2RPJ4 <> *BLANKS
     C                             AND R2RPN4 = *BLANKS
     C                             AND R2TRC4 = *BLANKS
     C                             AND R2RPS4 = *BLANKS
     C                             AND R2RPL4 = *BLANKS
      *
     C                   CLEAR                   SDBRCH
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RLBRCA        PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCustn = A8BICN
      *
     C                   CLEAR                   DSLDY
      *
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustn        PCusn
     C                   PARM                    PKySt
     C                   PARM                    DSLDY
      *
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      WStr = %Len(SDCUST) + 1
     C                   EVAL      WLen = %Len(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   EVAL      R2RPN4 = BBCRNM
     C                   EVAL      R2TRC4 = BBCRTN
     C                   EVAL      R2RPS4 = BBCSID
     C                   EVAL      R2RPL4 = CSLEIC
     C                   EVAL      R2RPP4 = WCustn
     C                   EVAL      WR2RPN4 = BBCRNM
     C                   EVAL      WR2TRC4 = BBCRTN
     C                   EVAL      WR2RPS4 = BBCSID
     C                   EVAL      WR2RPL4 = CSLEIC
     C                   EVAL      WR2RPP4 = WCustn
     C                   EVAL      WR2RPA4 = R2RPA4
     C                   EVAL      WR2DFT4 = 'Y'
     C                   EVAL      R2CUS4 = WCustn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WR2RPN4 = R2RPN4 AND
     C                             WR2TRC4 = R2TRC4 AND
     C                             WR2RPS4 = R2RPS4 AND
     C                             WR2RPL4 = R2RPL4 AND
     C                             WR2RPP4 = R2RPP4 AND
     C                             WR2RPA4 = R2RPA4
     C                   EVAL      WR2DFT4 = 'Y'
     C                   EVAL      R2CUS4 = R2RPP4                                          MD024146
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD022633
      * SRTransType                                                   *                     MD022633
      *****************************************************************                     MD022633
                                                                                            MD022633
     C     SRTransType   BEGSR                                                              MD022633
      *                                                                                     MD022633
     C                   EVAL      WR2TTY1 = '1'                                            MD022633
     C                   EVAL      WR2TTY2 = '1'                                            MD022633
     C                   EVAL      WR2TTY3 = '1'                                            MD022633
     C                   EVAL      WR2TTY4 = '1'                                            MD022633
     C                   EVAL      WCUSNO1 = R2RPP1                                         MD022633
     C                   EVAL      WCUSNO2 = R2RPP2                                         MD022633
     C                   EVAL      WCUSNO3 = R2RPP3                                         MD022633
     C                   EVAL      WCUSNO4 = R2RPP4                                         MD022633
     C                   SETOFF                                       121314                MD022633
     C                   SETOFF                                       232434                MD022633
                                                                                            MD022633
     C                   IF        COMBI1 <> *BLANKS                                        MD022633
      *                                                                                     MD022633
     C     COMBI1        COMP      COMBI2                                 12                MD022633
     C                   IF        *IN12 = *ON AND                                          MD022633
     C                             R2TTY1 = '0' AND R2TTY2 = '0'                            MD022633
     C                   EVAL      WR2TTY1 = '0'                                            MD022633
     C                   EVAL      WR2TTY2 = '0'                                            MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C     COMBI1        COMP      COMBI3                                 13                MD022633
     C                   IF        *IN13 = *ON AND                                          MD022633
     C                             R2TTY1 = '0' AND R2TTY3 = '0'                            MD022633
     C                   EVAL      WR2TTY1 = '0'                                            MD022633
     C                   EVAL      WR2TTY3 = '0'                                            MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C     COMBI1        COMP      COMBI4                                 14                MD022633
     C                   IF        *IN14 = *ON AND                                          MD022633
     C                             R2TTY1 = '0' AND R2TTY4 = '0'                            MD022633
     C                   EVAL      WR2TTY1 = '0'                                            MD022633
     C                   EVAL      WR2TTY4 = '0'                                            MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C                   ENDIF                                                              MD022633
                                                                                            MD022633
     C                   IF        COMBI2 <> *BLANKS                                        MD022633
      *                                                                                     MD022633
     C     COMBI2        COMP      COMBI3                                 23                MD022633
     C                   IF        *IN23 = *ON AND                                          MD022633
     C                             R2TTY2 = '0' AND R2TTY3 = '0'                            MD022633
     C                   EVAL      WR2TTY2 = '0'                                            MD022633
     C                   EVAL      WR2TTY3 = '0'                                            MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C     COMBI2        COMP      COMBI4                                 24                MD022633
     C                   IF        *IN24 = *ON AND                                          MD022633
     C                             R2TTY2 = '0' AND R2TTY4 = '0'                            MD022633
     C                   EVAL      WR2TTY2 = '0'                                            MD022633
     C                   EVAL      WR2TTY4 = '0'                                            MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C                   ENDIF                                                              MD022633
                                                                                            MD022633
     C                   IF        COMBI3 <> *BLANKS                                        MD022633
      *                                                                                     MD022633
     C     COMBI3        COMP      COMBI4                                 34                MD022633
     C                   IF        *IN34 = *ON AND                                          MD022633
     C                             R2TTY3 = '0' AND R2TTY4 = '0'                            MD022633
     C                   EVAL      WR2TTY3 = '0'                                            MD022633
     C                   EVAL      WR2TTY4 = '0'                                            MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C                   ENDIF                                                              MD022633
      *                                                                                     MD022633
     C                   ENDSR                                                              MD022633
      *****************************************************************                     MD022633
      /EJECT                                                                                MD022633
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    WRetCode
     C                   PARM                    DLRILKPDIn
     C                   PARM                    DLRDetail1
     C                   PARM                    DLRDetail2
     C                   PARM                    DLRError2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    IDx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRFileFmt
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'DLRIS2VAL'   DBPGM
     C                   OUT       LDA
      *
      ** Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *
      ** Check if CFT050 is a valid record in SCSARDPD
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PrtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT050'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     PrtCd         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT050            1
     C                   ELSE
     C                   MOVEL     'N'           CFT050
     C                   ENDIF
                                                                                              CSW214
      ** Check if SWIFT 2014 Changes is installed                                             CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
                                                                                              CSW214
     C                   IF        PRTCD   = 'CSW2014'                                        CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW216
      ** Check if SWIFT 2014 Changes is installed                                             CSW216
                                                                                              CSW216
     C                   CALL      'SWIF2016'                                                 CSW216
     C                   PARM      *BLANKS       PRTCD                                        CSW216
                                                                                              CSW216
     C                   IF        PRTCD   = 'CSW2016'                                        CSW216
     C                   EVAL      CSW216 = 'Y'                                               CSW216
     C                   ELSE                                                                 CSW216
     C                   EVAL      CSW216 = 'N'                                               CSW216
     C                   ENDIF                                                                CSW216
      *
      ***  Key list definition
      *
     C     KBICBR        KLIST
     C                   KFLD                    KB3BIC
     C                   KFLD                    KB3BRC
 
     C     KRPIF         KLIST
     C                   KFLD                    RLAPID
     C                   KFLD                    RLTRRF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErrs - Reset error information that is received back     *
      *             from each validation module.                      *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UpdatErrs - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UpdatErrs     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   IF        FldNamXAr <> *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNameArr(I) = FldNamXAr
     C                   EVAL      MsgIdArr(I)   = MsgIDXAr
     C                   EVAL      MsgDtaArr(I)  = MsgDtaXAr
     C                   END
      *
     C                   Z-ADD     I             Idx
 
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
