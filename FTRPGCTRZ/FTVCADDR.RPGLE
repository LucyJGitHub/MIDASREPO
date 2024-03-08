     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Credit Postal Details')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVCADDR - Validate Credit Postal Details                    *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. CSW123  *CREATE    Date 08Jan24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW123 - SWIFT ISO 20022 - Phase 2 (Structured Addresses)    *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInISO     E DS                  EXTNAME(FTOPY11APD)

      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      ** External DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S              2

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

     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   EVAL      OKCNAM = 'Y'
     C                   EVAL      OKCTWN = 'Y'
     C                   EVAL      OKCCTR = 'Y'

      *
      ** Validation
      *
     C                   EXSR      VCADDR
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKCNAM = 'N'
     C                             OR OKCTWN = 'N'
     C                             OR OKCCTR = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

      ** RETURN

     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Validate Creditor Postal Address
      *****************************************************************
     C     VCADDR        BEGSR

      ** Name is mandatory if Beneficiary customer is not a valid midas customer

     C                   IF        SCNAM = *BLANKS AND
     C                             @BNCT = 'A'
     C                   MOVE      'N'           OKCNAM
     C                   Add       1             Idx
     C                   MOVEL     'SCNAM '      FldNamXAr(Idx)
     C                   Movel     'USS9860'     MsgIdXAr(Idx)
     C                   ENDIF

      ** Name is mandatory if any Postal Address element is entered.
     C                   IF        SCNAM = *BLANKS AND
     C                             (SCDEP <> *BLANKS OR
     C                             SCSDE <> *BLANKS OR
     C                             SCSTR <> *BLANKS OR
     C                             SCBUI <> *BLANKS OR
     C                             SCBUA <> *BLANKS OR
     C                             SCFLO <> *BLANKS OR
     C                             SCPOS <> *BLANKS OR
     C                             SCROO <> *BLANKS OR
     C                             SCPOC <> *BLANKS OR
     C                             SCTWN <> *BLANKS OR
     C                             SCTWL <> *BLANKS OR
     C                             SCDIS <> *BLANKS OR
     C                             SCCTR <> *BLANKS OR
     C                             SCCTY <> *BLANKS)
     C                   MOVE      'N'           OKCNAM
     C                   Add       1             Idx
     C                   MOVEL     'SCNAM '      FldNamXAr(Idx)
     C                   Movel     'USS9856'     MsgIdXAr(Idx)
     C                   ENDIF

      ** TownName must be provided if any of the subfields in the Postal Address is provided.
     C                   IF        SCTWN = *BLANKS AND
     C                             (SCDEP <> *BLANKS OR
     C                             SCSDE <> *BLANKS OR
     C                             SCSTR <> *BLANKS OR
     C                             SCBUI <> *BLANKS OR
     C                             SCBUA <> *BLANKS OR
     C                             SCFLO <> *BLANKS OR
     C                             SCPOS <> *BLANKS OR
     C                             SCROO <> *BLANKS OR
     C                             SCPOS <> *BLANKS OR
     C                             SCTWL <> *BLANKS OR
     C                             SCDIS <> *BLANKS OR
     C                             SCCTR <> *BLANKS OR
     C                             SCCTY <> *BLANKS)
     C                   MOVE      'N'           OKCTWN
     C                   Add       1             Idx
     C                   MOVEL     'SCTWN '      FldNamXAr(Idx)
     C                   Movel     'USS9857'     MsgIdXAr(Idx)
     C                   ENDIF

      ** Country must be provided if any of the subfields in the Postal Address is provided.
     C                   IF        SCCTY = *BLANKS AND
     C                             (SCDEP <> *BLANKS OR
     C                             SCSDE <> *BLANKS OR
     C                             SCSTR <> *BLANKS OR
     C                             SCBUI <> *BLANKS OR
     C                             SCBUA <> *BLANKS OR
     C                             SCFLO <> *BLANKS OR
     C                             SCPOS <> *BLANKS OR
     C                             SCROO <> *BLANKS OR
     C                             SCPOC <> *BLANKS OR
     C                             SCTWL <> *BLANKS OR
     C                             SCDIS <> *BLANKS OR
     C                             SCCTR <> *BLANKS OR
     C                             SCTWN <> *BLANKS)
     C                   MOVE      'N'           OKCCTR
     C                   Add       1             Idx
     C                   MOVEL     'SCCTY '      FldNamXAr(Idx)
     C                   Movel     'USS9858'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        SCCTY <> *Blanks

     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      SCCTY         PKEY1
     C     SDCTRY        PARM      SDCTRY        DSSDY

     C                   IF        PRTCD <> *Blanks
     C                   MOVE      'N'           OKCCTR
     C                   Add       1             Idx
     C                   MOVEL     'SCCTY '      FldNamXAr(Idx)
     C                   Movel     'USS9858'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn

      *  Screen fields
     C                   Parm                    TranInSecB
     C                   Parm                    TranInISO

      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2024
