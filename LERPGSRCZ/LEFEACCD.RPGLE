     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee Compute for Accrued Fee to Date')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFEACCD - Compute for Fee Accrued to Date                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CLE106 *CREATE     Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FC_)
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FE_)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Fee amounts data structure
     D  @FEAMA         DS
     D  FE_FEAMT1              1     11  0
     D  FE_FEAMT2             12     22  0
     D  FE_FEAMT3             23     33  0
     D  FE_FEAMT4             34     44  0
     D  FE_FEAMT5             45     55  0
     D  FEAM                   1     55  0
     D                                     DIM(5) ASCEND
 
      * Fee rates data structure
     D  @FRTA          DS
     D  FE_FEFRT1              1      7  5
     D  FE_FEFRT2              8     14  5
     D  FE_FEFRT3             15     21  5
     D  FE_FEFRT4             22     28  5
     D  FE_FEFRT5             29     35  5
     D  FRT                    1     35  5
     D                                     DIM(5) ASCEND
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access Object Parameters
     D PRtcd           S              7
     D POptn           S              7
     D PSARD           S              6
     D PBRCA           S              3
     D PCCY            S              3
 
      ** Parameter List
     D S#CSSN          S             10
     D S#FACT          S              3
     D S#FCNO          S              2
     D S#FSEQ          S              2
     D S#ACCD          S             18
 
      ** LEFECALAV Parameters
     D FELPDT          S              5  0
     D FELADT          S              5  0
     D FEPSTD          S              5  0
     D FEPEND          S              5  0
     D FECALT          S              2
     D FECALC          S              1  0
     D FEPIND          S              1
     D FEFCCY          S              3
     D FEERAT          S             13  8
     D FEMDIN          S              1
 
      ** Working variables
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
     D WRundate        S                   LIKE(BJRDNB)
     D FcbrBranch      S              3
     D WFee            S             13  0
     D FLATAmnt        S             13  0
     D FLATDays        S              5  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      S#ACCD = *Blanks
 
     C                   EXSR      RtvFacDtl
 
     C                   EXSR      RtvFeeDtl
 
     C                   EXSR      CalFeeAccD
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      ***********************************************************
      /SPACE 5
      ***********************************************************
      **  Retrieve Facility Details                             *
      ***********************************************************
     C     RtvFacDtl     BEGSR
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
     C                   MOVEL     'A'           K#RCDT
 
     C     FCLTYK        CHAIN     FCLTYFMF
 
     C                   IF        %Found(FCLTY)
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      '       '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FC_BRCA       PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = FC_BRCA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '       '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FC_FCCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = FC_FCCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      FcbrBranch = FC_BRCA
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Retrieve Fee Details                                          *
      *****************************************************************
     C     RtvFeeDtl     BEGSR
 
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACL
     C                   MOVE      S#FCNO        K#FACL
     C**********         Z-ADD     *ZEROS        K#LOAN                                       CLE148
     C                   MOVEL     *BLANKS       K#LOAN                                       CLE148
     C                   MOVE      S#FSEQ        K#FSEQ
 
     C     FEEAK         CHAIN     LEFEEDL1                           80
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  CalFeeAccD :   Calculate Fee Accrued to Date                 *
      *****************************************************************
     C     CalFeeAccD    BEGSR
 
     C                   EVAL      WFee = *Zeros
 
      **  Non-calculated fees
      **  -------------------
 
     C                   IF        FE_FECALT = *Blanks
 
     C                   IF        FE_FEPEND < WRundate
     C                   EVAL      WFee = FE_FEFAMT
     C                   ELSE
 
      ** Do straight-line accrual to today
 
     C                   IF        FE_FEPSTD <> WRundate
 
     C                   EVAL      FLATDays = (WRundate  - FE_FEPSTD) - 1
     C                   IF        FLATDays <> *Zeros
     C     FE_FEADAT     DIV(H)    FLATDays      FLATAmnt
     C                   EVAL      FLATDays = FLATDays + 1
     C                   EVAL      FLATAmnt = FLATAmnt * FLATDays
     C                   EVAL      WFee = FLATAmnt
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WFee = FE_FEADAT
     C                   END
 
     C                   END
 
     C                   ELSE
 
      ** Calculated fees
      ** ---------------
 
     C                   IF        FE_FECALT = '01' Or
     C                             FE_FECALT = '02' Or
     C                             FE_FECALT = '03' Or
     C                             FE_FECALT = '11' Or
     C                             FE_FECALT = '12' Or
     C                             FE_FECALT = '13' Or
     C                             FE_FECALT = '21'
 
     C                   EXSR      FECALAV
     C                   EVAL      WFee = WFee + FE_FEAMTP
 
     C                   ELSE
 
      ** Actual amount Fees
      ** ------------------
 
     C                   EXSR      FECALAV
     C                   EVAL      WFee = WFee + FE_FEAMTP +
     C                                    FE_FELPAM + FE_FEADAT
 
     C                   END
 
     C                   END
 
      ** Edit fee amount
 
     C                   EVAL      ZFLD15 = WFee
     C                   EVAL      ZDECS = A6NBDP
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        S#ACCD
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     FECALAV       BEGSR
 
     C                   CALLB     'LEFECALAV'
 
      ** INPUTS
      * Return Code
      * Branch, customer, facility type, facility number
      * and fee sequence number
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    FcbrBranch
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
     C                   PARM                    S#FCNO
     C                   PARM                    S#FSEQ
 
      * Fee details
      * -----------
      * Last Payment Date
      * Last Accrual Date
      * Period Start Date
      * Period End Date
      * Fee Calculation type
      * Calculation basis
      * Percent Indicator
      * Fee currency
      * Exchange rate
      * Multiply/Divide indicator
      * Fee amounts x 5
      * Fee rates x 5
     C                   PARM      FE_FELPDT     FELPDT
     C                   PARM      FE_FELADT     FELADT
     C                   PARM      FE_FEPSTD     FEPSTD
     C                   PARM      FE_FEPEND     FEPEND
     C                   PARM      FE_FECALT     FECALT
     C                   PARM      FE_FECALC     FECALC
     C                   PARM      FE_FEPIND     FEPIND
     C                   PARM      FE_FEFCCY     FEFCCY
     C                   PARM      FE_FEERAT     FEERAT
     C                   PARM      FE_FEMDIN     FEMDIN
     C                   PARM                    @FEAMA
     C                   PARM                    @FRTA
 
      ** OUTPUTS
      * Fee amount
     C                   PARM      *Zeros        WFee
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'L'           ZECODE
     C                   PARM      *Blanks       ZOUT21
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
      ** Action, customer, facility type, facility number
      ** and fee sequence number
     C                   PARM                    S#CSSN
     C                   PARM                    S#FACT
     C                   PARM                    S#FCNO
     C                   PARM                    S#FSEQ
 
      ** OUTPUTS
     C                   PARM                    S#ACCD
 
      ** Access Bank Details
      ** ~~~~~~~~~~~~~~~~~~~
     C                   CALLB     'AOBANKR0'
     C                   PARM      '       '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST  '
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *LIKE         DEFINE    FC_CNUM       K#CNUM
     C     *LIKE         DEFINE    FC_FACT       K#FACT
     C     *LIKE         DEFINE    FC_FCNO       K#FCNO
     C     *LIKE         DEFINE    FC_RCDT       K#RCDT
     C     *LIKE         DEFINE    FE_FEFACL     K#FACL
     C     *LIKE         DEFINE    FE_FELOAN     K#LOAN
     C     *LIKE         DEFINE    FE_FEFSEQ     K#FSEQ
 
      ** Key lists
 
     C     FCLTYK        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C                   KFLD                    K#RCDT
 
     C     FEEAK         KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    K#LOAN
     C                   KFLD                    K#FSEQ
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
