     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals Transaction Extension - Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXFXDL2UP - FX Deals Transaction Extension - Update          *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 15Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to FM2.1                            *
      *                                                               *
      *****************************************************************

     F**DLFXT1L0  UF A E           K DISK    INFSR(*PSSR)                                  LUC139
     FDLFXT1L1  UF A E           K DISK    INFSR(*PSSR)                                    LUC139
     F                                     COMMIT
      ** Midas FX Transactions - Ext. index

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
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

     D ValidFXDLEx   E DS                  Extname(FXVFXIT1PD)
      ** Externally Defined DS for Update

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************

     C     PVDN38        Chain     DLFXT1L1

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

     C                   Parm                    @RtCd
     C                   Parm                    ActionCode
     C                   Parm                    ValidFXDLEx

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

     C                   Eval      PJDN38 = PVDN38
     C                   Eval      PJMOOP = PVMOOP
     C                   Eval      PJTPPR = PVTPPR
     C                   Eval      PJPEPR = PVPEPR
     C                   Eval      PJGLPA = PVGLPA
     C                   Eval      PJTPFD = PVTPFD

      ** Write new Transaction Detail

     C                   Write     DLFXT1D0

     C                   Else

      ** Amend the transaction

     C                   Exsr      SrAmd
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

     C                   If        %Found

      ** Set Transaction Detail fields on amend

     C                   Eval      PJDN38 = PVDN38
     C                   Eval      PJMOOP = PVMOOP
     C                   Eval      PJTPPR = PVTPPR
     C                   Eval      PJPEPR = PVPEPR
     C                   Eval      PJGLPA = PVGLPA
     C                   Eval      PJTPFD = PVTPFD

      ** Update Record

     C                   Update    DLFXT1D0
     C                   Else

      ** Insert the transaction

     C                   Exsr      SrIns
     C                   Endif

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

     C                   Delete    DLFXT1D0

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
      *          a ROLLBACK                                           *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Systems Ltd. 2020
