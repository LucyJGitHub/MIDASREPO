     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Debit Postal Details')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVDADDR - Validate Debit Postal Details                     *
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

     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D
     D TranInISO     E DS                  EXTNAME(FTOPY11APD)

      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)

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

     D DPORC1          S             35A
     D DPORC2          S             35A
     D DPORC3          S             35A
     D DPORC4          S             35A
     D DPORC5          S             35A
     D DDCNAM          S            140A
     D DDDEPT          S             70A
     D DDSDEP          S             70A
     D DDSTRE          S             70A
     D DDBUIU          S             16A
     D DDBUIA          S             35A
     D DDFLOR          S             70A
     D DDPOSB          S             16A
     D DDROOM          S             70A
     D DDPOSC          S             16A
     D DDTWNN          S             35A
     D DDTWNL          S             35A
     D DDDISN          S             35A
     D DDCTRS          S             35A
     D DDCTRY          S              2A

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
     C                   EVAL      OKDNAM = 'Y'
     C                   EVAL      OKDTWN = 'Y'
     C                   EVAL      OKDCTR = 'Y'

      *
      ** Validation
      *
     C                   EXSR      VDADDR
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKDNAM = 'N'
     C                             OR OKDTWN = 'N'
     C                             OR OKDCTR = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

      ** RETURN

     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Validate Debitor Postal Address
      *****************************************************************
     C     VDADDR        BEGSR

      ** If Debtor postal address is blanks and ordering customer is a valid customer,
      ** Retrieve postal address of the customer

     C                   IF        SDNAM = *BLANKS AND
     C                             SDDEP = *BLANKS AND
     C                             SDSDE = *BLANKS AND
     C                             SDSTR = *BLANKS AND
     C                             SDBUI = *BLANKS AND
     C                             SDBUA = *BLANKS AND
     C                             SDFLO = *BLANKS AND
     C                             SDPOS = *BLANKS AND
     C                             SDROO = *BLANKS AND
     C                             SDPOC = *BLANKS AND
     C                             SDTWN = *BLANKS AND
     C                             SDTWL = *BLANKS AND
     C                             SDDIS = *BLANKS AND
     C                             SDCTR = *BLANKS AND
     C                             SDCTY = *BLANKS AND
     C                             @ORCT = 'C'

     C                   CALL      'FT00001PR'
     C                   PARM      SORC1         DPORC1
     C                   PARM      SORC2         DPORC2
     C                   PARM      SORC3         DPORC3
     C                   PARM      SORC4         DPORC4
     C                   PARM                    DPORC5
     C                   PARM      *BLANKS       DDCNAM
     C                   PARM      *BLANKS       DDDEPT
     C                   PARM      *BLANKS       DDSDEP
     C                   PARM      *BLANKS       DDSTRE
     C                   PARM      *BLANKS       DDBUIU
     C                   PARM      *BLANKS       DDBUIA
     C                   PARM      *BLANKS       DDFLOR
     C                   PARM      *BLANKS       DDPOSB
     C                   PARM      *BLANKS       DDROOM
     C                   PARM      *BLANKS       DDPOSC
     C                   PARM      *BLANKS       DDTWNN
     C                   PARM      *BLANKS       DDTWNL
     C                   PARM      *BLANKS       DDDISN
     C                   PARM      *BLANKS       DDCTRS
     C                   PARM      *BLANKS       DDCTRY
     C                   PARM      *BLANKS       PRTCD

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      SDNAM = DDCNAM
     C                   EVAL      SDDEP = DDDEPT
     C                   EVAL      SDSDE = DDSDEP
     C                   EVAL      SDSTR = DDSTRE
     C                   EVAL      SDBUI = DDBUIU
     C                   EVAL      SDBUA = DDBUIA
     C                   EVAL      SDFLO = DDFLOR
     C                   EVAL      SDPOS = DDPOSB
     C                   EVAL      SDROO = DDROOM
     C                   EVAL      SDPOC = DDPOSC
     C                   EVAL      SDTWN = DDTWNN
     C                   EVAL      SDTWL = DDTWNL
     C                   EVAL      SDDIS = DDDISN
     C                   EVAL      SDCTR = DDCTRS
     C                   EVAL      SDCTY = DDCTRY
     C                   ENDIF

     C                   ENDIF


     C
      ** Name is mandatory if Ordering customer is not a valid midas customer

     C                   IF        SDNAM = *BLANKS AND
     C                             @ORCT = 'A'
     C                   MOVE      'N'           OKDNAM
     C                   Add       1             Idx
     C                   MOVEL     'SDNAM '      FldNamXAr(Idx)
     C                   Movel     'USS9859'     MsgIdXAr(Idx)
     C                   ENDIF

      ** Name is mandatory if any Postal Address element is entered.
     C                   IF        SDNAM = *BLANKS AND
     C                             (SDDEP <> *BLANKS OR
     C                             SDSDE <> *BLANKS OR
     C                             SDSTR <> *BLANKS OR
     C                             SDBUI <> *BLANKS OR
     C                             SDBUA <> *BLANKS OR
     C                             SDFLO <> *BLANKS OR
     C                             SDPOS <> *BLANKS OR
     C                             SDROO <> *BLANKS OR
     C                             SDPOC <> *BLANKS OR
     C                             SDTWN <> *BLANKS OR
     C                             SDTWL <> *BLANKS OR
     C                             SDDIS <> *BLANKS OR
     C                             SDCTR <> *BLANKS OR
     C                             SDCTY <> *BLANKS)
     C                   MOVE      'N'           OKDNAM
     C                   Add       1             Idx
     C                   MOVEL     'SDNAM '      FldNamXAr(Idx)
     C                   Movel     'USS9853'     MsgIdXAr(Idx)
     C                   ENDIF

      ** TownName must be provided if any of the subfields in the Postal Address is provided.
     C                   IF        SDTWN = *BLANKS AND
     C                             (SDDEP <> *BLANKS OR
     C                             SDSDE <> *BLANKS OR
     C                             SDSTR <> *BLANKS OR
     C                             SDBUI <> *BLANKS OR
     C                             SDBUA <> *BLANKS OR
     C                             SDFLO <> *BLANKS OR
     C                             SDPOS <> *BLANKS OR
     C                             SDROO <> *BLANKS OR
     C                             SDPOS <> *BLANKS OR
     C                             SDTWL <> *BLANKS OR
     C                             SDDIS <> *BLANKS OR
     C                             SDCTR <> *BLANKS OR
     C                             SDCTY <> *BLANKS)
     C                   MOVE      'N'           OKDTWN
     C                   Add       1             Idx
     C                   MOVEL     'SDTWN '      FldNamXAr(Idx)
     C                   Movel     'USS9854'     MsgIdXAr(Idx)
     C                   ENDIF

      ** Country must be provided if any of the subfields in the Postal Address is provided.
     C                   IF        SDCTY = *BLANKS AND
     C                             (SDDEP <> *BLANKS OR
     C                             SDSDE <> *BLANKS OR
     C                             SDSTR <> *BLANKS OR
     C                             SDBUI <> *BLANKS OR
     C                             SDBUA <> *BLANKS OR
     C                             SDFLO <> *BLANKS OR
     C                             SDPOS <> *BLANKS OR
     C                             SDROO <> *BLANKS OR
     C                             SDPOC <> *BLANKS OR
     C                             SDTWL <> *BLANKS OR
     C                             SDDIS <> *BLANKS OR
     C                             SDCTR <> *BLANKS OR
     C                             SDTWN <> *BLANKS)
     C                   MOVE      'N'           OKDCTR
     C                   Add       1             Idx
     C                   MOVEL     'SDCTY '      FldNamXAr(Idx)
     C                   Movel     'USS9855'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        SDCTY <> *Blanks

     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      SDCTY         PKEY1
     C     SDCTRY        PARM      SDCTRY        DSSDY

     C                   IF        PRTCD <> *Blanks
     C                   MOVE      'N'           OKDCTR
     C                   Add       1             Idx
     C                   MOVEL     'SDCTY '      FldNamXAr(Idx)
     C                   Movel     'USS9855'     MsgIdXAr(Idx)
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
     C                   Parm                    TranInPrim
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
