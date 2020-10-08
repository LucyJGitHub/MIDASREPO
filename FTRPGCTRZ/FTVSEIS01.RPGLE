     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')

/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate sending institution')                *


      *  Midas - Standard subprograms                                 *

      *  FTVSEIS01  - Validate Sending Institution                    *

      *  (c) Finastra International Limited 2001                      *

      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *

      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 226083             Date 01Apr04               *
      *                 221760             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                    Date ddmmmyy               *

      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  226083 - Correct various RFTD validation errors.             *
      *           Here, if MEBICDPD is filled, reject entry of        *
      *           customer number/shortname with BIC but not in       *
      *           MEBICDPD.                                           *
      *           by the user but it is an error nevertheless.        *
      *  221760 - Do not validate SWIFT ID if MEBICDPD is empty.      *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
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
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D GenOkFlag       S              1    Import

     D D@BIC         E DS                  EXTNAME(MEBICDPD)
      *  BIC details
     D D@FMT         E DS                  EXTNAME(DSSDY)
      *  External Data structure to hold the outgoing record format
     D A@FMT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
     DSDCUST         E DS                  EXTNAME(SDCUSTPD)
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
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      * Internal book code data structure.
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

     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
     C                   Eval      @Type  = *Blanks
     C                   Eval      BBCSID = *Blanks

     C                   Eval      GenOkFlag = 'Y'

      * Prohibited for Ro.
     C                   If        PSINST <> *Blanks  AND
     C                             PPTYP  =  'RO'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0288'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif

      *  Mandatory for Ri.  Prohibited for Ro.
     C                   If        PSINST = *Blanks  AND
     C                             PPTYP = 'RI'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0372'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Return
     C                   Endif

      *  The entry should be a S.W.I.F.T. BIC or a customer number or
      *  shortname that refers to a customer for whom a BIC has been defined

     C                   If        PPTYP = 'RI'
     C**********         CallB     'AOBICDV0'                                                 221760
     C                   CallB     'AOBICDV01'                                                221760
     C                   Parm                    RetCodeIn
     C                   Parm                    PSINST
     C                   Parm                    @Type             7
     C                   Parm                    D@FMT

     C                   If        @Type = '*BIC   '
     C                   Return
     C                   Endif

     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    PSINST
     C                   Parm      *Blanks       @KYST             7
     C     SDCUST        Parm      SDCUST        D@FMT

     C                   If        BBCSID = *Blanks OR
     C                             @Type =  '*NRF   ' OR                                      226083
     C                             RetCodeIn  = '*NOBIC ' OR                                  226083
     C                             @RTCD <> *Blanks
     C                   Eval      GenOkFlag = 'N'
     C                   Add       1             Idx
     C                   Movel     DDSName       FldNamXAr(Idx)
     C                   Movel     'RFV0187'     MsgIdXAr(Idx)
     C                   Endif
     C                   Endif

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
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1

      *  Screen fields
     C                   Parm                    HdrRcdIn

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10

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
