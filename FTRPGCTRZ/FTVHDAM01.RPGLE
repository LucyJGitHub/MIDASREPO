     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Sum Header Amounts')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVHDAM01 - Sum Header Amounts                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221538             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 17Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  221538 - Expansion of field details.                         *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *  185107 - Mapping of details from swift message               *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
      *****************************************************************
     FFT102DL0  IF   E           K DISK    Prefix(D)
 
     FFT102HL3  IF   E           K DISK    Prefix(H)
 
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
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Header record datastructure
     D FileRcd       E DS                  EXTNAME(FT102HPD)
     D HdrScreen     E DS                  EXTNAME(FT102HSPD) PREFIX(H)
     D DtlRcdIn      E DS                  EXTNAME(FT102DPD)  PREFIX(CR)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Old CCT ID (used for reassign in credit display screen)
     D OldCctID        S                   Like(HPCCTID)
 
      ** Old Transaction reference
     D OldTransID      S                   Like(DTRNSID)
 
      ** Calling Program (for Message Management and STP)
     D CallingPgm      S             10
 
      ** Network (for Message Management and STP)
     D Network         S                   Like(PNWRK)
 
      ** Parameters passed on entry - for conversion type
     D CnvTyp          S              2
     D Idx             S              3P 0
 
      ** indicator to see if sum of amount should be done
     D SUM             S              1
      ** Message reference                                                      185107
     D MgmsgR          S                   LIKE(PhmsgR)                         185107
      *                                                                                       CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
     D PRtCd           S              7A                                                      CSW201
 
     D/COPY MECPYSRC,ME1100_ILE
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   Eval      RetCodeIn  = *Blanks
 
      * Total Transfer Amount (CCTAMT)
      * Sum of Amounts (where details of charges are OUR)
      * Sum of Senders Charges
      * Sum of Receivers Charges (where details of charges are OUR)
 
      * Convert the amount to file format first
     C                   CallB     'FTM1021CT'
     C                   Parm                    RetCodeIn
     C                   Parm                    Actn              1                          221538
     C                   Parm      *Blanks       PDATA
     C                   PARM      *BLANKS       PDAT2                                        CSW209
     C                   Parm      0             MGMSGR                         185107
     C                   PARM      'FH'          CnvTyp
     C                   Parm                    FileRcd
     C                   Parm                    HdrScreen
 
     C                   Eval      CCTAMT = 0
     C                   Eval      SUMCCT = 0
     C                   Eval      SUMSCG = 0
     C                   Eval      SUMRCH = 0
     C                   Eval      SUM = 'N'
 
     C     CCTID         Setll     FT102HL3
     C     CCTID         chain     FT102HL3                           99
     C                   If        *In99 = *Off
 
 
     C     CCTID         Setll     FT102DL0
     C     CCTID         Reade     FT102DL0                               99
     C                   DoW       *In99 = *Off
 
      *
     C                   IF        HCctChg <> *Blanks OR
     C                             DCcyChg <> *Blanks
      *
      ** not sure about this one- are the charges already included
      *
     C                   IF        HCctChg = 'OUR' OR
     C                             DCcyChg = 'OUR'
     C                   EVAL      CCtAmt = CctAmt + DRcvCtf + DcctAmt
     C                   ENDIF
 
     C                   IF        HCctChg = 'SHA' OR
     C                             DCcyChg = 'SHA'
     C                   EVAL      CCtAmt = CCtAmt + DCctAmt
     C                   ENDIF
 
     C                   IF        HCctChg = 'BEN' OR
     C                             DCcyChg = 'BEN'
     C                   EVAL      CCtAmt = CCtAmt + DCctAmt
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       CSW201
      ** If enhancement 'SWIFT 2001 standard update' is installed,                            CSW201
      ** calculate for SUMSCG = SUMSCG + the last non zero sender's                           CSW201
      ** charges in transfer currency.                                                        CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
     C                   WHEN      DSDCCY5 <> *BLANKS                                         CSW201
     C                   EVAL      SUMSCG = SUMSCG + DSDCTF5                                  CSW201
                                                                                              CSW201
     C                   WHEN      DSDCCY4 <> *BLANKS                                         CSW201
     C                   EVAL      SUMSCG = SUMSCG + DSDCTF4                                  CSW201
                                                                                              CSW201
     C                   WHEN      DSDCCY3 <> *BLANKS                                         CSW201
     C                   EVAL      SUMSCG = SUMSCG + DSDCTF3                                  CSW201
                                                                                              CSW201
     C                   WHEN      DSDCCY2 <> *BLANKS                                         CSW201
     C                   EVAL      SUMSCG = SUMSCG + DSDCTF2                                  CSW201
                                                                                              CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      SUMSCG = SUMSCG + DSNDCTF                                  CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
 
     C                   Eval      SUMSCG = SUMSCG +DSNDCTF
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
     C                   If        HCCTCHG  = 'OUR' Or
     C                             DCCYCHG = 'OUR'
     C                   EVAL      SUM = 'Y'
     C                   Endif
 
     C     CCTID         Reade     FT102DL0                               99
     C                   Enddo
      *
      ** Sum amounts if any details of charges are 'OUR'
      *
     C                   IF        SUM = 'Y'
     C     CCTID         Setll     FT102DL0
     C     CCTID         Reade     FT102DL0                               99
     C                   DoW       *In99 = *Off
     C                   Eval      SUMCCT = SUMCCT + DCCTAMT
     C                   Eval      SUMRCH = SUMRCH + DRCVCTF
     C     CCTID         Reade     FT102DL0                               99
     C                   Enddo
     C                   Endif
      *
     C                   EndIf
      *
      *
      * Update header record
     C                   CallB     'FTM102UPD'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm      'A'           ActCode           1
     C                   Parm                    FileRcd
     C                   Parm                    DtlRcdIn
     C                   Parm      'Y'           HdrInfo           1
     C                   Parm      'N'           DtlInfo           1
     C                   Parm      *Blanks       OldCctID
     C                   Parm      *Blanks       OldTransID
     C                   Parm      *Blanks       CallingPgm
     C                   Parm      *Blanks       Network
      ** Errors produced during I/O operation
     C                   Parm      *Zeros        Idx
     C                   Parm      *Blanks       FldNameArr
     C                   Parm      *Blanks       MsgIdArr
     C                   Parm      *Blanks       MsgDtaArr
      *
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
 
     C                   Parm                    RetCodeIn
      *  Screen fields
     C                   Parm                    HdrScreen
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       PRtCd                                        CSW201
      *                                                                                       CSW201
     C                   IF        PRtCd = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
 
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
