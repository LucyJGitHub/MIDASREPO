     H
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Switchable features init. for FRAs')
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APINZFRA - Switchable features initialisation for FRAs       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008             Date 16Jun04               *
      *                 CDL028             Date 07Feb05               *
      *                 217684             Date 12May03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 163185             Date 07Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 27Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CIR005 - FRA/IRS Business Day Conventions in DEALSDG         *
      *  163185 - Initialise fields for IRCs & Compounding of         *
      *           Interest (CIR001 and CIR002)                        *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
 
     FDEALSDG   UF   E             DISK    INFSR(*PSSR)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      /COPY ZACPYSRC,PSDS
 
      * PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
 
      * RESET UNUSED FIELDS
     C     ONCE          IFNE      'YES'
     C                   READ      DEALSDG                                99
     C                   MOVE      'YES'         ONCE              3
     C                   ENDIF
     C     *IN99         DOWEQ     *OFF
     C                   MOVE      '01'          FLAG              2
     C                   Z-ADD     UOBRT         TESTN             1 0
 
     C                   MOVE      '02'          FLAG
     C                   Z-ADD     TOBRT         TESTN
 
     C                   MOVE      '03'          FLAG
     C                   Z-ADD     UOPAM         TESTN
 
     C                   MOVE      '04'          FLAG
     C                   Z-ADD     TOPAM         TESTN
 
     C                   MOVE      '05'          FLAG
     C                   Z-ADD     RSTM          TESTN
 
     C**********         MOVE      '06'          FLAG                                         CSD027
     C**********         Z-ADD     ROBN          TESTN                                        CSD027
     C**********                                                                              CSD027
     C**********         MOVE      '07'          FLAG                                         CSD027
     C**********         Z-ADD     ROCN          TESTN                                        CSD027
 
     C                   MOVE      '08'          FLAG
     C                   Z-ADD     PSTM          TESTN
 
     C**********         MOVE      '09'          FLAG                                         CSD027
     C**********         Z-ADD     POBN          TESTN                                        CSD027
     C**********                                                                              CSD027
     C**********         MOVE      '10'          FLAG                                         CSD027
     C**********         Z-ADD     POCN          TESTN                                        CSD027
 
     C                   MOVE      '11'          FLAG
     C                   Z-ADD     ISDA          TESTN
 
     C                   MOVE      '12'          FLAG
     C                   Z-ADD     AGDT          TESTN
 
     C                   MOVE      '13'          FLAG
     C                   Z-ADD     AGVV          TESTN
 
     C                   MOVE      '14'          FLAG                           163185
     C                   Z-ADD     UNPCD         TESTN                          163185
                                                                                163185
     C                   MOVE      '15'          FLAG                           163185
     C                   Z-ADD     TNPCD         TESTN                          163185
                                                                                163185
     C                   MOVE      '16'          FLAG                           163185
     C                   Z-ADD     UPVD          TESTN                          163185
                                                                                163185
     C                   MOVE      '17'          FLAG                           163185
     C                   Z-ADD     UPFE          TESTN                          163185
                                                                                163185
     C                   MOVE      '18'          FLAG                           163185
     C                   Z-ADD     UPAD          TESTN                          163185
                                                                                163185
     C                   MOVE      '19'          FLAG                           163185
     C                   Z-ADD     BODD          TESTN                          163185
                                                                                163185
     C                   MOVE      '20'          FLAG                           163185
     C                   Z-ADD     BOVD          TESTN                          163185
                                                                                163185
     C                   MOVE      '21'          FLAG                           163185
     C                   Z-ADD     BOAM          TESTN                          163185
                                                                                163185
     C                   MOVE      '22'          FLAG                           163185
     C                   Z-ADD     OUSI          TESTN                          163185
                                                                                163185
     C                   MOVE      '23'          FLAG                           163185
     C                   Z-ADD     OUSA          TESTN                          163185
                                                                                163185
     C                   MOVE      '24'          FLAG                           163185
     C                   Z-ADD     TUSI          TESTN                          163185
                                                                                163185
     C                   MOVE      '25'          FLAG                           163185
     C                   Z-ADD     TUSA          TESTN                          163185
                                                                                163185
     C                   EXCEPT    DEALSG
     C                   READ      DEALSDG                                99
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *pssr         BEGSR
 
     C                   IF        PSexcpno = '1202' AND PSexcptype = 'MCH'
     C                   SELECT
     C                   WHEN      Flag = '01'
     C                   Z-ADD     *ZERO         UOBRT
     C                   WHEN      Flag = '02'
     C                   Z-ADD     *ZERO         TOBRT
     C                   WHEN      Flag = '03'
     C                   Z-ADD     *ZERO         UOPAM
     C                   WHEN      Flag = '04'
     C                   Z-ADD     *ZERO         TOPAM
     C                   WHEN      Flag = '05'
     C                   Z-ADD     *ZERO         RSTM
     C**********         WHEN      Flag = '06'                                                CSD027
     C**********         Z-ADD     *ZERO         ROBN                                         CSD027
     C**********         WHEN      Flag = '07'                                                CSD027
     C**********         Z-ADD     *ZERO         ROCN                                         CSD027
     C                   WHEN      Flag = '08'
     C                   Z-ADD     *ZERO         PSTM
     C**********         WHEN      Flag = '09'                                                CSD027
     C**********         Z-ADD     *ZERO         POBN                                         CSD027
     C**********         WHEN      Flag = '10'                                                CSD027
     C**********         Z-ADD     *ZERO         POCN                                         CSD027
     C                   WHEN      Flag = '11'
     C                   Z-ADD     *ZERO         ISDA
     C                   WHEN      Flag = '12'
     C                   Z-ADD     *ZERO         AGDT
     C                   WHEN      Flag = '13'
     C                   Z-ADD     *ZERO         AGVV
                                                                                163185
     C                   WHEN      Flag = '14'                                  163185
     C                   Z-ADD     *ZERO         UNPCD                          163185
     C                   WHEN      Flag = '15'                                  163185
     C                   Z-ADD     *ZERO         TNPCD                          163185
     C                   WHEN      Flag = '16'                                  163185
     C                   Z-ADD     *ZERO         UPVD                           163185
     C                   WHEN      Flag = '17'                                  163185
     C                   Z-ADD     *ZERO         UPFE                           163185
     C                   WHEN      Flag = '18'                                  163185
     C                   Z-ADD     *ZERO         UPAD                           163185
     C                   WHEN      Flag = '19'                                  163185
     C                   Z-ADD     *ZERO         BODD                           163185
     C                   WHEN      Flag = '20'                                  163185
     C                   Z-ADD     *ZERO         BOVD                           163185
     C                   WHEN      Flag = '21'                                  163185
     C                   Z-ADD     *ZERO         BOAM                           163185
                                                                                163185
     C                   WHEN      Flag = '22'                                  163185
     C                   Z-ADD     *ZERO         OUSI                           163185
     C                   WHEN      Flag = '23'                                  163185
     C                   Z-ADD     *ZERO         OUSA                           163185
     C                   WHEN      Flag = '24'                                  163185
     C                   Z-ADD     *ZERO         TUSI                           163185
     C                   WHEN      Flag = '25'                                  163185
     C                   Z-ADD     *ZERO         TUSA                           163185
     C                   ENDSL                                                  CAP003
     C                   ELSE
 
     C                   IF        RunBefore <> 'Y'
 
     C                   EVAL      RunBefore = 'Y'
 
     C                   EVAL      *inu7 = *on
     C                   EVAL      *inu8 = *on
     C                   EVAL      *inlr = *on
 
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR     '*DETL'
 
      *****************************************************************
 
     ODEALSDGF  E            DEALSG
     O                       UOBRT
     O                       TOBRT
     O                       UOPAM
     O                       TOPAM
     O                       RSTM
     O**********             ROBN                                                             CSD027
     O**********             ROCN                                                             CSD027
     O                       PSTM
     O**********             POBN                                                             CSD027
     O**********             POCN                                                             CSD027
     O                       ISDA
     O                       AGDT
     O                       AGVV
     O                       UNPCD                                              163185
     O                       TNPCD                                              163185
     O                       UPVD                                               163185
     O                       UPFE                                               163185
     O                       UPAD                                               163185
     O                       BODD                                               163185
     O                       BOVD                                               163185
     O                       BOAM                                               163185
     O                       OUSI                                               163185
     O                       OUSA                                               163185
     O                       TUSI                                               163185
     O                       TUSA                                               163185
**  CPY@
(c) Finastra International Limited 2001
