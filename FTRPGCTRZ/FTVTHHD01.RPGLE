     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate threshold level MT102-Header')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTHHD01  - Validate User Threshold Level Header            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      *                 BUG13852           Date 07May07               *
      *                 BUG13723           Date 25Apr07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 TDA035             Date 02Apr04               *
      *                 CAP084             Date 25Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 18Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  BUG13852 - Validation error with Authorising limits          *
      *  BUG13723 - Serious Midas Plus Error occurred upon            *
      *             clicking Authorise Input                          *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
      *                                                               *
      *****************************************************************
      * F -Specs                                                                            BUG13723
     FMUSER     IF   E           K DISK    INFSR(*PSSR)                                     BUG13723
 
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HPD)
 
      * External DS for General Ledger details
     D*SDUSER****    E DS                  EXTNAME(Muser)                                   BUG13723
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     DFirst_Sec        S              1
     D  TransAmt       S                   Like(CCTAMT)
     D  P@USRP         S             10                                                     BUG13723
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      TransAmt   = *Zeros
 
 
      * Can either be first authorising user or second.
     C                   Select
     C                   When      AUP1 <> *Blanks     AND
     C                             AUP2 <> *Blanks
     C                   Return
 
     C                   When      AUP1 = *Blanks
     C                   Eval      First_Sec = 'F'
 
     C                   When      AUP2 = *Blanks
     C                   Eval      First_Sec = 'S'
 
     C                   Endsl
 
      *
      ** Retrieve User Details
      *
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   MOVEL     USER          P@USRP                         CAP084
     C                   ELSE                                                   CAP084
     C                   MOVEL     PSUser        P@USRP                         CAP084
     C                   ENDIF                                                  CAP084
                                                                                CAP084
     C**********         Call      'AOUSERR0'                                               BUG13723
     C**********         Parm      *Blanks       P@RTCD            7                        BUG13723
     C**********         Parm      '*KEY   '     P@OPTN            7                        BUG13723
     C*************      Parm      PSUser        P@USRP           10            CAP084
     C**********         Parm                    P@USRP           10            CAP084      BUG13723
     C*****SDUSER        Parm      SDUSER        DSSDY                                      BUG13723
 
     C**********         Select                                                             BUG13723
      **********                   Error                                                    BUG13723
     C**********         When      P@RTCD <> *Blanks                                        BUG13723
     C**********         Eval      RetCodeIn = '*Error'                                     BUG13723
     C**********         Return                                                             BUG13723
      **********                                                                            BUG13723
      **********                   No limits for user                                       BUG13723
     C**********         When      AUT1       = *Zeros AND                                  BUG13723
     C**********                   AUT2       = *Zeros                                      BUG13723
     C**********         Eval      RetCodeIn  = *Blanks                                     BUG13723
     C**********         Return                                                             BUG13723
      **********                                                                            BUG13723
     C**********         Endsl                                                              BUG13723
      ** Get User-ID Details                                                                BUG13723
     C     USERKEY       KLIST                                                              BUG13723
     C                   KFLD                    P@USRP                                     BUG13723
                                                                                            BUG13723
     C     USERKEY       CHAIN     MUSER                                                    BUG13723
     C                   IF        %FOUND(MUSER) and AUT1 = *Zeros                          BUG13723
     C                             and AUT2 = *Zeros                                        BUG13723
     C                   Eval      RetCodeIn = *Blanks                                      BUG13723
     C                   RETURN                                                             BUG13852
     C                   ELSE                                                               BUG13723
     C                   Eval      RetCodeIn = '*Error'                                     BUG13723
     C                   RETURN                                                             BUG13852
     C                   ENDIF                                                              BUG13723
 
      *
      ** Total transaction detail amounts
      *
     C                   Exsr      Sum_Amount
 
      *
      ** Determine if valid
      *
     C                   Select
 
     C                   When      First_Sec = 'F' AND
     C                             AUT1 < TransAmt  OR
     C                             First_Sec = 'S' AND
     C                             AUT2 < TransAmt
 
     C                   Eval      RetCodeIn  = 'TooSmall'
 
     C                   Endsl
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sum_Amount                                                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Sum_Amount    BEGSR
 
      *
      ** If currency code from SDBANKPD = transaction code, OK.  Else
      **  convert
      *
     C                   Select
     C                   When      BJLCCY = CCTCCY
     C                   Eval      TransAmt = TransAmt + CCTAMT
 
     C                   Other
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    CCTCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Z-Add     CCTAMT        InputAmnt
     C                   Z-Add     A6SPRT        ExchRate
     C                   Movel     A6MDIN        MultDivInd
     C                   Movel     CCTCCY        FrCurrency
     C                   Movel     BJLCCY        ToCurrency
     C                   Z-Add     A6NBDP        FrDecPlace
 
     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    BJLCCY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Z-Add     A6NBDP        ToDecPlace
 
     C                   CallB     'ZCONVZ1'
     C                   Parm                    InputAmnt        15 0
     C                   Parm                    ExchRate         13 8
     C                   Parm                    MultDivInd        1
     C                   Parm                    FrCurrency        3
     C                   Parm                    ToCurrency        3
     C                   Parm                    FrDecPlace        1 0
     C                   Parm                    ToDecPlace        1 0
     C                   Parm      *Zeros        OutputAmnt       15 0
 
     C                   Eval      TransAmt = TransAmt + OutputAmnt
 
     C                   Endsl
 
     C                   ENDSR
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
     C                   PARM                    RetCodeIn
     C                   PARM                    HdrRcdIn
 
      * Get todays run date
     C                   CallB     'AOBANKR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C                   PARM      '*Blanks'     SDBANK
 
     C     @RTCD         Ifne      *Blanks
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBKey = '*VERIFY'
     C                   Eval      Dbase = 1
     C                   Eval      DBMod = 'FTVTHRESH'
     C                   Eval      DBProc = '*Inzsr'
     C                   Exsr      *PSSR
     C                   Endif
 
      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
