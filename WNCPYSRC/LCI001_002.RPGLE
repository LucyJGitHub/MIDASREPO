000100170911      *****************************************************************
000200170911      *                                                               *
000201180914      *  MMVLDNICUS - Midas MM Validate Cust number (Loans/Deposits)  *
000202180914      *                                                               *
000300200804      *  Last Amend No. LCI001  *CREATE    Date 27Jul20               *
000400170911      *                                                               *
000500170911      *---------------------------------------------------------------*
000600170911      *                                                               *
000700180912      *  LCI001 - MM Deals Validation - Deal Types against Cust Types *
000800170911      *                                                               *
000900170911      *****************************************************************
000901180912      *
000902180912      ** Check if LCI001 is active
000903180912      *
000906180912     C                   CALLB     'AOSARDR0'
000907180912     C                   PARM      *BLANKS       PRtCd             7
000908180912     C                   PARM      '*VERIFY'     POptn             7
000909180912     C                   PARM      'LCI001'      PSARD             6
000910180912     C     SCSARD        PARM      SCSARD        DSFDY
000911180912
000912180912     C                   MOVE      'N'           LCI001            1
000913180912     C                   MOVE      'N'           ITIPSV            1
000914180912     C                   IF        PRtCd = *Blanks
000915180912     C                   EVAL      LCI001 = 'Y'
000916180912     C                   ENDIF
000917180912      *
000918180913     C                   IF        LCI001 = 'Y'
000919180912      ** Check whether this program should also update spot rates
000920180912     C                   CALLB     'AOSVALR0'
000921180912     C                   PARM      *BLANKS       PRtCd             7
000922180912     C                   PARM      PSysVal1      PSysVal01
000923180912     C                   PARM                    PCurSet01
000924180912     C                   PARM                    PSysVal02
000925180912     C                   PARM                    PCurSet02
000926180912     C                   PARM                    PSysVal03
000927180912     C                   PARM                    PCurSet03
000928180912     C                   PARM                    PSysVal04
000929180912     C                   PARM                    PCurSet04
000930180912     C                   PARM                    PSysVal05
000931180912     C                   PARM                    PCurSet05
000932180912     C                   PARM                    PSysVal06
000933180912     C                   PARM                    PCurSet06
000934180912     C                   PARM                    PSysVal07
000935180912     C                   PARM                    PCurSet07
000936180912     C                   PARM                    PSysVal08
000937180912     C                   PARM                    PCurSet08
000938180912     C                   PARM                    PSysVal09
000939180912     C                   PARM                    PCurSet09
000940180912     C                   PARM                    PSysVal10
000941180912     C                   PARM                    PCurSet10
000942180912
000943180912     C                   If        PRtCd <> *Blanks
000944180912     C     *LOCK         In        LDA
000945180912     C                   Eval      DBFile = 'SDSVALPD'
000946180912     C                   Eval      DBase = 1
000947180912     C                   Select
000948180912     C                   When      %SUBST(PCurSet01:1:1) = '*NRF'
000949180912     C                   Eval      DBKey = PSysVal01
000950180912     C                   Endsl
000951180912     C                   Out       LDA
000952180912     C                   ExSR      *PSSR
000953180912     C                   EndIf
000954180912
000955180912      * Setup ITIPSV
000956180912     C                   MOVEL     PCurSet01     ITIPSV
000957180913     C                   ENDIF
006422180912      *
