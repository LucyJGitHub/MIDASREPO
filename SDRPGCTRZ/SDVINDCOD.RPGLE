     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Local Industry Code')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVIndCod - Validate Local Industry Code                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048             Date 19May08               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVindc - Subroutine to validate Local Industry Code         *
      *  *INZSR - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      * Midas SD Local Industry Codes
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDPV001
      *
      *****************************************************************
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
      ** in the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
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
     D SDINDS        E DS                  Extname(SDINDSPD)
      *
     D DSSDY         E DS                  Extname(DSSDY)
      *                                                                                       CER048
      ** First DS for access programs, short data structure                                   CER048
      *                                                                                       CER048
     D DSFDY         E DS                  Extname(DSFDY)                                     CER048
      *                                                                                       CER048
      ** External DS for SAR details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  Extname(SCSARDPD)                                  CER048
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for *Entry
      *
     D DDINDC          S              3A
      *
     D PJobType        S              1A
      *
     D OKINDC          S              1A
      *
     D PRtcd           S              7A
      *
     D POptn           S              7A
      *
     D PIndCd          S              3A
      *
     D Idx             S              3P 0
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
      *                                                                                       CER048
     D PSard           S              6A                                                      CER048
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   CLEAR                   RetCodeIn
     C                   EVAL      PRtcd = *BLANKS
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZERO
      *
      ** Validation
      *
     C                   EXSR      SRVindc
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKINDC = 'N'
      *
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVindc - Subroutine to validate Local Industry Code          *
      *                                                               *
      * Called By - Main Processing                                   *
      *                                                               *
      * Calls - None                                                  *
      *****************************************************************
      *
     C     SRVindc       BEGSR
      *
     C                   IF        DDINDC <> *BlANKS
      *
     C                   CALL      'AOINDSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDINDC        PIndCd
     C     SDINDS        PARM      SDINDS        DSSDY
      *
     C                   IF        PRtcd = '*NOSEL '
      *
     C                   EVAL      DDINDC = *BLANKS
      *
     C                   ELSEIF    PRtcd = *BLANKS
      *
     C                   EVAL      DDINDC = AOLICD
      *
     C                   ELSE
      *
     C                   EVAL      OKINDC = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDINDC'
     C                   EVAL      MsgIdXAr(Idx) = 'USR8082'
      *
     C                   ENDIF
      *
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      OKINDC = 'N'                                               CER048
     C                   EVAL      Idx = Idx + 1                                              CER048
     C                   EVAL      FldNamXAr(Idx) = 'DDINDC'                                  CER048
     C                   EVAL      MsgIdXAr(Idx)  = 'USR8265'                                 CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
     C                   PARM                    RetCodeOut
     C                   PARM                    DDINDC
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKINDC
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        ((PRtcd <> *BLANKS) AND                                    CER048
     C                             (PRtcd <> '*NRF   '))                                      CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBase =  902                                               CER048
     C                   EVAL      DBkey =  'CER048'                                          CER048
     C                   EVAL      DBfile = 'SCSARDPD'                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error                               CER048
      ** processing.                                                                          CER048
      ** ==============================================================                       CER048
      ** The following /COPY sets these values, and also defines LDA as                       CER048
      ** an external data area                                                                CER048
      *****************************************************************                       CER048
      /COPY ZACPYSRC,PSSR_ILE                                                                 CER048
      *****************************************************************                       CER048
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
