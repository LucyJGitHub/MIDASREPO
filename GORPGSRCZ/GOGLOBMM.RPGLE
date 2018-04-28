     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - MM')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBMM - Global Updates - MM                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CTI006             Date 31Mar14               *
      *  Prev Amend No. AR1096788          Date 18Mar13               *
      *                 CGP017             Date 06Aug12               *
      *                 CAP210             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS011             Date 16May05               *
      *                 BUG3644            Date 12Jul04               *
      *                 BUG3286            Date 17Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI006    - Trade Finance BF Midas 2.2 Interface             *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  BUG3644 - Serious Error in Collateralised Lending            *
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
     D CAS009          S              1                                                       CAS011
 
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
     C     PFLNAME       CASEQ     'MMDEAMPP'    GLOB_MMDEAMPP
     C     PFLNAME       CASEQ     'MMDELDPP'    GLOB_MMDELDPP
     C     PFLNAME       CASEQ     'MMDENBPP'    GLOB_MMDENBPP
     C     PFLNAME       CASEQ     'MMDENSPP'    GLOB_MMDENSPP
     C     PFLNAME       CASEQ     'DLDLDCQD'    GLOB_DLDLDCQD                               BUG3286
     C     PFLNAME       CASEQ     'DEALSDC'     GLOB_DEALSDC                                BUG3644
     C*****PFLNAME       CASEQ     'DLSTRANFPD'  GLOB_DLSTRANF                      CAP210 AR1096788
     C     PFLNAME       CASEQ     'STRANF'      GLOB_STRANF                               AR1096788
     C     PFLNAME       CASEQ     'DEALSDB'     GLOB_DEALSDB                                 CTI006
     C                   ENDCS
     C*****CLE025        IFEQ      'Y'                                                CLE025 BUG3286
     C*****PFLNAME       ANDEQ     'DLDLDCQD'                                         CLE025 BUG3286
     C**********         EXSR      GLOB_DLDLDCQD                                      CLE025 BUG3286
     C**********         ENDIF                                                        CLE025 BUG3286
                                                                                              CAS011
     C     CAS009        IFEQ      'Y'                                                        CAS011
     C     PFLNAME       ANDEQ     'DLFEED'                                                   CAS011
     C                   EXSR      GLOB_MMDLFEED                                              CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5                                                                               BUG3644
      *****************************************************************                      BUG3644
      * Global Updates - Money Market Deposit and Loan Deals                                 BUG3644
      *****************************************************************                      BUG3644
     C     GLOB_DEALSDC  BEGSR                                                               BUG3644
      /COPY GPCPYSRCG,GPDEALSDC                                                              BUG3644
     C                   ENDSR                                                               BUG3644
      *****************************************************************                      BUG3644
      /SPACE 5
      *****************************************************************
      * Global Updates - Deal Amendment
      *****************************************************************
     C     GLOB_MMDEAMPP BEGSR
      /COPY GPCPYSRCG,GPMMDEAMPP
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Loan/Deposit
      *****************************************************************
     C     GLOB_MMDELDPP BEGSR
      /COPY GPCPYSRCG,GPMMDELDPP
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Negotiable Asset Purchased
      *****************************************************************
     C     GLOB_MMDENBPP BEGSR
      /COPY GPCPYSRCG,GPMMDENBPP
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Negotiable Asset Sold
      *****************************************************************
     C     GLOB_MMDENSPP BEGSR
      /COPY GPCPYSRCG,GPMMDENSPP
     C                   ENDSR
      *****************************************************************
      /SPACE 5
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
      /SPACE 5                                                                                CLE025
      *****************************************************************                       CLE025
      * Global Updates - MM/Loans Extension                                                   CLE025
      *****************************************************************                       CLE025
     C     GLOB_DLDLDCQD BEGSR                                                                CLE025
      /COPY GPCPYSRCG,GPDLDLDCQD                                                              CLE025
     C                   ENDSR                                                                CLE025
      *****************************************************************                       CLE025
      /SPACE 5                                                                                CAS011
      *****************************************************************                       CAS011
      * Global Updates - MM/Dealing Fees                                                      CAS011
      *****************************************************************                       CAS011
     C     GLOB_MMDLFEED BEGSR                                                                CAS011
      /COPY GPCPYSRCG,GPDLFEED                                                                CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       CAS011
      /SPACE 5                                                                                CAP210
      *****************************************************************                       CAP210
      **Global*Updates*-*Adjustment*to*Accrued*Interests***************             CAP210 AR1096788
      *****************************************************************                       CAP210
     C*****GLOB_DLSTRANF BEGSR                                                      CAP210 AR1096788
     **COPY*GPCPYSRCG,GPDLSTRANF                                                    CAP210 AR1096788
     C**********         ENDSR                                                      CAP210 AR1096788
      *****************************************************************                       CAP210
      /SPACE 5                                                                             AR1096788
      *****************************************************************                    AR1096788
      * Global Updates - Adjustment to Accrued Interests                                   AR1096788
      *****************************************************************                    AR1096788
     C     GLOB_STRANF   BEGSR                                                             AR1096788
      /COPY GPCPYSRCG,GPSTRANF                                                             AR1096788
     C                   ENDSR                                                             AR1096788
      *****************************************************************                    AR1096788
      /SPACE 5                                                                                CTI006
      *****************************************************************                       CTI006
      * Global Updates - Money Market Deposit and Loan Deals                                  CTI006
      *****************************************************************                       CTI006
     C     GLOB_DEALSDB  BEGSR                                                                CTI006
      /COPY GPCPYSRCG,GPDEALSDB                                                               CTI006
     C                   ENDSR                                                                CTI006
      *****************************************************************                       CTI006
     C/SPACE 5
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
                                                                                              CAS011
      ** Determine if CAS009 is switched on                                                   CAS011
                                                                                              CAS011
     C                   CALL      'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRTCD                                        CAS011
     C                   PARM      '*VERIFY'     POPTN                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
                                                                                              CAS011
     C                   IF        PRTCD = *BLANKS                                            CAS011
     C                   MOVE      'Y'           CAS009                                       CAS011
     C                   ELSE                                                                 CAS011
     C                   MOVE      'N'           CAS009                                       CAS011
     C                   ENDIF                                                                CAS011
 
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
(c) Misys International Banking Systems Ltd. 2003
