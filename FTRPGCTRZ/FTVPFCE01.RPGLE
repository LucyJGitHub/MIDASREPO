     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate profit centre')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVPFCE01 -Validate Profit Centre.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 221761             Date 01Apr04               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 09Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer inclusion of MT101 messages          *
      *           messages                                            *
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
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      * External DS for Midas modules details
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas Profit Centre details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
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
     D GenOkFlag       S              1    Import
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
     C                   Eval      WIdx       = 0
 
     C                   Eval      GenOkFlag = 'Y'
 
      *
     C                   Select
      * If Profit Centres Used flag from SDGELRPD = 'Y', entry into this
      *  field is allowed, else not allowed.
     C                   When      BKPRCU ='N' and
     C                             PPRFC <> *Blanks
     C                   Eval      PPRFC = *Blanks
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0021'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
 
      * If entered, must be a valid record on SDPRFCL1
     C                   When      BKPRCU ='Y' and
     C                             PPRFC <> *Blanks
 
     C                   CALLB     'AOPRFCR0'                           90
     C                   Parm      *BLANKS       P@RTCD            7
     C                   Parm      '*KEY'        P@OPTN            7
     C                   Parm      PPRFC         P@PRFC            4
     C     SDPRFC        Parm      SDPRFC        DSFDY
 
      * Monitor return code(s)
     C                   Select
     C                   When      P@RTCD = '*NRF   '
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0022'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
 
     C                   When      *In90 = *On
     C                   Exsr      *PSSR
     C                   Endsl
 
      * If profit centre is not entered and BKPRCU = 'Y', default
      * to the profit centre matrix
     C                   When      BKPRCU ='Y' and
     C                             PPRFC = *Blanks
 
      *
     C                   CALLB     'AOPRFMR0'
     C                   Parm      *Blanks       RTCD1             1
     C                   Parm      *Blanks       P@BOKC            2
     C                   Parm      *Blanks       P#TRTP            5
     C                   Parm      *Blanks       P#SUTP            2
     C                   Parm      PBRCA         P#BRCA            3
     C                   Parm      *Blanks       P#DEPT            3
     C                   Parm      *Blanks       P#USER           10
     C                   Parm      *Blanks       P#ACOF            2
     C                   Parm      *Blanks       P#CUST            6
     C     PPRFC         Parm      *Blanks       P#PRFC            4
 
      * If the action code = 'A', determine whether amendment to this
      *  field is allowed.  Retrieve the General Ledger ICD file SDGELRL1
      *  field BKPRCA (Profit Centres Amendable).  If this is set to 'N',
      *  this field is prohibited.
     C                   When      ActionCode = 'A' and
     C                             BKPRCA     = 'N' and
     C                             PPRFC      <> *BLANKS
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0023'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
 
 
     C                   Endsl
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
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
 
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C                   If        @RTCD <> *Blanks
     C                   Eval      DBFILE = 'SDGELRPD'
     C                   Eval      DBASE  = 1
     C                   Eval      DBKEY  = @OPTN
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
