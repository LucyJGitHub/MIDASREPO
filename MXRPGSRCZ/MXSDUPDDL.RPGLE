     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Saved data update - dealing module')          *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXSDUPDDL - Saved Data Update - DEALING Module               *
      *                                                               *
      *  Function:  This module updates the dealing saved data files. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR1097467          Date 01Apr13               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS009             Date 16May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 217684             Date 12May03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CGL020             Date 12Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191998             Date 15Apr01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR1097467 - Expected 15% COB run optimization not met        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  191998 - N/A balances not created                            *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************

     F***DEALSDB   IP   E             DISK    INFSR(*PSSR) PREFIX(B_)                      AR1097467
     F***DEALSDC   IS   E             DISK    INFSR(*PSSR) PREFIX(C_)                      AR1097467
     F***DEALSDD   IS   E             DISK    INFSR(*PSSR) PREFIX(D_)                      AR1097467
     F***DEALSDE   IS   E             DISK    INFSR(*PSSR) PREFIX(E_)                      AR1097467
     F***DEALSDG   IS   E             DISK    INFSR(*PSSR) PREFIX(G_)                      AR1097467
     FDEALSDB   IF   E             DISK    INFSR(*PSSR) PREFIX(B_)                         AR1097467
     FDEALSDC   IF   E             DISK    INFSR(*PSSR) PREFIX(C_)                         AR1097467
     FDEALSDD   IF   E             DISK    INFSR(*PSSR) PREFIX(D_)                         AR1097467
     FDEALSDE   IF   E             DISK    INFSR(*PSSR) PREFIX(E_)                         AR1097467
     FDEALSDG   IF   E             DISK    INFSR(*PSSR) PREFIX(G_)                         AR1097467
     FMXSDLDBPD UF A E           K DISK    RENAME(DEALSDBF:MXSDLDBP0)
     F                                     INFSR(*PSSR) PREFIX(PB_)
     FMXSDLDCPD UF A E           K DISK    RENAME(DEALSDCF:MXSDLDCP0)
     F                                     INFSR(*PSSR) PREFIX(PC_)
     FMXSDLDDPD UF A E           K DISK    RENAME(DEALSDDF:MXSDLDDP0)
     F                                     INFSR(*PSSR) PREFIX(PD_)
     FMXSDLDEPD UF A E           K DISK    RENAME(DEALSDEF:MXSDLDEP0)
     F                                     INFSR(*PSSR) PREFIX(PE_)
     FMXSDLDGPD UF A E           K DISK    RENAME(DEALSDGF:MXSDLDGP0)
     F                                     INFSR(*PSSR) PREFIX(PG_)
     FMXAKDLPD  O    E             DISK    INFSR(*PSSR)

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Entry Parameter                                                                   AR1097467
                                                                                           AR1097467
     D I#FILE          S             10A                                                   AR1097467

      * FX Deals
     D DLDB          E DS                  EXTNAME(DEALSDB)
     D                                     PREFIX(B_)
     D P_DLDB        E DS                  EXTNAME(MXSDLDBPD)
     D                                     PREFIX(PB_)
      * Loans/Deposits
     D DLDC          E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
     D P_DLDC        E DS                  EXTNAME(MXSDLDCPD)
     D                                     PREFIX(PC_)
      * Negotiable Assets Purchased
     D DLDD          E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
     D P_DLDD        E DS                  EXTNAME(MXSDLDDPD)
     D                                     PREFIX(PD_)
      * Negotiable Assets Sold
     D DLDE          E DS                  EXTNAME(DEALSDE)
     D                                     PREFIX(E_)
     D P_DLDE        E DS                  EXTNAME(MXSDLDEPD)
     D                                     PREFIX(PE_)
      * FRAS, Swaps, Caps, Floors, Collars
     D DLDG          E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(G_)
     D P_DLDG        E DS                  EXTNAME(MXSDLDGPD)
     D                                     PREFIX(PG_)


     D                 DS
     D*AKEY********************1     10                                                       CDL038
     D AKEY                    1     14                                                       CDL038
     D AK_DTYP                 1      2
     D AK_DLST                 4      5
     D AK_AMTC                 9     10


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)


     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)


     I***DEALSDBF      01                                                                  AR1097467
     I***DEALSDCF      02                                                                  AR1097467
     I***DEALSDDF      03                                                                  AR1097467
     I***DEALSDEF      04                                                                  AR1097467
     I***DEALSDGF      05                                                                  AR1097467


     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Start of Month (Y/N)
     C                   PARM                    S_O_Month         1
     C                   PARM                    I#FILE                                    AR1097467

     C                   MOVEL     *BLANK        AKEY

      * If an FX Deal

     C******in01         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'DEALSDB'                                      AR1097467
     C     1             SETLL     DEALSDB                                                 AR1097467
     C                   READ      DEALSDB                                                 AR1097467
     C                   DOW       NOT %EOF(DEALSDB)                                       AR1097467
     C     B_RECI        IFEQ      'D'
     C     B_RECI        OREQ      'R'
     C                   MOVEL     B_BRCA        I#BRCA
     C                   MOVEL     B_DTYP        I#DTYP
     C                   MOVEL     B_DLST        I#DLST
     C                   EXSR      FILTER

      * If deal is for export
      * Update Saved FX Deals
      * Write Start of Month 'Dummy' A/C Key For FX Deals

     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_DTST      ANDEQ     'Y'
     C                   EXSR      UPD_DB
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_DB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      DEALSDB                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF

      * If a Loan/Deposit

     C******in02         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'DEALSDC'                                      AR1097467
     C     1             SETLL     DEALSDC                                                 AR1097467
     C                   READ      DEALSDC                                                 AR1097467
     C                   DOW       NOT %EOF(DEALSDC)                                       AR1097467
     C     C_RECI        IFEQ      'D'
     C     C_RECI        OREQ      'R'
     C                   MOVEL     C_BRCA        I#BRCA
     C                   MOVEL     C_DTYP        I#DTYP
     C                   MOVEL     C_DLST        I#DLST
     C                   EXSR      FILTER

      * If deal is for export
      * Update Saved Loans/Deposits
      * Write Start of Month 'Dummy' A/C Key For Loans/Deposits

     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_DTST      ANDEQ     'Y'
     C                   EXSR      UPD_DC
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_DC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      DEALSDC                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF

      * If a Negotiable Asset Purchased

     C******in03         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'DEALSDD'                                      AR1097467
     C     1             SETLL     DEALSDD                                                 AR1097467
     C                   READ      DEALSDD                                                 AR1097467
     C                   DOW       NOT %EOF(DEALSDD)                                       AR1097467
     C     D_RECI        IFEQ      'D'
     C     D_RECI        OREQ      'R'
     C                   MOVEL     D_BRCA        I#BRCA
     C                   MOVEL     D_DTYP        I#DTYP
     C                   MOVEL     D_DLST        I#DLST
     C                   EXSR      FILTER

      * If deal is for export
      * Update Saved N.A.s Purchased
      * Write Start of Month 'Dummy' A/C Key For N.A.s Purchased

     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_DTST      ANDEQ     'Y'
     C                   EXSR      UPD_DD
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_DD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      DEALSDD                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF

      * If a Negotiable Asset Sold

     C******in04         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'DEALSDE'                                      AR1097467
     C     1             SETLL     DEALSDE                                                 AR1097467
     C                   READ      DEALSDE                                                 AR1097467
     C                   DOW       NOT %EOF(DEALSDE)                                       AR1097467
     C     E_RECI        IFEQ      'D'
     C     E_RECI        OREQ      'R'
     C                   MOVEL     E_BRCA        I#BRCA
     C                   MOVEL     E_DTYP        I#DTYP
     C                   MOVEL     E_DLST        I#DLST
     C                   EXSR      FILTER

      * If deal is for export
      * Update Saved Negotiable Assets Sold
      * Write Start of Month 'Dummy' A/C Key For Negotiable Assets Sold

     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_DTST      ANDEQ     'Y'
     C                   EXSR      UPD_DE
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_DE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      DEALSDE                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF

      * If an FRA, Swap, Cap, Floor, Collar

     C******in05         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'DEALSDG'                                      AR1097467
     C     1             SETLL     DEALSDG                                                 AR1097467
     C                   READ      DEALSDG                                                 AR1097467
     C                   DOW       NOT %EOF(DEALSDG)                                       AR1097467
     C     G_RECI        IFEQ      'D'
     C     G_RECI        OREQ      'R'
     C                   MOVEL     G_BRCA        I#BRCA
     C                   MOVEL     G_DTYP        I#DTYP
     C                   MOVEL     G_DLST        I#DLST
     C                   EXSR      FILTER

      * If deal is for export
      * Update Saved FRAS, Swaps, Caps, Floors, Collars
      * Write Start of Month 'Dummy' A/C Key For FRAS, Swaps, Cps, Fls, Clrs

     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_DTST      ANDEQ     'Y'
     C                   EXSR      UPD_DG
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_DG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      DEALSDG                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF

     C                   EVAL      *INLR = *ON                                             AR1097467
     C                   RETURN                                                            AR1097467
      *
      /SPACE 5
      ********************************************************************
      * Filter Deals
      ********************************************************************
     C     FILTER        BEGSR

      * On change of branch
      * Determine if branch is to be included in the export

     C     I#BRCA        IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   EXSR      BRCA_FLT
     C                   MOVEL     I#BRCA        Prev_BRCA         3
     C                   ENDIF

      * On change of deal type/sub type
      * Determine if deal type/sub type is to be included in the export

     C     I#DTYP        IFNE      Prev_DTYP
     C     I#DLST        ORNE      Prev_DLST
     C                   MOVE      'D'           I#LD
     C                   EXSR      DTST_FLT
     C                   MOVEL     I#DTYP        Prev_DTYP         2
     C                   MOVEL     I#DLST        Prev_DLST         2
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved FX Deals
      ********************************************************************
     C     UPD_DB        BEGSR

     C     B_DLNO        CHAIN     MXSDLDBP0                          99        *
     C                   EVAL      P_DLDB = DLDB
     C                   EVAL      PB_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSDLDBP0
     C                   ELSE
     C                   UPDATE    MXSDLDBP0
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved Loans/Deposits
      ********************************************************************
     C     UPD_DC        BEGSR

     C     C_DLNO        CHAIN     MXSDLDCP0                          99        *
     C                   EVAL      P_DLDC = DLDC
     C                   EVAL      PC_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSDLDCP0
     C                   ELSE
     C                   UPDATE    MXSDLDCP0
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved Negotiable Assets Purchased
      ********************************************************************
     C     UPD_DD        BEGSR

     C     D_DLNO        CHAIN     MXSDLDDP0                          99        *
     C                   EVAL      P_DLDD = DLDD
     C                   EVAL      PD_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSDLDDP0
     C                   ELSE
     C                   UPDATE    MXSDLDDP0
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved Negotiable Assets Sold
      ********************************************************************
     C     UPD_DE        BEGSR

     C     E_DLNO        CHAIN     MXSDLDEP0                          99        *
     C                   EVAL      P_DLDE = DLDE
     C                   EVAL      PE_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSDLDEP0
     C                   ELSE
     C                   UPDATE    MXSDLDEP0
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved FRAS, Swaps, Caps, Floors, Collars
      ********************************************************************
     C     UPD_DG        BEGSR

     C     G_DLNO        CHAIN     MXSDLDGP0                          99        *
     C                   EVAL      P_DLDG = DLDG
     C                   EVAL      PG_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSDLDGP0
     C                   ELSE
     C                   UPDATE    MXSDLDGP0
     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For FX Deals
      ********************************************************************
     C     WRTSOM_DB     BEGSR

     C     B_ORED        IFLT      CURSOM

     C                   MOVEL     B_DTYP        AK_DTYP
     C                   MOVEL     B_DLST        AK_DLST
     C                   Z-ADD     B_DLNO        DLNO
     C                   MOVEL     B_BRCA        BRCA
     C                   Z-ADD     CURSOM        EDAT
      * Buy Amount
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     B_PUAM        EAMT
     C                   MOVEL     B_PUCY        ECCY
     C                   WRITE     DKEYSDPF
      * Sell Amount
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     B_SLAM        EAMT
     C                   MOVEL     B_SLCY        ECCY
     C                   WRITE     DKEYSDPF

     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For Loans/Deposits
      ********************************************************************
     C     WRTSOM_DC     BEGSR

     C     C_ORED        IFLT      CURSOM
     C     C_VDAT        ANDLT     CURSOM

     C                   MOVEL     C_DTYP        AK_DTYP
     C                   MOVEL     C_DLST        AK_DLST
     C                   Z-ADD     C_DLNO        DLNO
     C                   MOVEL     C_BRCA        BRCA
     C                   Z-ADD     CURSOM        EDAT
      * Principal
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     C_PCPL        EAMT
     C     C_FUID        IFEQ      'Y'
     C                   SUB       C_TOTI        EAMT
     C                   ENDIF
     C                   MOVEL     C_CCY         ECCY
     C                   WRITE     DKEYSDPF

     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For Negotiable Assets Purchased
      ********************************************************************
     C     WRTSOM_DD     BEGSR

     C     D_ORED        IFLT      CURSOM
     C     D_VDAT        ANDLT     CURSOM

     C                   MOVEL     D_DTYP        AK_DTYP
     C                   MOVEL     D_DLST        AK_DLST
     C                   Z-ADD     D_DLNO        DLNO
     C                   MOVEL     D_BRCA        BRCA
     C                   Z-ADD     CURSOM        EDAT
      * Purchase Price
     C                   MOVE      ' A'          AK_AMTC
     C*******************Z-ADD     D_PUPR        EAMT                           191998
     C                   Z-ADD     D_FVAL        EAMT                           191998
     C                   SUB       D_DISA        EAMT                           191998
     C                   MOVEL     D_CCY         ECCY
     C                   WRITE     DKEYSDPF

     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For Negotiable Assets Sold
      ********************************************************************
     C     WRTSOM_DE     BEGSR

     C     E_ORED        IFLT      CURSOM

     C                   MOVEL     E_DTYP        AK_DTYP
     C                   MOVEL     E_DLST        AK_DLST
     C                   Z-ADD     E_DLNO        DLNO
     C                   MOVEL     E_BRCA        BRCA
     C                   Z-ADD     CURSOM        EDAT
      * Sale Price
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     E_SAPR        EAMT
     C                   MOVEL     E_CCY         ECCY
     C                   WRITE     DKEYSDPF

     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For FRAS, Swaps, Cps, Fls, Clrs
      ********************************************************************
     C     WRTSOM_DG     BEGSR

     C     G_DTYP        IFEQ      'FR'
     C     G_ORED        ANDLT     CURSOM
     C     G_DTYP        ORNE      'FR'
     C     G_ORED        ANDLT     CURSOM
     C     G_VDAT        ANDLT     CURSOM

     C                   MOVEL     G_DTYP        AK_DTYP
     C                   MOVEL     G_DLST        AK_DLST
     C                   Z-ADD     G_DLNO        DLNO
     C                   MOVEL     G_BRCA        BRCA
     C                   Z-ADD     CURSOM        EDAT
      * Our Amount
      * or Principal
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     G_UPAMT       EAMT
     C                   MOVEL     G_UCUCY       ECCY
     C                   WRITE     DKEYSDPF
      * Their Amount
     C     G_DTYP        IFEQ      'RX'
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     G_TPAMT       EAMT
     C                   MOVEL     G_TCUCY       ECCY
     C                   WRITE     DKEYSDPF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

      * Set up constants

     C                   MOVEL     'A'           I#EXTT            1


      **  Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY


      * Get extract control data

     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
     C                   OUT       MXEXPCTL


      * If no save data is required then end
      * (If frequency is 'NEVER'  or
      *  if frequency is 'MONTHLY' but it is not the start of the month)

     C     SDFQDL        IFEQ      'N'
     C     SDFQDL        OREQ      'M'
     C     S_O_Month     ANDNE     'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      * Load branches for export

     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT

      * Load deal type/sub types for export

     C                   MOVE      'L'           I#LD
     C                   EXSR      DTST_FLT

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * D E A L  T Y P E  / S U B   T Y P E   F I L T E R
      /COPY MXCPYSRC,MXFLTDTST
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
