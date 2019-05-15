     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas BoE Cust. Detls. validation for BOE Extract')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  BYCUSD2VL  - Additional validation of main customer details  *
      *               for the Bank of England extract                 *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2002            *
      *                                                               *
      *  Last Amend No. MD049990           Date 07Mar18               *
      *  Prev Amend No. MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022             Date 24Jan05               *
      *                 203458  *CREATE    Date 06May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD049990 - Incorrect mapping of Institution Code and Industry*
      *             Code in main customer details                     *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  203458 - Apply BOE validation rules to main customer details *
      *                                                               *
      *****************************************************************
      *
     FBYINSTV0  IF   E           K DISK
      **  BOE Institution Codes
      *
     FBYINDRV0  IF   E           K DISK
      **  BOE Industry Codes
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,STDDECLARE
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,ERR_XARRYS
     D Idx             S              3P 0
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for Country Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs, Short data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs, Long data structure.
      *
      *
     D BYSTAT        E DS                  EXTNAME(BYSTATPP)  DTAARA(BYSTAT)
      **  Layout of external data area BYSTAT
      *
      *
      /EJECT
      *
     C
      *  Main Processing                                               ---+
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      ** Validaton
     C                   EXSR      Sr_Valid
      *
      ** If an error found set the return code appropriately
     C     DDLICDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
     C                   RETURN
      /EJECT
      *****************************************************************
      ** Sr_Valid - Validation Rules
      *****************************************************************
     C     Sr_Valid      BEGSR
      *
      ** Validate Institution code according to ICD flag
     C     LDICD         Ifeq      'Y'
      *
      ** Local institution code must be valid code on BYINSTV0
     C                   IF        DDLINC <> *BLANK
     C                   Move      DDLINC        ULLINC            2 0
     C     ULLINC        Chain     BYINSTV0                           90
     C     *In90         Ifeq      *on
     C                   Move      'N'           DDLINCOK
     C                   Add       1             Idx
     C**********         Movel     'DDLINC'      FldNamXAr(Idx)                             MD044880
     C**********         MOVEL     'LLINC'       FldNamXAr(Idx)                    MD044880 MD049990
     C                   MOVEL     'DDLINC'      FldNamXAr(Idx)                             MD049990
     C**********         Movel     'BYM0069'     MsgIdXAr(Idx)                                LLN022
     C**********         Movel     'BYM0302'     MsgIdXAr(Idx)                       LLN022 MD044880
     C                   MOVEL     '5049088'     MsgIdXAr(Idx)                              MD044880
     C                   ENDIF
     C                   ELSE                                                                 LLN022
     C                   Move      'N'           DDLINCOK                                     LLN022
     C                   Add       1             Idx                                          LLN022
     C**********         Movel     'DDLINC'      FldNamXAr(Idx)                      LLN022 MD044880
     C**********         Movel     'BYM0069'     MsgIdXAr(Idx)                       LLN022 MD044880
     C**********         Movel     'LLINC'       FldNamXAr(Idx)                    MD044880 MD049990
     C                   MOVEL     'DDLINC'      FldNamXAr(Idx)                             MD049990
     C                   MOVEL     '5049078'     MsgIdXAr(Idx)                              MD044880
     C                   ENDIF                                                                LLN022
      *
      ** If customer is UK Res. then Institution code must be UK Res.
     C*****A4ISOC        Ifeq      'GB'                                                       LLN022
     C     DDCOLC        Ifeq      'GB'                                                       LLN022
     C     LAUKRI        andne     'Y'
     C                   Move      'N'           DDLINCOK
     C                   Add       1             Idx
     C**********         Movel     'DDLINC'      FldNamXAr(Idx)                             MD044880
     C**********         Movel     'BYM0070'     MsgIdXAr(Idx)                              MD044880
     C**********         MOVEL     'LLINC'       FldNamXAr(Idx)                    MD044880 MD049990
     C                   MOVEL     'DDLINC'      FldNamXAr(Idx)                             MD049990
     C                   MOVEL     '5049079'     MsgIdXAr(Idx)                              MD044880
     C                   Endif
      *
      ** If customer is not UK Res. then Inst. code must not be UK Res.
     C*****A4ISOC        Ifne      'GB'                                                       LLN022
     C     DDCOLC        Ifne      'GB'                                                       LLN022
     C     LAUKRI        andeq     'Y'
     C                   Move      'N'           DDLINCOK
     C                   Add       1             Idx
     C**********         Movel     'DDLINC'      FldNamXAr(Idx)                             MD044880
     C**********         Movel     'BYM0071'     MsgIdXAr(Idx)                              MD044880
     C**********         MOVEL     'LLINC'       FldNamXAr(Idx)                    MD044880 MD049990
     C                   MOVEL     'DDLINC'      FldNamXAr(Idx)                             MD049990
     C                   MOVEL     '5049080'     MsgIdXAr(Idx)                              MD044880
     C                   Endif
      *
     C                   Endif
      *
      *
      ** Validate Industry code according to ICD flag
     C     LDINC         Ifeq      'Y'
      *
      **  Industry code must be entered if institution code is for
      **  UK non-monetary sector
     C     DDLINCOK      Ifne      'N'
     C     LAUKMI        andeq     'N'
     C     LAUKRI        andeq     'Y'
     C     DDLICD        andeq     *Blanks
     C                   Move      'N'           DDLICDOK
     C                   Add       1             Idx
     C**********         Movel     'DDLICD'      FldNamXAr(Idx)                             MD044880
     C**********         Movel     'BYM0072'     MsgIdXAr(Idx)                              MD044880
     C**********         MOVEL     'LLICD'       FldNamXAr(Idx)                    MD044880 MD049990
     C                   MOVEL     'DDLICD'      FldNamXAr(Idx)                             MD044880
     C                   MOVEL     '5049081'     MsgIdXAr(Idx)                              MD044880
     C                   Endif
      *
      **  Must be valid code if entered
     C     DDLICD        Ifne      *Blanks
     C     DDLICD        Chain     BYINDRV0                           90
     C     *In90         Ifeq      *on
     C                   Move      'N'           DDLICDOK
     C                   Add       1             Idx
     C**********         Movel     'DDLICD'      FldNamXAr(Idx)                             MD044880
     C**********         Movel     'BYM0073'     MsgIdXAr(Idx)                              MD044880
     C**********         MOVEL     'LLICD'       FldNamXAr(Idx)                    MD044880 MD049990
     C                   MOVEL     'DDLICD'      FldNamXAr(Idx)                             MD049990
     C                   MOVEL     '5049082'     MsgIdXAr(Idx)                              MD044880
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS:
     C                   PARM                    RetCodeOut
     C                   PARM                    DDLINC            2
     C                   PARM                    DDLICD            3
     C                   PARM                    DDCOLC            2
      *
      * OUTPUTS:
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDLICDOK          1
     C                   PARM                    DDLINCOK          1
      *
      ** Get ISO code for country of location
     C                   Call      'AOCTRYR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DDCOLC        @CNCD             2
     C     SDCTRY        Parm      *Blanks       DSSDY
      *
      *
      ** Check if Bank of England extract is switched on
     C                   Call      'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'LLN007'      @SARD
      *
      ** Set switchable feature indicator
     C     @RTCD         Ifeq      *BLANK
     C                   Movel     'Y'           LLN007            1
     C                   Else
     C                   Movel     'N'           LLN007
     C                   Endif
      *
      ** Do not process if feature is not on
     C     LLN007        Ifne      'Y'
     C                   Return
     C                   Endif
      *
      ** Read in ICD default flags from external data area
     C                   In        BYSTAT
     C                   Unlock    BYSTAT
      *
      ** Do not process if no defaulting requried
     C     LDICD         Ifne      'Y'
     C     LDINC         andne     'Y'
     C                   Return
     C                   Endif
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      * *PSSR - Error Routine                                             *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        RunBefore <> 'Y'
     C                   EVAL      RunBefore = 'Y'
     C     *lock         IN        APDUMP                               99      CAP006
     C                   IF        *in99                                        CAP006
     C                   CLEAR                   PSSRRetCde                     CAP006
     C                   CALL      'APCCRTQTO'                                  CAP006
     C                   PARM                    PSSRRetCde       10            CAP006
     C     *lock         IN        APDUMP                                       CAP006
     C                   ENDIF                                                  CAP006
     C                   EVAL      ARErrMod = PSProcMod
     C                   OUT       APDUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *inu7 = *on
     C                   EVAL      *inu8 = *on
     C                   EVAL      *inlr = *on
     C                   RETURN
      *
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2002
