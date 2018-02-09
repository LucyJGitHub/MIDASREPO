     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - GL')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBGL - Global Updates - GL                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER073A            Date 05Sep17               *
      *                 CER073             Date 10Jul17               *      
      *                 MD029739           Date 15Aug14               *
      *                 MD033486           Date 27Feb15               *
      *                 MD031974           Date 16Jan15               *
      *                 CGL158             Date 22Aug14               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 17Feb15               *
      *                 MD027208           Date 28May14               *
      *                 CGL155             Date 21Mar14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024037           Date 18Dec13               *
      *                 MD023837           Date 27Nov13               *
      *                 CGL135B            Date 30Oct13               *
      *                 CGL145B            Date 30Oct13               *
      *                 CGL135A            Date 10Jul13               *
      *                 CGL145A            Date 08Oct13               *
      *                 CGL145             Date 10Jul13               *
      *                 CGP017             Date 06Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 BUG27973           Date 06Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 20Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 15Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 BUG3286            Date 17Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *      
      *  MD029739 - File renaming for integration layer.              *
      *  MD033486 - Add new Beneficiary Account field (Recompile)     *
      *  MD031974 - Failed COB Component GOC0100 seq 002234 due to    *
      *             field mismatch. (Recompile)                       *
      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD027208 - RT postings not included in Nostro group totals   *
      *             (Recompile)                                       *
      *  CGL155 - Forecast Group Limits                               *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD024037 - Facility availability Enquiry did not display a   *
      *             future datead charge to CL Balance (Recompile)    *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  CGL135B - Accounting Rules Process                           *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *  CGL135A - Accounting Rules Process                           *
      *  CGL145A - Subsidiaries Daily Sweeping Forecast               *
      *            Recompile due to changes in GLFORITD/GLFORTTD.     *
      *            Addition of GLFOAVTD.                              *
      *  CGL145 - Subsidiaries Daily Sweeping Forecast                *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSC054 - Period End Adjustments                              *
      *  BUG27973 - No section for Blocked Collateral                 *
      *  CAP204 - Retail Account Transfer                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  BUG3286 - Replication of extension files should not be       *
      *            conditioned on CLE025                              *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
     D CLE025          S              1                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
 
 
      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP
 
      * Determine updates
 
     C                   EXSR      DET_UPDATES
 
     C                   MOVEL     'B'           I#BFAF
     C                   DO        2
 
     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C     PFLNAME       CASEQ     'ACCNTAB'     GLOB_ACCNTAB
     C     PFLNAME       CASEQ     'ACCNTBXC'    GLOB_ACCNTBXC
     C     PFLNAME       CASEQ     'GLCOLAPD'    GLOB_GLCOLAPD
     C     PFLNAME       CASEQ     'GLCOLLPD'    GLOB_GLCOLLPD
     C     PFLNAME       CASEQ     'GLCOLNPD'    GLOB_GLCOLNPD
     C     PFLNAME       CASEQ     'GLJENHPD'    GLOB_GLJENHPD
     C     PFLNAME       CASEQ     'GLJENPPD'    GLOB_GLJENPPD
     C     PFLNAME       CASEQ     'GLJENSPD'    GLOB_GLJENSPD
     C     PFLNAME       CASEQ     'GLJENXPD'    GLOB_GLJENXPD                                246418
     C     PFLNAME       CASEQ     'OLPOSOA'     GLOB_OLPOSOA
     C     PFLNAME       CASEQ     'PRONOPN'     GLOB_PRONOPN
     C     PFLNAME       CASEQ     'REAPWDPD'    GLOB_REAPWDPD
     C     PFLNAME       CASEQ     'RECOMD'      GLOB_RECOMD
     C     PFLNAME       CASEQ     'REIACD'      GLOB_REIACD
     C     PFLNAME       CASEQ     'RSACMTPD'    GLOB_RSACMTPD
     C     PFLNAME       CASEQ     'GLACNTQD'    GLOB_GLACNTQD                               BUG3286
     C     PFLNAME       CASEQ     'GLATMIPD  '  GLOB_GLATMIPD                                CAP204
     C     PFLNAME       CASEQ     'GLCOLLQD  '  GLOB_GLCOLLQD                              BUG27973
     C     PFLNAME       CASEQ     'GLJENHQD  '  GLOB_GLJENHQD                                CSC054
     C     PFLNAME       CASEQ     'GLJENPQD  '  GLOB_GLJENPQD                                CSC054
     C     PFLNAME       CASEQ     'GLFORITD  '  GLOB_GLFORITD                                CGL145
     C     PFLNAME       CASEQ     'GLFORTTD  '  GLOB_GLFORTTD                                CGL145
     C     PFLNAME       CASEQ     'GLFOAVTD  '  GLOB_GLFOAVTD                               CGL145A
     C     PFLNAME       CASEQ     'GLACRUTD  '  GLOB_GLACRUTD                               CGL135A
     C     PFLNAME       CASEQ     'GLJENP1D  '  GLOB_GLJENP1D                               CGL135A
     C     PFLNAME       CASEQ     'GLFOCLTD  '  GLOB_GLFOCLTD                               CGL145B
     C     PFLNAME       CASEQ     'GLFTABTD  '  GLOB_GLFTABTD                               CGL145B
     C*****PFLNAME       CASEQ     'GLACMNTD  '  GLOB_GLACMNTD                      CGL135B MD029739
     C*****PFLNAME       CASEQ     'GLACBHTD  '  GLOB_GLACBHTD                      CGL135B MD029739
     C*****PFLNAME       CASEQ     'GLACBDTD  '  GLOB_GLACBDTD                      CGL135B MD029739
     C     PFLNAME       CASEQ     'GLFRBLTD  '  GLOB_GLFRBLTD                                CGL155
     C     PFLNAME       CASEQ     'GLACMI1D  '  GLOB_GLACMI1D                                CRE101
     C     PFLNAME       CASEQ     'GLNSRUTD  '  GLOB_GLNSRUTD                                CGL158
     C     PFLNAME       CASEQ     'GLANACQD  '  GLOB_GLANACQD                                CER073
     C/COPY WNCPYSRC,GOH00001
     C                   ENDCS
     C*****CLE025        IFEQ      'Y'                                                CLE025 BUG3286
     C*****PFLNAME       ANDEQ     'GLACNTQD'                                         CLE025 BUG3286
     C**********         EXSR      GLOB_GLACNTQD                                      CLE025 BUG3286
     C**********         ENDIF                                                        CLE025 BUG3286
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Global Updates - Account
      *****************************************************************
     C     GLOB_ACCNTAB  BEGSR
      /COPY GPCPYSRCG,GPACCNTAB
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Account Extension
      *****************************************************************
     C     GLOB_ACCNTBXC BEGSR
      /COPY GPCPYSRCG,GPACCNTBXC
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Collateral Allocations
      *****************************************************************
     C     GLOB_GLCOLAPD BEGSR
      /COPY GPCPYSRCG,GPGLCOLAPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Collateral
      *****************************************************************
     C     GLOB_GLCOLLPD BEGSR
      /COPY GPCPYSRCG,GPGLCOLLPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Collateral Narratives
      *****************************************************************
     C     GLOB_GLCOLNPD BEGSR
      /COPY GPCPYSRCG,GPGLCOLNPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Batch Header
      *****************************************************************
     C     GLOB_GLJENHPD BEGSR
      /COPY GPCPYSRCG,GPGLJENHPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Batch Postings
      *****************************************************************
     C     GLOB_GLJENPPD BEGSR
      /COPY GPCPYSRCG,GPGLJENPPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Batch Summary
      *****************************************************************
     C     GLOB_GLJENSPD BEGSR
      /COPY GPCPYSRCG,GPGLJENSPD
     C                   ENDSR
      *****************************************************************                       246418
      /SPACE 5                                                                                246418
      *****************************************************************                       246418
      * Global Updates - Batch Item Additional Information                                    246418
      *****************************************************************                       246418
     C     GLOB_GLJENXPD BEGSR                                                                246418
      /COPY GPCPYSRCG,GPGLJENXPD                                                              246418
     C                   ENDSR                                                                246418
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - On-Line positions
      *****************************************************************
     C     GLOB_OLPOSOA  BEGSR
      /COPY GPCPYSRCG,GPOLPOSOA
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Projected Nostro Balances
      *****************************************************************
     C     GLOB_PRONOPN  BEGSR
      /COPY GPCPYSRCG,GPPRONOPN
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Retail Passwords
      *****************************************************************
     C     GLOB_REAPWDPD BEGSR
      /COPY GPCPYSRCG,GPREAPWDPD
     C                   ENDSR
      *****************************************************************                       CAP204
      /SPACE 5                                                                                CAP204
      *****************************************************************                       CAP204
      * Global Updates - Account Transfer Manual Input                                        CAP204
      *****************************************************************                       CAP204
     C     GLOB_GLATMIPD BEGSR                                                                CAP204
      /COPY GPCPYSRCG,GPGLATMIPD                                                              CAP204
     C                   ENDSR                                                                CAP204
      *****************************************************************                     BUG27973
      /SPACE 5                                                                              BUG27973
      *****************************************************************                     BUG27973
      * Global Updates - Collateral Details Extension                                       BUG27973
      *****************************************************************                     BUG27973
     C     GLOB_GLCOLLQD BEGSR                                                              BUG27973
      /COPY GPCPYSRCG,GPGLCOLLQD                                                            BUG27973
     C                   ENDSR                                                              BUG27973
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Retail Charges & Commissions
      *****************************************************************
     C     GLOB_RECOMD   BEGSR
      /COPY GPCPYSRCG,GPRECOMD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Retail Interest & Charges
      *****************************************************************
     C     GLOB_REIACD   BEGSR
      /COPY GPCPYSRCG,GPREIACD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Account Movements
      *****************************************************************
     C     GLOB_RSACMTPD BEGSR
      /COPY GPCPYSRCG,GPRSACMTPD
     C                   ENDSR
      *****************************************************************                       CSC054
      /SPACE 5                                                                                CSC054
      *****************************************************************                       CSC054
      * Global Updates - Journal Entry Header Extension File                                  CSC054
      *****************************************************************                       CSC054
     C     GLOB_GLJENHQD BEGSR                                                                CSC054
      /COPY GPCPYSRCG,GPGLJENHQD                                                              CSC054
     C                   ENDSR                                                                CSC054
      *****************************************************************                       CSC054
      /SPACE 5                                                                                CSC054
      *****************************************************************                       CSC054
      * Global Updates - Journal Entry Detail Extension File                                  CSC054
      *****************************************************************                       CSC054
     C     GLOB_GLJENPQD BEGSR                                                                CSC054
      /COPY GPCPYSRCG,GPGLJENPQD                                                              CSC054
     C                   ENDSR                                                                CSC054
      *****************************************************************
      /SPACE 5
      *****************************************************************                       CGL145
      * Global Updates - Individual Forecast Table                                            CGL145
      *****************************************************************                       CGL145
     C     GLOB_GLFORITD BEGSR                                                                CGL145
      /COPY GPCPYSRCG,GPGLFORITD                                                              CGL145
     C                   ENDSR                                                                CGL145
      *****************************************************************                       CGL145
      /SPACE 5                                                                                CGL145
      *****************************************************************                       CGL145
      * Global Updates - Total Forecast Table                                                 CGL145
      *****************************************************************                       CGL145
     C     GLOB_GLFORTTD BEGSR                                                                CGL145
      /COPY GPCPYSRCG,GPGLFORTTD                                                              CGL145
     C                   ENDSR                                                                CGL145
      *****************************************************************                       CGL145
      /SPACE 5                                                                                CGL145
      *****************************************************************                      CGL135A
      * Global Updates - Accounting Rules Table                                              CGL135A
      *****************************************************************                      CGL135A
     C     GLOB_GLACRUTD BEGSR                                                               CGL135A
      /COPY GPCPYSRCG,GPGLACRUTD                                                             CGL135A
     C                   ENDSR                                                               CGL135A
      *****************************************************************                      CGL135A
      /SPACE 5                                                                               CGL135A
      *****************************************************************                      CGL135A
      * Global Updates - JE Posting Date Table                                               CGL135A
      *****************************************************************                      CGL135A
     C     GLOB_GLJENP1D BEGSR                                                               CGL135A
      /COPY GPCPYSRCG,GPGLJENP1D                                                             CGL135A
     C                   ENDSR                                                               CGL135A
      *****************************************************************                      CGL135A
      /SPACE 5                                                                               CGL135A
      *****************************************************************                      CGL145A
      * Global Updates - Forecast Available Balance Table                                    CGL145A
      *****************************************************************                      CGL145A
     C     GLOB_GLFOAVTD BEGSR                                                               CGL145A
      /COPY GPCPYSRCG,GPGLFOAVTD                                                             CGL145A
     C                   ENDSR                                                               CGL145A
      *****************************************************************                      CGL145A
      /SPACE 5                                                                               CGL145A
      *****************************************************************                      CGL145B
      * Global Updates - Forecast Total Available Balance                                    CGL145B
      *****************************************************************                      CGL145B
     C     GLOB_GLFTABTD BEGSR                                                               CGL145B
      /COPY GPCPYSRCG,GPGLFTABTD                                                             CGL145B
     C                   ENDSR                                                               CGL145B
      *****************************************************************                      CGL145B
      /SPACE 5                                                                               CGL145B
      *****************************************************************                      CGL145B
      * Global Updates - Forecast Credit Line Available Balance                              CGL145B
      *****************************************************************                      CGL145B
     C     GLOB_GLFOCLTD BEGSR                                                               CGL145B
      /COPY GPCPYSRCG,GPGLFOCLTD                                                             CGL145B
     C                   ENDSR                                                               CGL145B
      *****************************************************************                      CGL145B
      /SPACE 5                                                                               CGL145B
      *****************************************************************                      CGL135A
      * Global Updates - Accounting Rules Monitor File                                       CGL135A
      *****************************************************************                      CGL135A
     C*****GLOB_GLACMNTD BEGSR                                                      CGL135B MD029739
      ***/COPY*GPCPYSRCG,GPGLACMNTD                                                 CGL135B MD029739
     C**********         ENDSR                                                      CGL135B MD029739
      *****************************************************************                      CGL135A
      /SPACE 5                                                                               CGL135A
      *****************************************************************                      CGL135A
      * Global Updates - Accounting Rules Batch Header File                                  CGL135A
      *****************************************************************                      CGL135A
     C*****GLOB_GLACBHTD BEGSR                                                      CGL135B MD029739
      ***/COPY*GPCPYSRCG,GPGLACBHTD                                                 CGL135B MD029739
     C**********         ENDSR                                                      CGL135B MD029739
      *****************************************************************                      CGL135A
      /SPACE 5                                                                               CGL135A
      *****************************************************************                      CGL135A
      * Global Updates - Accounting Rules Batch Details File                                 CGL135A
      *****************************************************************                      CGL135A
     C*****GLOB_GLACBDTD BEGSR                                                      CGL135B MD029739
      ***/COP* GPCPYSRCG,GPGLACBDTD                                                 CGL135B MD029739
     C**********         ENDSR                                                      CGL135B MD029739
      *****************************************************************                      CGL135A
      /SPACE 5                                                                               CGL135A
      *****************************************************************                       CGL155
      * Global Updates - Forecast Projected Balance                                           CGL155
      *****************************************************************                       CGL155
     C     GLOB_GLFRBLTD BEGSR                                                                CGL155
      /COPY GPCPYSRCG,GPGLFRBLTD                                                              CGL155
     C                   ENDSR                                                                CGL155
      *****************************************************************                       CGL155
      /SPACE 5                                                                                CRE101
      *****************************************************************                       CRE101
      * Global Updates - Accounts Interim Int Statement Freq                                  CRE101
      *****************************************************************                       CRE101
     C     GLOB_GLACMI1D BEGSR                                                                CRE101
      /COPY GPCPYSRCG,GPGLACMI1D                                                              CRE101
     C                   ENDSR                                                                CRE101
      *****************************************************************                       CRE101
      /SPACE 5                                                                                CRE101
      *****************************************************************                       CGL158
      * Global Updates - Nostro Sweeping Rules Table                                          CGL158
      *****************************************************************                       CGL158
     C     GLOB_GLNSRUTD BEGSR                                                                CGL158
      /COPY GPCPYSRCG,GPGLNSRUTD                                                              CGL158
     C                   ENDSR                                                                CGL158
      *****************************************************************                       CGL158
      /SPACE 5                                                                                CGL158
      *****************************************************************                       CER073
      * Global Updates - AnaCredit Reporting                                                  CER073
      *****************************************************************                       CER073
     C     GLOB_GLANACQD BEGSR                                                                CER073
      /COPY GPCPYSRCG,GPGLANACQD                                                              CER073
     C                   ENDSR                                                                CER073
      *****************************************************************                       CER073
      /SPACE 5                                                                                CER073
      *****************************************************************
      * Determine Updates
      *****************************************************************
     C     DET_UPDATES   BEGSR
 
     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************                       CLE025
      * Global Updates - Account Extension                                                    CLE025
      *****************************************************************                       CLE025
     C     GLOB_GLACNTQD BEGSR                                                                CLE025
      /COPY GPCPYSRCG,GPGLACNTQD                                                              CLE025
     C                   ENDSR                                                                CLE025
      *****************************************************************                       CLE025
      /SPACE 5                                                                                CLE025
     C/COPY WNCPYSRC,GOH00002
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
                                                                                              CLE025
      ** Determine if CLE025 is switched on                                                   CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVE      'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
