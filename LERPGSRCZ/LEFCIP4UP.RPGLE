     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facilities Update - Italian')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEFCIP4UP - LE Facilities Update - Italian                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 BUG14550A          Date 08Aug07               *
      *                 BUG14550           Date 04Aug07               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  BUG14550A -Error on amend (Reopen)                           *
      *  BUG14550 - Error on amend                                    *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

     FLEFCT1L0  UF A E           K DISK    Infsr(*PSSR)
     F                                     Rename(LEFCT1D0 : UpdIdx)
     F                                     Commit
      ** Midas LE Facilties - Italian

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PCustNo         S              6A
     D PFactType       S              3S 0
     D PFactNum        S              2S 0

      *****************************************************************

     D ValidFCIPItl  E DS                  Extname(LEVFCIT1PD)
      ** Externally Defined DS for Update

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************

     C                   Eval      PCustNo   = VPRCNUM                                     BUG14550A
     C                   Eval      PFactType = VPRFACT                                     BUG14550A
     C                   Eval      PFactNum  = VPRFCNO                                     BUG14550A
     C     KFacility     Chain     UpdIdx

      ** Insert, Amend or Reverse the transaction

     C                   Select
     C                   When      ActionCode = 'I'
     C                   Exsr      SrIns
     C                   When      ActionCode = 'A'
     C                   Exsr      SrAmd
     C                   When      ActionCode = 'R'
     C                   Exsr      SrDel
     C                   Endsl

     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

      ** Program Parameters

     C     *Entry        Plist

     C                   Parm                    ReturnCode
     C                   Parm                    ActionCode
     C                   Parm                    ValidFCIPItl

     C     KFacility     Klist
     C                   KFld                    PCustNo
     C                   KFld                    PFactType
     C                   KFld                    PFactNum

      ** Remove this from INZSR as the values can only be set on the                       BUG14550A
      ** initial call                                                                      BUG14550A
                                                                                           BUG14550A
     C**********         Eval      PCustNo   = VPRCNUM                                     BUG14550A
     C**********         Eval      PFactType = VPRFACT                                     BUG14550A
     C**********         Eval      PFactNum  = VPRFCNO                                     BUG14550A

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrIns - Insert a transaction                                 *
      *                                                               *
      *****************************************************************
     C     SrIns         Begsr

      ** If record not found, Insert the transaction

     C                   If        Not(%Found)

      ** Set Transaction fields on insert

     C                   Eval      PRCNUM = VPRCNUM
     C                   Eval      PRFACT = VPRFACT
     C                   Eval      PRFCNO = VPRFCNO

     C                   Eval      PRSBCL = VPRSBCL
     C                   Eval      PROPPL = VPROPPL
     C                   Eval      PREXPO = VPREXPO
     C                   Eval      PRDECD = VPRDECD
     C                   Eval      PRSACO = VPRSACO
     C                   Eval      PRSAPE = VPRSAPE

      ** Write new Transaction Detail

     C                   Write     UpdIdx

     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmd - Amend a transaction                                  *
      *                                                               *
      *****************************************************************
     C     SrAmd         Begsr

      ** Set Transaction Detail fields on amend

     C     KFacility     Chain     UpdIdx                                                   BUG14550
     C                   IF        %Found                                                   BUG14550
     C                   Eval      PRSBCL = VPRSBCL
     C                   Eval      PROPPL = VPROPPL
     C                   Eval      PREXPO = VPREXPO
     C                   Eval      PRDECD = VPRDECD
     C                   Eval      PRSACO = VPRSACO
     C                   Eval      PRSAPE = VPRSAPE

      ** Update Record

     C                   Update    UpdIdx
     C                   else                                                               LUC139
     C                   Exsr      SrIns                                                    LUC139
     C                   Endif                                                              BUG14550

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDel - Delete a transaction                                 *
      *                                                               *
      *****************************************************************
     C     SrDel         Begsr

     C                   If        %Found

      ** Delete Record

     C                   Delete    UpdIdx

     C                   Endif

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
