     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Specific Formatting of Add. Information')        *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MGUF86SP - Midas Specific Formatting of Add. Information     *
      *                                                               *
      *  Function:  This program formats additional information for   *
      *             Network using MultiCash Formatting                *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EML104  *CREATE    Date 04Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade of EML010 to FBM2.1 SP23                    *
      *           EML010 - Structured field :86:                      *
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
      *
      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Manually included D-specs
      ** =========================
      *
      ** Named constants
      ** ---------------
      *
      ** Arrays and Data Structures
      ** --------------------------
      *
      ** Extended Narratives
     D  ArExtNarr      S             35A   DIM(16)
      *
      ** Additional Information
     D  ArAddInfo      S             65A   DIM(6)
      *
      ** Array used to remove double blanks
     D  ArInput        S              1A   DIM(35)
      *
      ** Array used to remove double blanks
     D  ArOutput       S              1A   DIM(35)
      *
      ** Declared variables
      ** ------------------
      *
     D IdX             S              5U 0                                      Index X
     D IdY             S              5U 0                                      Index Y
     D IdI             S              5U 0                                      Index Input
     D IDO             S              5U 0                                      Index Output
     D Start           S              5U 0                                      Start position
     D MaxLength       S              5U 0                                      Maximum Length
     D FirstBlank      S              1A
     D Output          S             35A
     D LongString      S            325A
      *
      ** Input Specs
      ** -----------
      *
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode                     Return Code
     C                   PARM                    ArExtNarr                      Extended Narrative
     C                   PARM                    ArAddInfo                      Additional Inform.
      *
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
      *
      ** Init processing uses the standard *INZSR subroutine
      *
     C                   EVAL      ReturnCode = *BLANKS
     C                   EVAL      IdY        = *Zeros
     C                   EVAL      LongString = *Blanks
     C                   CLEAR                   ArAddInfo
     C                   EVAL      Start      = 1
     C                   EVAL      MaxLength  = %LEN(LongString)
      *
      ** Retrieve extended Narratives
      *
     C                   DO        16            IdX
      *
     C                   IF        ArExtNarr(IdX) <> *Blanks
      *
      ** Remove double blanks in extended narratives
      *
     C                   MOVEA     ArExtNarr(IdX)ArInput
     C                   EXSR      Rmv2Blnks
     C                   MOVEA     ArOutput      Output
      *
      ** The first extended narrative has to be loaded like it is.
      ** The next extended narratives have to be concatenated before loading.
      *
     C                   IF        IdY = *Zeros
     C                   ADD       1             IdY
     C                   EVAL      ArAddInfo(IdY) = Output
     C                   ITER
     C                   ENDIF
      *
      ** Load fields into a Long String with a blank between each field
      ** Thus, at least a blank every 35 characters.
      *
     C                   EVAL      %SUBST(LongString:Start) =
     C                             %TRIM(Output)
      *
      ** Calculate next start position
      *
     C                   EVAL      Start = Start +
     C                             %LEN(%TRIM(Output)) + 1                      Length Ext. Narr.
      *
      ** If Additional Information are filled, leave the loading.
      *
     C                   IF        Start > MaxLength
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ADD       1             IdY
     C                   MOVEA     LongString    ArAddInfo(IdY)
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *========================================================================*
      * Rmv2Blnks : Remove double blanks                                       *
      *------------------------------------------------------------------------*
      *
     C     Rmv2Blnks     BEGSR
      *    ---------     -----
      *
      ** Initiat working fields
      *
     C                   CLEAR                   ArOutput
     C                   Z-ADD     0             IdO
     C                   MOVE      *Blank        FirstBlank
      *
      ** Loop on all elements of the array Input
      *
     C     1             DO        35            IdI
      *
      ** If the element is not blank, load it in array Output
      *
     C                   IF        ArInput(IdI) <> *Blank
     C                   ADD       1             IdO
     C                   MOVE      ArInput(IdI)  ArOutput(IdO)
     C                   MOVE      *Blank        FirstBlank
     C                   ELSE
      *
      ** If the element is blank, consider only one blank.
      *
     C                   IF        FirstBlank <> 'Y'
     C                   ADD       1             IdO
     C                   MOVE      'Y'           FirstBlank
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      *    ----------    -----
     C     @Rmv2Blnks    ENDSR
      *
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*
      *
     C     *INZSR        BEGSR
      *    ------        -----
      *
      *    ------        -----
     C     @INZSR        ENDSR
      *
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
      *
     C     *PSSR         BEGSR
      *    -----         ------
      *
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      ReturnCode = 'PSSR_Error'
     C                   ENDIF
      *
     C                   DUMP
      *
     C                   EVAL      *INLR = *On
      *
     C                   RETURN
      *
      *    ----------    ------
     C     @PSSR         ENDSR
      *
      *========================================================================*
**CTDATA CPY@
(C) Finastra International Limited 2020
