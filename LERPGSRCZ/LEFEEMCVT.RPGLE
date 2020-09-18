     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee conversion - file to screen format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFEEMCVT - LE Fee Conversion: File to Screen Format         *
      *                                                               *
      *  Function:  This module converts the fields of a Fee          *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR318270           Date 01Aug12               *
      *                 263801             Date 01Aug12               *
      *                 262672             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 242377             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 237464             Date 21Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP084             Date 19Feb04               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR318270 - Specific Fee amendment ends in error              *
      *             (Child: AR321380)                                 *
      *  263801 - P2: CLE134 API FEEM Wrong interpretaion of DDSFPM   *
      *  262672 - Modified to only set/validate suspense details when *
      *           suspense fees allowed.                              *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation                          *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  242377 - When System Values for LoanCustOriginPurch = 'O',   *
      *           customer for fee that should be displayed should be *
      *           the original borrower for participations purchased. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  237464 - ZSEDIT result filed ZFLD21 have a trailing space    *
      *           reserved for integer sign.  Consider this space     *
      *           when converting rate fields.                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  CAP084 - Improved error handling.                            *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      *                                                               *
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
                                                                                              CLE134
     FCLOAN     IF   E           K DISK    PREFIX(pd_)                                        CLE134
     F                                     RENAME(CLOANCLF:CLOAFF)                            CLE134
     F                                     IGNORE(CLOANHHF)                                   CLE134
     F                                     IGNORE(CLOANCKF)                                   CLE134
     F                                     IGNORE(CLOANZ1F)                                   CLE134

      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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

      ** Include the GL standard declares
     D/COPY GLCPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+

      * Fee in File Format
     D CrFeFilFmt    E DS                  EXTNAME(LEFEED)

      * Customer Loans record CL in file Format
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(CL_)

      * Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FA_)

      * Fee in Screen Format
     D CrFeScnFmt    E DS                  EXTNAME(LEFEEMPD)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **   CURRENCY TYPE

     D SDFEE         E DS                  EXTNAME(SDFEEPD)                                   CLE134
                                                                                              CLE134
      ** External DS for Fee Details                                                          CLE134
                                                                                              CLE134
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D                 DS                                                                     242377
     D  WPARM                  1     20                                                       242377
     D  WPARM1                 1      5                                                       242377
     D  WPARM2                 6     10                                                       242377
     D  WPARM3                11     15                                                       242377
     D  WPARM4                16     20                                                       242377
      *                                                                                       242377
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

     D Kpd_LNRF        S                   LIKE(pd_LNRF)                                      CLE134
                                                                                              CLE134
     D P@FCOD          S              2A                                                      CLE134
                                                                                              CLE134
     D CLE134          S              1                                                       CLE134

      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** Set output screen fields for screen
     C                   EXSR      SETFLD

      * Return
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output for screen
      *****************************************************************
     C     SETFLD        BEGSR
      *
     C*****FECNUM        IFEQ      0                                                          CSD027
     C     FECNUM        IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANKS       DDCSSN
     C                   ELSE
     C                   MOVEL     FECNUM        DDCSSN
     C                   ENDIF

     C*****FELOAN        IFEQ      0                                                          CLE148
     C     FELOAN        IFEQ      *BLANKS                                                    CLE148
     C                   MOVE      *BLANKS       DDLNRF
     C                   ELSE
     C     PPCUST        IFEQ      'O'                                                        242377
     C     CL_PTYP       IFEQ      64                                                         242377
     C     CL_PTYP       OREQ      65                                                         242377
     C     CL_PTYP       OREQ      68                                                         242377
     C     CL_PTYP       OREQ      71                                                         242377
     C                   MOVEL     CL_OLNO       DDCSSN                                       242377
     C                   ENDIF                                                                242377
     C                   ENDIF                                                                242377
     C                   MOVE      FELOAN        DDLNRF
     C                   ENDIF

     C     FEFACL        IFEQ      0
     C                   MOVE      *BLANKS       DDFACT
     C                   MOVE      *BLANKS       DDFCNO
     C                   ELSE
     C                   MOVEL     FEFACL        DDFACT
     C                   MOVE      FEFACL        DDFCNO
     C                   ENDIF

     C                   MOVE      FEFSEQ        DDFSEQ
     C                   MOVE      FEFCOD        DDECOD
     C                   MOVE      FEFCCY        DDECUR
     C                   MOVE      *BLANKS       DDESGN
      *
     C     FEFAMT        IFEQ      0
     C                   MOVE      *BLANKS       DDEAMT
     C                   ELSE
      *
     C     FEFAMT        IFLT      0
     C                   Z-SUB     FEFAMT        ZFLD15
     C                   ELSE
     C                   Z-ADD     FEFAMT        ZFLD15
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDEAMT
     C                   ENDIF
      *
     C*****FEFAMT        IFLT      0                                                          CLE106
     C**********         MOVE      '-'           DDESGN                                       CLE106
     C**********         ELSE                                                                 CLE106
     C**********         MOVE      ' '           DDESGN                                       CLE106
     C**********         ENDIF                                                                CLE106
     C                   SELECT                                                               CLE106
     C                   WHEN      FEFAMT < 0                                                 CLE106
     C                   EVAL      DDESGN = '-'                                               CLE106
     C                   WHEN      FEFAMT > 0                                                 CLE106
     C                   EVAL      DDESGN = '+'                                               CLE106
     C                   OTHER                                                                CLE106
     C                   EVAL      DDESGN = ' '                                               CLE106
     C                   ENDSL                                                                CLE106
      *
     C                   Z-ADD     FEPSTD        DAYNO
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDEPSD
      *
     C                   Z-ADD     FEPEND        DAYNO
     C                   EXSR      CVTDAT
     C     ZDATE         IFEQ      0
     C                   MOVE      *BLANKS       DDEPED
     C                   ELSE
     C                   MOVEL(P)  ZDATE         DDEPED
     C                   ENDIF
      *
     C                   MOVE      FEPYON        DDEPON
     C                   MOVE      FEAUTO        DDEADV
     C                   MOVE      FECALT        DDCALT
      *
     C     FEFRT1        IFEQ      0
     C     FEFRT2        ANDEQ     0
     C                   MOVE      *BLANKS       DDRTE1
     C                   ELSE
     C                   EVAL      ZFLD15=FEFRT1*100000
     C                   EVAL      ZDECS=5
     C                   EXSR      FMTAMT
     C**********         EVAL      DDRTE1= %SUBST(ZOUT21:14:8)                                237464
     C                   EVAL      DDRTE1= %SUBST(ZOUT21:13:8)                                237464
     C                   ENDIF
      *
     C     FEFRT2        IFEQ      0
     C                   MOVE      *BLANKS       DDRTE2
     C                   ELSE
     C                   EVAL      ZFLD15=FEFRT2*100000
     C                   EVAL      ZDECS=5
     C                   EXSR      FMTAMT
     C**********         EVAL      DDRTE2= %SUBST(ZOUT21:14:8)                                237464
     C                   EVAL      DDRTE2= %SUBST(ZOUT21:13:8)                                237464
     C                   ENDIF
      *
     C     FEFRT3        IFNE      0
     C                   EVAL      ZFLD15=FEFRT3*100000
     C                   EVAL      ZDECS=5
     C                   EXSR      FMTAMT
     C**********         EVAL      DDRTE3= %SUBST(ZOUT21:14:8)                                237464
     C                   EVAL      DDRTE3= %SUBST(ZOUT21:13:8)                                237464
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE3
     C                   ENDIF
      *
     C     FEFRT4        IFNE      0
     C                   EVAL      ZFLD15=FEFRT4*100000
     C                   EVAL      ZDECS=5
     C                   EXSR      FMTAMT
     C**********         EVAL      DDRTE4= %SUBST(ZOUT21:14:8)                                237464
     C                   EVAL      DDRTE4= %SUBST(ZOUT21:13:8)                                237464
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE4
     C                   ENDIF
      *
     C     FEFRT5        IFNE      0
     C                   EVAL      ZFLD15=FEFRT5*100000
     C                   EVAL      ZDECS=5
     C                   EXSR      FMTAMT
     C**********         EVAL      DDRTE5= %SUBST(ZOUT21:14:8)                                237464
     C                   EVAL      DDRTE5= %SUBST(ZOUT21:13:8)                                237464
     C                   ELSE
     C                   MOVE      *BLANKS       DDRTE5
     C                   ENDIF
      *
     C     FEAMT1        IFEQ      0
     C                   MOVE      *BLANKS       DDFAMT1
     C                   MOVE      *BLANKS       DDFAMT2
     C                   MOVE      *BLANKS       DDFAMT3
     C                   MOVE      *BLANKS       DDFAMT4
     C                   MOVE      *BLANKS       DDFAMT5
     C                   ELSE
     C     FEPIND        IFEQ      'A'
     C                   Z-ADD     0             ZDECS
     C                   ENDIF
     C     FEPIND        IFEQ      'P'
     C                   Z-ADD     3             ZDECS
     C                   ENDIF
     C                   Z-ADD     FEAMT1        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT1
      *
     C     FEAMT2        IFNE      0
     C                   Z-ADD     FEAMT2        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT2
     C                   ELSE
     C                   MOVE      *BLANKS       DDFAMT2
     C                   ENDIF
      *
     C     FEAMT3        IFNE      0
     C                   Z-ADD     FEAMT3        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT3
     C                   ELSE
     C                   MOVE      *BLANKS       DDFAMT3
     C                   ENDIF
      *
     C     FEAMT4        IFNE      0
     C                   Z-ADD     FEAMT4        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT4
     C                   ELSE
     C                   MOVE      *BLANKS       DDFAMT4
     C                   ENDIF
      *
     C     FEAMT5        IFNE      0
     C                   Z-ADD     FEAMT5        ZFLD15
     C                   EXSR      FMTAMT
     C                   MOVE      ZOUT21        DDFAMT5
     C                   ELSE
     C                   MOVE      *BLANKS       DDFAMT5
     C                   ENDIF
     C                   ENDIF
      *
     C     FECALC        IFEQ      0
     C                   MOVE      *BLANKS       DDCALC
     C                   ELSE
     C                   MOVE      FECALC        DDCALC
     C                   ENDIF
      *
     C     FEERAT        IFEQ      0
     C                   MOVE      *BLANKS       DDEXRT
     C                   ELSE
     C                   EVAL      ZFLD15=FEERAT*100000000
     C                   EVAL      ZDECS=8
     C                   EXSR      FMTAMT
     C                   EVAL      DDEXRT= %SUBST(ZOUT21:9:12)
     C                   ENDIF
      *
     C                   MOVE      FEMDIN        DDMDIN
      *
     C     FENPYD        IFEQ      0
     C                   MOVE      *BLANKS       DDNPYD
     C                   ELSE
     C                   Z-ADD     FENPYD        DAYNO
     C                   EXSR      CVTDAT
     C                   MOVEL(P)  ZDATE         DDNPYD
     C                   ENDIF
      *
     C     FEDYIM        IFEQ      0
     C                   MOVE      *BLANKS       DDDYIM
     C                   ELSE
     C                   MOVE      FEDYIM        DDDYIM
     C                   ENDIF
     C                   MOVE      FEFREQ        DDFREQ
     C***                MOVE      FEPIND        WPIND                                       ???
     C                   MOVE      SHFI          DDESHR
     C                   MOVE      FEPRFC        DDPRFC
     C                   MOVE      FEMASF        DDMASF                                       CLE106
      *
      * If DDESHR (Shared fee indicator) is blank, default to 'N'.
     C     DDESHR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDESHR
     C                   ENDIF
      *
     C     FECALT        IFEQ      '03'
     C     FECALT        OREQ      '06'
     C     FECALT        OREQ      '13'
     C     FECALT        OREQ      '16'
     C     FECALT        OREQ      '21'
     C     FECALT        OREQ      '22'
     C                   MOVE      *BLANKS       DDPIND
     C                   ELSE
     C                   MOVE      FEPIND        DDPIND
     C                   ENDIF
      *
      * Fee status
     C     DDACTN        IFNE      'I'

     C     FERECI        IFNE      'M'
     C     FERECI        ANDNE     'R'

     C                   SELECT
     C     FSTS          WHENEQ    'C'
     C                   MOVEL     'LER0194'     ZAMSID
     C     FSTS          WHENEQ    'R'
     C                   MOVEL     'LER0195'     ZAMSID
     C     FSTS          WHENEQ    'A'
     C                   MOVEL     'LER0196'     ZAMSID
     C     FSTS          WHENEQ    'D'
     C                   MOVEL     'LER0197'     ZAMSID
     C                   ENDSL
      *
     C                   ELSE

     C                   SELECT
     C     FERECI        WHENEQ    'M'
     C                   MOVEL     'LER0198'     ZAMSID
     C     FERECI        WHENEQ    'R'
     C                   MOVEL     'LER0197'     ZAMSID
     C                   ENDSL

     C                   ENDIF

     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *
     C                   ELSE
     C                   MOVE      *BLANK        DDSTAT
     C                   ENDIF
      *                                                                                       CAS019
      ** Amortised Seperately Indicator                                                       CAS019
     C                   MOVEL (P) FEAMRI        DDAMRI                                       CAS019
      *                                                                                       CAS019
      ** Amortisation Start Period                                                            CAS019
     C                   Z-ADD     FESTPD        DAYNO                                        CAS019
     C                   EXSR      CVTDAT                                                     CAS019
     C                   IF        (ZDATE = *ZEROS)                                           CAS019
     C                   MOVEL     *BLANKS       DDSTPD                                       CAS019
     C                   ELSE                                                                 CAS019
     C                   MOVEL (P) ZDATE         DDSTPD                                       CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
      ** Amortisation End Period                                                              CAS019
     C                   Z-ADD     FEENPD        DAYNO                                        CAS019
     C                   EXSR      CVTDAT                                                     CAS019
     C                   IF        (ZDATE = *ZEROS)                                           CAS019
     C                   MOVEL     *BLANKS       DDENPD                                       CAS019
     C                   ELSE                                                                 CAS019
     C                   MOVEL (P) ZDATE         DDENPD                                       CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   EVAL      DDCAPI = FECAPI                                            CLE139
      *
      **  Set up Fee type
      *
     C                   EXSR      SRFTYP
      *
                                                                                              CLE134
      ** If Past Due Call Loan Processing Present;                                            CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
                                                                                              CLE134
      ** Past Due Call Loan.                                                                  CLE134
                                                                                              CLE134
     C                   EVAL      DDPLNR      = *BLANKS                                      CLE134
     C                   EVAL      DDFAMU      = *BLANKS                                      CLE134
     C                   EVAL      DDRIDT      = *BLANKS                                      CLE134
     C                   EVAL      DDRCAT      = *BLANKS                                      CLE134
     C                   EVAL      DDBIDT      = *BLANKS                                      CLE134
     C                   EVAL      DDBCAT      = *BLANKS                                      CLE134
                                                                                              CLE134
      ** Retrieve Past Due Loan for Fee.                                                      CLE134
                                                                                              CLE134
     C                   EVAL      Kpd_LNRF    = FEPLNR                                       CLE134
     C     KCLOAN        CHAIN(E)  CLOAN                                                      CLE134
                                                                                              CLE134
     C                   IF        %FOUND(CLOAN)                                              CLE134
     C                   MOVE      FEPLNR        DDPLNR                                       CLE134
                                                                                              CLE134
      ** Reporting Facility Amount Utilisation.                                               CLE134
                                                                                              CLE134
     C                   EVAL      DDFAMU      = pd_FAMU                                      CLE134
                                                                                              CLE134
      ** Reporting Past Due Initial Date.                                                     CLE134
                                                                                              CLE134
     C                   IF        FERIDT     <> 0                                            CLE134
     C                   MOVE      FERIDT        ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVE      ZDateFmt6     DDRIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Reporting Past Due Classification.                                                   CLE134
                                                                                              CLE134
     C                   EVAL      DDRCAT      = %CHAR(FERCAT)                                CLE134
                                                                                              CLE134
      ** Basel II Past Due Initial Date.                                                      CLE134
                                                                                              CLE134
     C                   IF        FEBIDT     <> 0                                            CLE134
     C                   MOVE      FEBIDT        ZDateNum                                     CLE134
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE134
     C                   CALL      'ZDATE2'                                                   CLE134
     C                   PARM                    ZDateNum          5 0                        CLE134
     C                   PARM                    ZDateFmtInd       1                          CLE134
     C                   PARM                    ZDateFmt6         6 0                        CLE134
     C                   PARM                    ZDateFmt7         7                          CLE134
                                                                                              CLE134
     C                   MOVE      ZDateFmt6     DDBIDT                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Basel II Past Due Classification.                                                    CLE134
                                                                                              CLE134
     C                   EVAL      DDBCAT      = %CHAR(FEBCAT)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Suspense Fields Initialised.                                                         CLE134
                                                                                              CLE134
     C                   EVAL      DDFSFA      = *BLANKS                                      CLE134
     C                   EVAL      DDSFA       = *BLANKS                                      CLE134
     C                   EVAL      DDSFAM      = *BLANKS                                      CLE134
     C                   EVAL      DDSFP       = *BLANKS                                      CLE134
     C                   EVAL      DDSFPM      = *BLANKS                                      CLE134
     C                   EVAL      DDFPPA      = *BLANKS                                      CLE134
     C                   EVAL      DDPSIN      = *BLANKS                                      CLE134
     C                   EVAL      DDPSLM      = *BLANKS                                      CLE134
     C                   EVAL      DDFEMC      = *BLANKS                                      CLE134
                                                                                              CLE134
      ** Suspended Fee Amount.                                                                CLE134
                                                                                              CLE134
     C                   IF        FESFA      <> 0                                            CLE134
     C                   EVAL      ZFLD15      = FESFA                                        CLE134
     C                   EVAL      ZDECS       = A6NBDP                                       CLE134
     C                   EXSR      FMTAMT                                                     CLE134
     C                   EVALR     DDSFA       = ZOUT21                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Suspended Fee Payments.                                                              CLE134
                                                                                              CLE134
     C                   IF        FESFP      <> 0                                            CLE134
     C                   EVAL      ZFLD15      = FESFP                                        CLE134
     C                   EVAL      ZDECS       = 0                                            CLE134
     C                   EXSR      FMTAMT                                                     CLE134
     C                   EVALR     DDSFP       = ZOUT21                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Suspend Fee Allowed.                                                                 CLE134
                                                                                              CLE134
     C                   IF        FEFSFA      = *BLANKS                                      CLE134
                                                                                            AR318270
     C                   IF        AUFSFA      = *BLANKS                                    AR318270
     C                   EVAL      DDFSFA      = 'N'                                        AR318270
     C                   ELSE                                                               AR318270
     C                   EVAL      DDFSFA      = AUFSFA                                       CLE134
     C                   ENDIF                                                              AR318270
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DDFSFA      = FEFSFA                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Suspended Fee Amount Maximum.                                                        CLE134
                                                                                              CLE134
     C**********         IF        FEFSFA      = 'Y'                                   CLE134 262672
     C                   IF        DDFSFA      = 'Y'                                          262672
                                                                                              CLE134
     C                   IF        FESFAM      = 0                                            CLE134
     C                   EVAL      ZFLD15      = AUSFAM                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      ZFLD15      = FESFAM                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        ZFLD15     <> 0                                            CLE134
     C                   EVAL      ZDECS       = A6NBDP                                       CLE134
     C                   EXSR      FMTAMT                                                     CLE134
     C                   EVALR     DDSFAM      = ZOUT21                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Suspended Fee Payment Maximum.                                                       CLE134
                                                                                              CLE134
     C                   MOVE      *BLANKS       DDSFPM                                       263801
     C                   IF        FESFPM      = 0                                            CLE134
     C**********         EVAL      ZFLD15      = AUSFPM                                CLE134 263801
     C                   IF        AUSFPM     <> 0                                            263801
     C                             AND DDACTN = 'I'                                           263801
     C                   MOVE(P)   AUSFPM        DDSFPM                                       263801
     C                   ENDIF                                                                263801
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C**********         EVAL      ZFLD15      = FESFPM                                CLE134 263801
     C                   MOVE(P)   FESFPM        DDSFPM                                       263801
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C**********         IF        ZFLD15     <> 0                                     CLE134 263801
     C**********         EVAL      ZDECS       = 0                                     CLE134 263801
     C**********         EXSR      FMTAMT                                              CLE134 263801
     C**********         EVALR     DDSFPM      = %TRIM(ZOUT21)                         CLE134 263801
     C**********         ENDIF                                                         CLE134 263801
                                                                                              CLE134
      ** Partial Payment Allowed.                                                             CLE134
                                                                                              CLE134
     C                   IF        FEFPPA      = *BLANKS                                      CLE134
     C                   EVAL      DDFPPA      = AUFPYA                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DDFPPA      = FEFPPA                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Partial Indicator.                                                                   CLE134
                                                                                              CLE134
     C                   IF        FEPSIN      = *BLANKS                                      CLE134
     C                   EVAL      DDPSIN      = AUPSIN                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DDPSIN      = FEPSIN                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Partial Limit.                                                                       CLE134
                                                                                              CLE134
     C                   IF        FEPSLM      = 0                                            CLE134
     C                   EVAL      ZFLD15      = AUPSLM                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      ZFLD15      = FEPSLM                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        ZFLD15     <> 0                                            CLE134
     C                   IF        FEPSIN      = 'P'                                          CLE134
     C                   EVAL      ZDECS       = 0                                            CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      ZDECS       = A6NBDP                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EXSR      FMTAMT                                                     CLE134
     C**********         EVALR     DDPSLM      = ZOUT21                              CLE134 AR318270
     C                   EVALR     DDPSLM      = %TRIM(ZOUT21)                              AR318270
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Early Maturity Condition.                                                            CLE134
                                                                                              CLE134
     C                   IF        FEFEMC      = *BLANKS       AND                            CLE134
     C                             (DDFPPA     = 'Y'           OR                             CLE134
     C                              DDFPPA     = 'P')                                         CLE134
     C                   EVAL      DDFEMC      = AUFEMC                                       CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      DDFEMC      = FEFEMC                                       CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM Midas no. to DDMMYY (OR MMDDYY)    *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    DAYNO             5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      *ZEROS        ZADATE            7            Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      ZFLD15 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFTYP - Subroutine to set up Fee type                       *
      *****************************************************************
     C     SRFTYP        BEGSR
      *
     C                   MOVE      *BLANK        WPTFI             1
      *
     C     CLE004        IFEQ      'Y'
     C     DDACTN        IFEQ      'I'
     C                   ELSE
      *
     C     PTFI          IFEQ      *BLANK
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0202'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      '1'           *IN52
     C                   ENDIF
      *
     C     PTFI          IFEQ      'P'
     C     PTFI          OREQ      'S'                                                        CLE106
     C     PTFI          OREQ      'R'                                                        CLE106
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0203'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      '1'           *IN52
     C                   ENDIF
      *
     C     PTFI          IFEQ      'I'
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVEL     'LER0204'     ZAMSID
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDFETP
     C                   MOVE      '0'           *IN52
     C                   ENDIF
      *
     C                   MOVE      PTFI          WPTFI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN ACCOUNT FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        CrFeScnFmt
     C                   MOVEL     ##ACTN        DDACTN
      *
      ** Get the currency decimal places of Fee ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FEFCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @RTCD         RetCodeIn                                    CAP084
     C                   MOVEL     FEFCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      *PSSR                                        ************
     C                   END
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   MOVE      FEFCOD        P@FCOD                                       CLE134
                                                                                              CLE134
     C                   CALL      'AOFEER0'                                                  CLE134
     C                   PARM      '*BLANKS'     @RTCD                                        CLE134
     C                   PARM      '*KEY   '     @OPTN                                        CLE134
     C                   PARM                    P@FCOD                                       CLE134
     C     SDFEE         PARM      SDFEE         DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C                   EVAL      DBFILE      = 'SDFEEPD'                                    CLE134
     C                   EVAL      DBKEY       = 'CLE134'                                     CLE134
     C                   EVAL      DBASE       = 003                                          CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *
      ** Determine if CLE004 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE004            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE004
     C                   ENDIF
      *
      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Fee in file formats
     C                   PARM                    CrFeFilFmt
      *
      * Loan in file formats
     C                   PARM                    ClilFilFmt
      *
      * Fclty in file formats
     C                   PARM                    FacmFilFmt
      *
      * CLE006
     C                   PARM                    CLE006            1
      *
      * Fee against a syndicated facility/loan
     C                   PARM                    WSYND             1
      *
      * Output parameters
      *
      * Fee in screen format
     C                   PARM                    CrFeScnFmt
      *
      * Participant Fee indicator
     C                   PARM                    WPTFI
      *
      ** Initialize program name
      *
     C                   MOVEL     'LEFEEMCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @RTCD         RetCodeIn                                    CAP084
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                                       242377
      ** Check System Value: Use Original Borrower or Purchased From?                         242377
      ** Set up parameter so access object checks LoanCustOriginPurch                         242377
     C                   MOVE      *BLANKS       WPARM                                        242377
     C                   MOVEL     'LoanC'       WPARM1                                       242377
     C                   MOVEL     'ustOr'       WPARM2                                       242377
     C                   MOVEL     'iginP'       WPARM3                                       242377
     C                   MOVEL     'urch'        WPARM4                                       242377
     C                   MOVEL     WPARM         SVALK1                                       242377
      *                                                                                       242377
      * Call Access object:                                                                   242377
     C                   CALL      'AOSVALR0'                                                 242377
     C                   PARM                    RTNCDE            7                          242377
     C                   PARM                    SVALK1           20                          242377
     C                   PARM                    SVAL1           200                          242377
     C                   PARM                    SVALK2           20                          242377
     C                   PARM                    SVAL2           200                          242377
     C                   PARM                    SVALK3           20                          242377
     C                   PARM                    SVAL3           200                          242377
     C                   PARM                    SVALK4           20                          242377
     C                   PARM                    SVAL4           200                          242377
     C                   PARM                    SVALK5           20                          242377
     C                   PARM                    SVAL5           200                          242377
     C                   PARM                    SVALK6           20                          242377
     C                   PARM                    SVAL6           200                          242377
     C                   PARM                    SVALK7           20                          242377
     C                   PARM                    SVAL7           200                          242377
     C                   PARM                    SVALK8           20                          242377
     C                   PARM                    SVAL8           200                          242377
     C                   PARM                    SVALK9           20                          242377
     C                   PARM                    SVAL9           200                          242377
     C                   PARM                    SVALK0           20                          242377
     C                   PARM                    SVAL10          200                          242377
      *                                                                                       242377
      * If the system value is not found then issue a database error                          242377
     C     RTNCDE        IFNE      '        '                                                 242377
     C                   MOVEL     'SDSVALPD'    DBFILE                         ************* 242377
     C                   MOVEL     '902'         DBASE                          * DBERR 902 * 242377
     C                   MOVEL     '*FIRST  '    DBKEY                          ************* 242377
     C                   EXSR      *PSSR                                                      242377
     C                   ELSE                                                                 242377
      *                                                                                       242377
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              242377
     C                   MOVEL     SVAL1         WRK01             1                          242377
     C     WRK01         IFEQ      'O'                                                        242377
     C                   MOVE      'O'           PPCUST            1                          242377
     C                   ELSE                                                                 242377
     C                   MOVE      'P'           PPCUST                                       242377
     C                   ENDIF                                                                242377
     C                   ENDIF                                                                242377
      *
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS       AND                            CLE134
     C                             @RTCD      <> '*NRF   '                                    CLE134
     C                   EVAL      DBFILE      = 'SCSARDPD'                                   CLE134
     C                   EVAL      DBKEY       = 'CLE134'                                     CLE134
     C                   EVAL      DBASE       = 002                                          CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        @RTCD       = *BLANKS                                      CLE134
     C                   EVAL      CLE134      = 'Y'                                          CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134      = 'N'                                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR
      *****************************************************************
     C/SPACE                                                                                  CLE134
      *****************************************************************                       CLE134
      * @DEFN: Definition Rountine.                                                           CLE134
      *****************************************************************                       CLE134
     C     @DEFN         BEGSR                                                                CLE134
                                                                                              CLE134
      ** Key List...                                                                          CLE134
                                                                                              CLE134
     C     KCLOAN        KLIST                                                                CLE134
     C                   KFLD                    Kpd_LNRF                                     CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
