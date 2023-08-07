      *****************************************************************
      *                                                               *
      *  MMVLDNICUS - Midas MM Validate Cust number (Loans/Deposits)  *
      *                                                               *
      *  Last Amend No. LCI001  *CREATE    Date 27Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LCI001 - MM Deals Validation - Deal Types against Cust Types *
      *                                                               *
      *****************************************************************
      *
      ** Check if LCI001 is active
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      '*VERIFY'     POptn             7
     C                   PARM      'LCI001'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   MOVE      'N'           LCI001            1
     C                   MOVE      'N'           ITIPSV            1
     C                   IF        PRtCd = *Blanks
     C                   EVAL      LCI001 = 'Y'
     C                   ENDIF
      *
     C                   IF        LCI001 = 'Y'
      ** Check whether this program should also update spot rates
     C                   CALLB     'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      PSysVal1      PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10

     C                   If        PRtCd <> *Blanks
     C     *LOCK         In        LDA
     C                   Eval      DBFile = 'SDSVALPD'
     C                   Eval      DBase = 1
     C                   Select
     C                   When      %SUBST(PCurSet01:1:1) = '*NRF'
     C                   Eval      DBKey = PSysVal01
     C                   Endsl
     C                   Out       LDA
     C                   ExSR      *PSSR
     C                   EndIf

      * Setup ITIPSV
     C                   MOVEL     PCurSet01     ITIPSV
     C                   ENDIF
      *
