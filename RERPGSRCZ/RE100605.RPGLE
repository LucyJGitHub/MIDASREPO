     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Shadow Post an Entry in Transit')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100605 - Shadow Post an Entry in Transit                   *
      *                                                               *
      *  Function:  This program shadow post an entry in transit      *
      *  (I/C and CoB)                                                *
      *                                                               *
      *  Called By:                                                   *
      *  I/C and CoB                                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP205             Date 08Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008   *CREATE   Date 22Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CRE026 - Consumer Banking                                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      ** GL Account Movements
     FRSACMTPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** RE Shadow Balances
     FMEMOSL1   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Nostro Details by Account Key
     FSDNOSTL4  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   81  - Record not found                                      *
      *   82  - Error on update                                       *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *  SRACMT - Update Shadow Postings file                         *
      *  SRMEMO - Update Shadow Balances file                         *
      *  SRPRON - Update Projected Nostro Balances file               *
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Input Entry
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     D ACCID           DS
     D  K_CUST                 1      6
     D**K_CNUM**               1      6S 0                                                    CSD027
     D  K_CNUM                 1      6A                                                      CSD027
     D  K_CCY                  7      9
     D***K_ACCD*               10     13                                                      CGL029
     D***K_ACOD*               10     13S 0                                                   CGL029
     D***K_ACSQ*               14     15S 0                                                   CGL029
     D***K_BRCA*               16     18                                                      CGL029
     D  K_ACCD                10     19                                                       CGL029
     D  K_ACOD                10     19S 0                                                    CGL029
     D  K_ACSQ                20     21S 0                                                    CGL029
     D  K_BRCA                22     24                                                       CGL029
 
     D  @SARD          S              6A                                                      CAP205
     D  CAP205         S              1A                                                      CAP205
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      **  Clear output parameters
 
     C                   RESET                   X_RTCD
 
      **  Update RSACMTPD
 
     C                   EXSR      SRACMT
 
      **  Update MEMOS
 
     C     E_VALD        IFLT      BJDNWD
     C                   EXSR      SRMEMO
     C                   ENDIF
 
      **  Update PRONO
 
     C                   EXSR      SRPRON
 
      **  End Program and Return.
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Update Shadow Postings file
      *****************************************************************
     C     SRACMT        BEGSR
 
     C**********         Z-ADD     E_CNUM        CUSN                                         CSD027
     C                   EVAL      CUSN = E_CNUM                                              CSD027
     C                   MOVEL     E_CCY         CCYD
     C                   Z-ADD     E_ACOD        ACDE
     C                   Z-ADD     E_ACSQ        ASNC
     C                   MOVEL     E_BRCA        BRCA
     C                   Z-ADD     E_PSTD        PTDT
     C                   Z-ADD     E_VALD        VUDT
     C                   MOVEL     E_PNAR        NRTD
     C                   MOVEL     E_DLREF       TNMR
     C                   Z-ADD     E_CHQN        CQNR
     C                   Z-ADD     E_PSTA        MVAM
     C                   Z-ADD     E_DRCR        DORC
     C                   MOVE      E_OTRF        FUND
     C                   MOVE      E_XRFI        XRFI
     C                   Z-ADD     E_XRFN        XRFN
 
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   EVAL      CMOD = 'RE'                                                CAP205
     C                   EVAL      MTYP = 'S'                                                 CAP205
     C                   ELSE                                                                 CAP205
     C                   EVAL      CMOD = *BLANKS                                             CAP205
     C                   EVAL      MTYP = *BLANKS                                             CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   WRITE     RSACMTPO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update Shadow Balances file
      *****************************************************************
     C     SRMEMO        BEGSR
 
     C**********         Z-ADD     E_CNUM        K_CNUM                                       CSD027
     C                   EVAL      K_CNUM = E_CNUM                                            CSD027
     C                   MOVEL     E_CCY         K_CCY
     C                   Z-ADD     E_ACOD        K_ACOD
     C                   Z-ADD     E_ACSQ        K_ACSQ
     C                   MOVEL     E_BRCA        K_BRCA
 
      * Access shadow balance
 
     C     K_ACCID       CHAIN     MEMOSL1                            81
 
     C     *IN81         IFEQ      *OFF
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        LDBLN
     C                   ADD       E_PSTA        CLBLN
     C                   ELSE
     C                   SUB       E_PSTA        LDBLN
     C                   SUB       E_PSTA        CLBLN
     C                   ENDIF
 
     C                   UPDATE    MEMOSMDF                             82
     C     *IN82         IFEQ      *ON
     C                   EVAL      X_ERMS = 'MEMOS NOT UPDATED:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Update Projected Nostro Balances file
      *****************************************************************
     C     SRPRON        BEGSR
 
     C**********         Z-ADD     E_CNUM        K_CNUM                                       CSD027
     C                   EVAL      K_CNUM = E_CNUM                                            CSD027
     C                   MOVEL     E_CCY         K_CCY
     C                   Z-ADD     E_ACOD        K_ACOD
     C                   Z-ADD     E_ACSQ        K_ACSQ
     C                   MOVEL     E_BRCA        K_BRCA
 
     C     K_ACCIDX      CHAIN     SDNOSTL4                           81
 
      * If account is a nostro
 
     C     *IN81         IFEQ      *OFF
 
     C                   MOVEL     A7CYCD        W0KEY#
     C                   MOVE      A7NONB        W0KEY#
     C                   Z-ADD     E_VALD        W0VDAT
     C     E_DRCR        IFEQ      0
     C                   Z-ADD     E_PSTA        W0AMT
     C                   ELSE
     C                   Z-SUB     E_PSTA        W0AMT
     C                   ENDIF
 
      * Update projected nostro balances
 
     C                   CALL      'AOPRONU0'
     C                   PARM      *BLANK        W0RTN             7            B: Error Code
     C                   PARM                    W0KEY#            5            I: Nostro key
     C                   PARM                    W0VDAT            5 0          I: VDate
     C                   PARM                    W0AMT            15 0          I: Amount
 
     C     W0RTN         IFEQ      '*ERROR*'
     C                   EVAL      X_ERMS = 'PRONO NOT UPDATED:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  *INZSR - Subroutine to do Program Initialisation.
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * INPUTS
      * Entry
     C                   PARM                    I_ENTRY
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Key lists
 
     C     K_ACCID       KLIST
     C                   KFLD                    K_CNUM
     C                   KFLD                    K_CCY
     C                   KFLD                    K_ACOD
     C                   KFLD                    K_ACSQ
     C                   KFLD                    K_BRCA
     C     K_ACCIDX      KLIST
     C                   KFLD                    K_CUST
     C                   KFLD                    K_CCY
     C                   KFLD                    K_ACCD
     C                   KFLD                    K_ACSQ
     C                   KFLD                    K_BRCA
 
      ** Access SAR details file to determine if CAP205 is ON.                                CAP205
                                                                                              CAP205
     C                   EVAL      CAP205 = 'N'                                               CAP205
     C                   CALLB     'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       @RTCD                                        CAP205
     C                   PARM      '*VERIFY'     @OPTN                                        CAP205
     C                   PARM      'CAP205'      @SARD                                        CAP205
      *                                                                                       CAP205
     C                   IF        @RTCD = *BLANKS                                            CAP205
     C                   EVAL      CAP205 = 'Y'                                               CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *******************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
     C/COPY ZACPYSRC,RECMPSSR
      ****************************************************************
