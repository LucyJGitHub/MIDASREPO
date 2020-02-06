     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validation Function Module')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLNVAL - GL Collateral Narrative Validation Function      *
      *              Module                                           *
      *                                                               *
      *  Function:  This API module will serve as the validation mo   *
      *             dule of the complete API program and will be made *
      *             switchable under enhancement number CGL011.       *
      *                                                               *
      *  Called By: GLCOLNSIN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL011 - Collateral Processing for Midas.                    *
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the standard program name,proce-
      ** dures etc.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Collateral Narrative File Format
     D ValidTran     E DS                  EXTNAME(GLCOLNPD)
 
      ** Collateral Narrative Screen Format(Current)
     D TranIn        E DS                  EXTNAME(GLSCLNPD)
 
      ** Collateral Narrative Screen Error Format
     D OKFlags       E DS                  EXTNAME(GLECLNPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
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
 
      ** Set up ValidTran DS
 
     C                   Eval      CNCREF = PColRef
     C                   Eval      CNFRNT = *Blank
     C                   Eval      CNREPA = *Blank
     C                   Eval      CNTMST = *Blank
     C                   Eval      CNNRRN = NDSRRN
     C                   Eval      CNNARR = NDNARR
     C                   Eval      CNCHTP = NDACTN
     C                   Eval      CNLCD = BJRDNB
 
     C                   Return
 
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    RespMode          1
     C                   Parm                    TranIn
     C                   Parm                    OKFlags
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WmsgIdArr
     C                   Parm                    WmsgDtaArr
     C                   Parm                    Widx
     C                   Parm                    ValidTran
     C                   Parm                    PColRef          10
 
      ** Initialise Program name
 
     C                   Eval      DbPgm = 'GLCOLNVAL'
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   MoveL     'SDBANKPD'    DbFile                         ************
     C                   Z-Add     001           Dbase                          * DBERR 01 *
     C                   MoveL     @Optn         DbKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   EndSr
 
      ****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
