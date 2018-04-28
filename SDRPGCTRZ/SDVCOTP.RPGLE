     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Validate Corresp.Type')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVCOTP - SD Additional Customer Validate Correspondent Type *
      *                                                               *
      *  Function:  This module validates the Correspondent Type      *
      *             on the new Details screen                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER034  *CREATE    Date 06Aug08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER034 - German Features - New Fields and Enquiries          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVCOTP - Validate Correspondent Type                        *
      *  *INZSR  - Program Initialisation Routine                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas CG Correspondent Type Retrieval index file
     FCGCTYPL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields
      ** in the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      *
     D/COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for SD Midas modules
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0
      *
      ** Correspondent Type
      *
     D DDCTYP          S             10A
      *
      ** OK Flag for Correspondent Type
      *
     D OKCTYP          S              1A
     D CCG001          S              1A
      *
      ** Parameters
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      Idx = *ZEROS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
      ** Correspondent Type Validation
      *
     C                   EXSR      SRVCOTP
      *
     C                   IF        OKCTYP = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
      ** Return from program
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCOTP - Validate Correspondent Type                        *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRVCOTP       BEGSR
      *
      ** If User Defined Correspondence is OFF or Add Correspondent
      ** when Customer Details Added feature is OFF, Correspondent
      ** Type cannot be entered
      *
     C                   IF        (BGN1ST <> 'Y' OR CCG001 <> 'Y') AND
     C                             (DDCTYP <> *BLANKS)
      *
     C                   EVAL      OKCTYP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCTYP'
     C                   EVAL      MsgIdXAr (Idx) = 'USR5957'
      *
     C                   ENDIF
      *
      ** If the features are ON
      *
     C                   IF        BGN1ST = 'Y' AND CCG001 = 'Y'
      *
      ** Default if Blanks
      *
     C                   IF        DDCTYP = *BLANKS
     C                   EVAL      DDCTYP = 'DEFAULT'
     C                   ENDIF
      *
      ** Check if the Correspondent Type Entered is Valid
      *
     C     DDCTYP        CHAIN     CGCTYPL1
     C                   IF        NOT %FOUND
      *
     C                   EVAL      OKCTYP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCTYP'
     C                   EVAL      MsgIdXAr (Idx) = 'USR5958'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Correspondent Type
      *
     C                   PARM                    DDCTYP
      *
      ** Outputs
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Ok Flag for Correspondent Type
      *
     C                   PARM                    OKCTYP
      *
      ** Check if User Defined Correspondence is switched on
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR'      PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Check if Add Correspondent when Customer Details Added
      ** feature is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCG001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CCG001 = 'Y'
     C                   ELSE
      *
     C                   EVAL      CCG001 = 'N'
     C                   ENDIF
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
