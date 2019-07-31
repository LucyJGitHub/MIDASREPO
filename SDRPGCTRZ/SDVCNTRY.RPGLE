     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Country Code')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCNTRY - Validate Expiry Date                              *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVctcd - Subroutine to validate Country Code                *
      *  *INZSR - Program Initialisation routine                      *
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
      **
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
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
     D SDCTRY        E DS                  Extname(SDCTRYPD)
      *
     D DSSDY         E DS                  Extname(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for *Entry
     D DDCTCD          S              2A
     D OKCTCD          S              1A
     D PRtcd           S              7A
     D PCtryCd         S              2A
     D POptn           S              7A
     D PFldNm          S             10A
      *
     D Idx             S              3P 0
      *
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
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      PRtcd = *BLANKS
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = *ZERO
      *
      ** Validation
      *
     C                   EXSR      SRVctcd
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCTCD = 'N'
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
      * SRVctcd - Subroutine to validate Country Code                 *
      *                                                               *
      * Called By - Main Processing                                   *
      *                                                               *
      * Calls - None                                                  *
      *****************************************************************
      *
     C     SRVctcd       BEGSR
      *
     C                   IF        DDCTCD <> *BLANKS
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      '*BLANKS'     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCTCD        PCtryCd
     C     SDCTRY        PARM      SDCTRY        DSSDY
      *
     C                   IF        PRtcd = '*NOSEL '
      *
     C                   EVAL      DDCTCD = *BLANKS
      *
     C                   ELSEIF    PRtcd = *BLANKS
      *
     C                   EVAL      DDCTCD = A4CNCD
      *
     C                   ELSE
      *
     C                   EVAL      OKCTCD = 'N'
     C                   EVAL      Idx = Idx + 1
      *
     C                   EVAL      FldNamXAr(Idx) = PFldNm
     C                   IF        PFldNm = 'DDCTYC'
     C                   EVAL      MsgIdXAr(Idx) = 'USR8085'
      *
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = 'USR8086'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By - None                                              *
      *                                                               *
      * Calls - Main Processing                                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
     C                   PARM                    RetCodeOut
     C                   PARM                    DDCTCD
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    PFldNm
     C                   PARM                    OKCTCD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2008
