     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans cnv: file to screen DSP 1')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP1CT - Customer Loans cnv: file to screen DSPF 1        *
      *                                                               *
      *  Function:  This module converts the fields of a customer     *
      *             loan from their format as on file to a screen     *
      *             format (record format 1)                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257042             Date 09Oct08               *
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242066             Date 22Sep06               *
      *                 BUG12273           Date 25Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10671R          Date 07Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 TDA023             Date 22Mar04               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 03Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  257042 - Prevent the defaulting of DDCUST to facility custo- *
      *           mer number when authorising a parts purchased loans.*
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  242066 - Participant facility not compatible with loan type  *
      *  BUG12273 - CLIP was unable to authorise new transaction.     *
      *             Error in Customer Number.                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE106 - Syndications Manager. Added Default Sub-Participa-  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
     D                 DS
      ** Format amount returned by standard subroutine
     D  ZOUT22                 1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D LoanFilFmtCL  E DS                  EXTNAME(CLOANCL)
      ***  Loan in file Format CL
      *
     D LoanFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Loan in file Format CK
     D                                     PREFIX(K_)
      *
     D LoanScnFmt1   E DS                  EXTNAME(LECLI1PD)
      ***  Loan in Screen Format
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
      *                                                                                       CER020
      ** External DS for SAR Details                                                          CER020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER020
     D  SLCD         E                     EXTFLD(LCD)                                        CER020
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *                                                                                       CER020
      ** Parameters to ZDATE2                                                                 CER020
     D PSard           S              6A                                                      CER020
     D PZDateFmt6      S              6P 0                                                    CER020
     D PZDateFmt7      S              7A                                                      CER020
     D PZDateFmtInd    S              1A                                                      CER020
     D PZDateNum       S              5P 0                                                    CER020
      *                                                                                       CER020
     D CER020          S              1A                                                      CER020
     D CLE143          S              1A                                                      CLE143
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ***  Initialization
      *
     C                   EXSR      INIT
      *
      ***  Set output screen fields
      *
     C                   EXSR      SETFLD
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output screen fields                            *
      *****************************************************************
     C     SETFLD        BEGSR
 
      * Determine Loan type
 
     C                   EXSR      DET_LOANTYPE
      *
      ***  Loan number.
      *
     C                   MOVE      LNRF          DDLNRF
      *
      ***  Customer number
      *
     C     LoanType      IFEQ      'PTPU'
     C                   MOVEL     OLNO          DDCUST
      ***********                                                                    BUG12273 257042
      ***Override value of DDCUST, if facility customer is not blank **              BUG12273 257042
      ***********                                                                    BUG12273 257042
     C***********        If        FCUS <> *Blanks                                   BUG12273 257042
     C***********        Eval      DDCUST = FCUS                                     BUG12273 257042
     C***********        EndIf                                                       BUG12273 257042
      ***********                                                                    BUG12273 257042
     C                   ELSE
     C                   MOVEL     CNUM          DDCUST
     C                   ENDIF
      *
      ***  Facility customer number
      *
     C                   MOVE      FCUS          DDFCUS
      *
      ***  Facility type
      *
     C                   MOVE      FTYP          DDFTYP
      *
      ***  Facility sequence number
      *
     C                   MOVE      FSEQ          DDFSEQ
      *
      ***  Branch Code - Alpha
      *
     C                   MOVEL     BRCA          DDBRCA
      *
      ***  Loan type
      *
     C                   MOVEL     LTYP          DDLTYP
      *
      ***  Loan sub-type
      *
     C                   MOVEL     SUTP          DDSUTP
      *                                                                                       CLE042
      ***  Loan class                                                                         CLE042
      *                                                                                       CLE042
     C                   MOVEL     CLAS          DDCLAS                                       CLE042
      *
      ***  Originating Loan No
      ***  and Mirror Loan Number
      ***  and Purchased From
      *
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      CNUM          DDPFRM
     C*****MLNR*         IFNE      *ZEROS                                                     CLE148
     C     MLNR          IFNE      *BLANKS                                                    CLE148
     C                   MOVE      MLNR          DDMLNR
     C                   ENDIF
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      OLNO          DDOLNO
     C                   ENDSL
      *
      ***  Currency code
      *
     C                   MOVEL     CCY           DDCURR
      *
      ***  Current principal amount
      *
     C                   MOVEL     CCY           @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CPAM          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'L'           ZECODE
     C                   EXSR      ZFRPED
     C     ZNEG          IFEQ      '-'
     C                   MOVE      ZOUT21        DDCPAM
     C                   ELSE
     C                   MOVE      ZOUT20        DDCPAM
     C                   ENDIF
      *                                                                                       CLE031
      ***  Facility Currency principal amount                                                 CLE031
      *                                                                                       CLE031
     C                   MOVEL     FCCY          DDFCCY                                       CLE031
     C                   MOVEL     FCCY          @CURR                                        CLE031
     C                   CALLB     'AOCURRR0'                                                 CLE031
     C                   PARM      *BLANK        @RTCD                                        CLE031
     C                   PARM      '*KEY   '     @OPTN                                        CLE031
     C                   PARM                    @CURR                                        CLE031
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE031
      *                                                                                       CLE031
     C     @RTCD         IFNE      *BLANKS                                                    CLE031
     C                   MOVEL     @CURR         DBKEY                                        CLE031
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '003'         DBASE                          * DBERR 003 * CLE031
     C                   EXSR      *PSSR                                        ************* CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFLD15                                       CLE031
     C                   MOVE      FPAM          ZFLD15                                       CLE031
     C                   Z-ADD     A6NBDP        ZDECS                                        CLE031
     C                   MOVE      'L'           ZECODE                                       CLE031
     C                   EXSR      ZFRPED                                                     CLE031
     C     ZNEG          IFEQ      '-'                                                        CLE031
     C                   MOVE      ZOUT21        DDFPAM                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      ZOUT20        DDFPAM                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Deal date
      *
     C                   MOVE      DDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDDDAT
      *
      ***  Auto settlement indicator
      *
     C                   MOVEL     AUTO          DDAUTO
      *
      ***  Value date
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVDAT
      *
      ***  Recourse indicator
      *
     C                   MOVEL     RCSI          DDRCSI
      *
      ***  Maturity date
      *
     C     MDAT          IFNE      *ZERO
     C                   MOVE      MDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDMDAT
     C                   ENDIF
      *
      ***  Automatic Pay at Maturity
      *
     C                   MOVEL     APMI          DDAPMI
      *
      ***  Multi-ccy Rollover Allowed
      *
     C                   MOVEL     MCRA          DDMCRA
      *
      ***  Rollover date
      *
     C     RLDT          IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDRLDT
     C                   ELSE
     C                   MOVE      RLDT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDRLDT
     C                   ENDIF
      *
      ***  Rollover frequency
      *
     C                   MOVEL     RLFQ          DDRLFQ
      *
      ***  Rollover day
      *
     C     RLDY          IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDRLDY
     C                   ELSE
     C                   MOVE      RLDY          DDRLDY
     C                   ENDIF
      *
      ***  Rollover Rate Fixing Days
      *
     C                   MOVEL     RFDY          DDRFDY
      *
      ***  Default Part. Loan Type
      *
     C                   MOVEL     DFTP          DDDFTP
      *
      ***  Default Part. Loan Subtype
      *
     C                   MOVEL     DFST          DDDFST
      *                                                                                       CLE042
      ***  Default Part. Loan Class                                                           CLE042
      *                                                                                       CLE042
     C                   MOVEL     DFCL          DDDFCL                                       CLE042
      *                                                                                       CLE106
      ***  Default Sub-Part. Loan Type                                                        CLE106
      *                                                                                       CLE106
     C                   MOVEL     SLTP          DDSLTP                                       CLE106
      *                                                                                       CLE106
      ***  Default Sub-Part. Loan Subtype                                                     CLE106
      *                                                                                       CLE106
     C                   MOVEL     SLST          DDSLST                                       CLE106
      *                                                                                       CLE042
      ***  Default Sub-Part. Loan Class                                                       CLE042
      *                                                                                       CLE042
     C                   MOVEL     SLCL          DDSLCL                                       CLE042
      *                                                                                       242066
      ** Linked to Part. Facility Ind                                                         242066
      *                                                                                       242066
     C                   MOVEL     LPFI          DDLPFI                                       242066
      *
      ***  Linked to Syndicate
      *
     C                   MOVEL     LNKS          DDLNKS
      *
      ***  Participant Facility Customer
      *
     C*****PTFC*         IFNE      *ZEROS                                                     CSD027
     C     PTFC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      PTFC          DDPTFC
      *
      ***  Participant Facility Number
      *
     C                   MOVE      PTFN          DDPTFN
      *
      ***  Participant Facility Type
      *
     C                   MOVE      PTFT          DDPTFT
     C                   ENDIF
      *
      ***  Assignment/ Participant
      *
     C                   MOVE      GASS          DDASSN
      *                                                                                       CLE034
      ***  Settlement Allocation                                                              CLE034
      *                                                                                       CLE034
     C                   MOVE      STAL          DDSTAL                                       CLE034
      *                                                                                       CER020
      ** Initial Start and Final Maturity Date                                                CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      PZDateFmtInd = BJDFIN                                      CER020
      *                                                                                       CER020
     C                   IF        ISDT <> *ZEROS                                             CER020
      *                                                                                       CER020
     C                   EVAL      PZDateNum = ISDT                                           CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE2'                                                   CER020
     C                   PARM                    PZDateNum                                    CER020
     C                   PARM                    PZDateFmtInd                                 CER020
     C                   PARM                    PZDateFmt6                                   CER020
     C                   PARM                    PZDateFmt7                                   CER020
      *                                                                                       CER020
     C                   MOVEL     PZDateFmt6    DDISDT                                       CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      DDISDT = *BLANKS                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        FMDT <> *ZEROS                                             CER020
      *                                                                                       CER020
     C                   EVAL      PZDateNum = FMDT                                           CER020
      *                                                                                       CER020
     C                   CALLB     'ZDATE2'                                                   CER020
     C                   PARM                    PZDateNum                                    CER020
     C                   PARM                    PZDateFmtInd                                 CER020
     C                   PARM                    PZDateFmt6                                   CER020
     C                   PARM                    PZDateFmt7                                   CER020
      *                                                                                       CER020
     C                   MOVEL     PZDateFmt6    DDFMDT                                       CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      DDFMDT = *BLANKS                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *
      ***  Loan status
      *
     C                   SELECT
     C     RECI          WHENEQ    'M'
     C                   MOVEL     'LEL0496'     ZAMSID
     C     RECI          WHENEQ    'R'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'C'
     C                   MOVEL     'LEL0098'     ZAMSID
     C     LSTS          WHENEQ    'R'
     C                   MOVEL     'LEL0086'     ZAMSID
     C     LSTS          WHENEQ    'A'
     C                   MOVEL     'LEL0087'     ZAMSID
     C     LSTS          WHENEQ    'D'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'Q'                                                        CLE030
     C                   MOVEL     'LEL0124'     ZAMSID                                       CLE030
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDLSTS
     C                   MOVE      *BLANKS       ZAMSID
      *
      ** Original Contract Date                                                               CLE143
      *                                                                                       CLE143
     C                   IF        CLE143 = 'Y'                                               CLE143
     C                   MOVE      OCDT          ZDateNum                                     CLE143
     C                   MOVE      BJDFIN        ZDateFmtInd                                  CLE143
     C                   CALL      'ZDATE2'                                                   CLE143
     C                   PARM                    ZDateNum                                     CLE143
     C                   PARM                    ZDateFmtInd                                  CLE143
     C                   PARM                    ZDateFmt6                                    CLE143
     C                   PARM                    ZDateFmt7                                    CLE143
      *                                                                                       CLE143
     C                   MOVE      ZDateFmt6     DDOCDT                                       CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
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
      * DET_LOANTYPE - Determine Loan Type                            *
      *****************************************************************
     C     DET_LOANTYPE  BEGSR
 
     C                   SELECT
     C     PTYP          WHENEQ    61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      70
     C                   MOVEL     'LOAN'        LoanType
     C     PTYP          WHENEQ    64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     PTYP          OREQ      71
     C                   MOVEL     'PTPU'        LoanType
     C     PTYP          WHENEQ    66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69
     C     PTYP          OREQ      72
     C                   MOVEL     'PTSO'        LoanType          4
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZFRPED - Edit amount                                          *
      *****************************************************************
     C     ZFRPED        BEGSR
     C                   CALLB     'ZFRPED'
      *
      * INPUTS
      *
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
      *
      * OUTPUTS
      *
     C                   PARM                    ZOUT22
     C                   PARM                    ZWRK25           25
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization                                         *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Blank outputs (except for action code within loan format)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        LoanScnFmt1
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS parameters
      *
      ***  Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ***  Loan in file format CL
      *
     C                   PARM                    LoanFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    LoanFilFmtCK
      *
      ***  OUTPUT parameters
      *
      ***  Loan in screen format
      *
     C                   PARM                    LoanScnFmt1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP1CT'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   END
 
     C                   EVAL      @RTCD = *BLANKS
      *                                                                                       CER020
      ** Check for Switchable Feature CER020                                                  CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       @RTCD                                        CER020
     C                   PARM      '*VERIFY'     @OPTN                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        @RTCD = *BLANKS                                            CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   ENDIF                                                                CER020
      *
     C                   CALLB     'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       @RTCD                                        CLE143
     C                   PARM      '*VERIFY'     @OPTN                                        CLE143
     C                   PARM      'CLE143'      PSard                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
                                                                                              CLE143
     C                   IF        @RTCD = *BLANKS                                            CLE143
     C                   EVAL      CLE143 = 'Y'                                               CLE143
     C                   ELSE                                                                 CLE143
                                                                                              CLE143
     C                   EVAL      CLE143 = 'N'                                               CLE143
     C                   ENDIF                                                                CLE143
     C                   ENDSR
      *****************************************************************
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
