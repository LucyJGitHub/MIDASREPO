     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Postal Address details')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVPADDR - Validate Postal Address details
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

      *
      ** Validation
      *
     C                   EXSR      VPADDR
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        DDCNAMOK = 'N'
     C                             OR DDTWNNOK = 'N'
     C                             OR DDCTRYOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   EVAL      XCCNAM = DDCNAM
     C                   EVAL      XCDEPT = DDDEPT
     C                   EVAL      XCSDEP = DDSDEP
     C                   EVAL      XCSTRE = DDSTRE
     C                   EVAL      XCBUIU = DDBUIU
     C                   EVAL      XCBUIA = DDBUIA
     C                   EVAL      XCFLOR = DDFLOR
     C                   EVAL      XCPOSB = DDPOSB
     C                   EVAL      XCROOM = DDROOM
     C                   EVAL      XCPOSC = DDPOSC
     C                   EVAL      XCTWNN = DDTWNN
     C                   EVAL      XCTWNL = DDTWNL
     C                   EVAL      XCDISN = DDDISN
     C                   EVAL      XCCTRS = DDCTRS
     C                   EVAL      XCCTRY = DDCONT
     C                   ENDIF

      ** RETURN

     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Validate Postal Address
      *****************************************************************
     C     VPADDR        BEGSR

      ** Name is mandatory if any Postal Address element is entered.
     C                   IF        DDCNAM = *BLANKS AND
     C                             (DDDEPT <> *BLANKS OR
     C                             DDSDEP <> *BLANKS OR
     C                             DDSTRE <> *BLANKS OR
     C                             DDBUIU <> *BLANKS OR
     C                             DDBUIA <> *BLANKS OR
     C                             DDFLOR <> *BLANKS OR
     C                             DDPOSB <> *BLANKS OR
     C                             DDROOM <> *BLANKS OR
     C                             DDPOSC <> *BLANKS OR
     C                             DDTWNN <> *BLANKS OR
     C                             DDTWNL <> *BLANKS OR
     C                             DDDISN <> *BLANKS OR
     C                             DDCTRS <> *BLANKS OR
     C                             DDCONT <> *BLANKS)
     C                   MOVE      'N'           DDCNAMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNAM'      FldNamXAr(Idx)
     C                   MOVEL     'USS9850'     MsgIdXAr(Idx)
     C                   ENDIF

      ** TownName must be provided if any of the subfields in the Postal Address is provided.
     C                   IF        DDTWNN = *BLANKS AND
     C                             (DDDEPT <> *BLANKS OR
     C                             DDSDEP <> *BLANKS OR
     C                             DDSTRE <> *BLANKS OR
     C                             DDBUIU <> *BLANKS OR
     C                             DDBUIA <> *BLANKS OR
     C                             DDFLOR <> *BLANKS OR
     C                             DDPOSB <> *BLANKS OR
     C                             DDROOM <> *BLANKS OR
     C                             DDPOSC <> *BLANKS OR
     C                             DDTWNL <> *BLANKS OR
     C                             DDDISN <> *BLANKS OR
     C                             DDCTRS <> *BLANKS OR
     C                             DDCONT <> *BLANKS)
     C                   MOVE      'N'           DDTWNNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTWNN'      FldNamXAr(Idx)
     C                   MOVEL     'USS9851'     MsgIdXAr(Idx)
     C                   ENDIF

      ** Country must be provided if any of the subfields in the Postal Address is provided.
     C                   IF        DDCONT = *BLANKS AND
     C                             (DDDEPT <> *BLANKS OR
     C                             DDSDEP <> *BLANKS OR
     C                             DDSTRE <> *BLANKS OR
     C                             DDBUIU <> *BLANKS OR
     C                             DDBUIA <> *BLANKS OR
     C                             DDFLOR <> *BLANKS OR
     C                             DDPOSB <> *BLANKS OR
     C                             DDROOM <> *BLANKS OR
     C                             DDPOSC <> *BLANKS OR
     C                             DDTWNL <> *BLANKS OR
     C                             DDDISN <> *BLANKS OR
     C                             DDCTRS <> *BLANKS OR
     C                             DDTWNN <> *BLANKS)
     C                   MOVE      'N'           DDCTRYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCONT'      FldNamXAr(Idx)
     C                   MOVEL     'USS9852'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        DDCONT <> *Blanks

     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DDCONT        PKEY1
     C     SDCTRY        PARM      SDCTRY        DSSDY

     C                   IF        PRTCD <> *Blanks
     C                   MOVE      'N'           DDCTRYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCONT'      FldNamXAr(Idx)
     C                   MOVEL     'USS9852'     MsgIdXAr(Idx)
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
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Name and Postal Address
     C                   PARM                    DDCNAM          140
     C                   PARM                    DDDEPT           70
     C                   PARM                    DDSDEP           70
     C                   PARM                    DDSTRE           70
     C                   PARM                    DDBUIU           16
     C                   PARM                    DDBUIA           35
     C                   PARM                    DDFLOR           70
     C                   PARM                    DDPOSB           16
     C                   PARM                    DDROOM           70
     C                   PARM                    DDPOSC           16
     C                   PARM                    DDTWNN           35
     C                   PARM                    DDTWNL           35
     C                   PARM                    DDDISN           35
     C                   PARM                    DDCTRS           35
     C                   PARM                    DDCONT            2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Creation Date - OK
     C                   PARM                    DDCNAMOK          1
     C                   PARM                    DDTWNNOK          1
     C                   PARM                    DDCTRYOK          1
      *
     C                   PARM                    XCCNAM          140
     C                   PARM                    XCDEPT           70
     C                   PARM                    XCSDEP           70
     C                   PARM                    XCSTRE           70
     C                   PARM                    XCBUIU           16
     C                   PARM                    XCBUIA           35
     C                   PARM                    XCFLOR           70
     C                   PARM                    XCPOSB           16
     C                   PARM                    XCROOM           70
     C                   PARM                    XCPOSC           16
     C                   PARM                    XCTWNN           35
     C                   PARM                    XCTWNL           35
     C                   PARM                    XCDISN           35
     C                   PARM                    XCCTRS           35
     C                   PARM                    XCCTRY            2
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
