     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Proj Insufficient Funds Extract')             *
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE004243 - Proj Insufficient Funds Extract                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR1095876          Date 30Sep13               *
      *  Prev Amend No. AR753294           Date 03May11               *
      *                 CAP207  *CREATE    Date 10Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR753294 - Projected Insufficient Funds Report_value of      *
      *             Account Balance Check Required field is "NO" even *
      *             if it is a "Yes" (Child: AR753295)                *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10-11      Referred                                        *
      *    12-13      Blocked                                         *
      *    14         Inactive                                        *
      *    16         Liquidated                                      *
      *    17         Bad Debt                                        *
      *    U7 + U8    Error Occured                                   *
      *    LR         End Pgm                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrNegBal - Read through all records in GLACNTL3 File         *
      *  SrFwdPost - Any accounts with forward postings               *
      *  SrChkRtl - Check If CNUM/CCY/ACOD/ACSQ/BRCA is retail account*
      *  SrGetChkInd - Get Account Balance Check Required Indicator   *
      *  SrTtalResrv - Get Total reservations                         *
      *  SrHeldItems - Get Total held items amount (Hard/Soft)        *
      *  SrGetGlActInf - Get other information to GLACNTL3            *
      *  *PSSR    - Error processing                                  *
      *  *INZSR   - Initialise                                        *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FREPINFL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X_)
      ** Midas RE Proj Insufficient Funds Details
 
     FGLACNTL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Extension File
 
     FRSACMTL7  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account movements by account/value date
 
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account details - full a/c number
 
     F***REDEFDL0  IF   E           K DISK    INFSR(*PSSR)                                  AR753294
      ***Midas*RE*REDEFD*By:*Brch/Cust/Ccy/Acc*Code/Acc*Seq************                     AR753294
 
     FHELDITL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H_)
      ** Midas HELDITL1/key= cnum/ccy
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Working variables
 
     D WRUN            S              1A
     D WRtlFlg         S              1N   INZ(*Off)
     D*WABCR****       S                   LIKE(ABCR)                                       AR753294
     D WABCR           S                   LIKE(F1IABC)                                     AR753294
     D WLDBL           S                   LIKE(LDBL)
     D WCLBL           S                   LIKE(CLBL)
     D WODLN           S                   LIKE(ODLN)
     D WBCOA           S                   LIKE(BCOA)
     D WHHLDA          S                   LIKE(H_HLDA)
     D WSHLDA          S                   LIKE(H_HLDA)
     D WCNUM           S                   LIKE(CNUM)
     D WCCY            S                   LIKE(CCY)
     D WACOD           S                   LIKE(ACOD)
     D WACSQ           S                   LIKE(ACSQ)
     D WBRCA           S                   LIKE(BRCA)
     D WTOLR           S                   LIKE(F1TOLR)
     D WDAT1           S                   LIKE(F1DAT1)
     D WDAT2           S                   LIKE(F1DAT2)
     D WDAT3           S                   LIKE(F1DAT3)
     D WDAT4           S                   LIKE(F1DAT4)
     D WDAT5           S                   LIKE(F1DAT5)
     D WDAT6           S                   LIKE(F1DAT6)
     D WDAT7           S                   LIKE(F1DAT7)
     D WDAT8           S                   LIKE(F1DAT8)
     D WDAT9           S                   LIKE(F1DAT9)
     D WAVA1           S                   LIKE(F1AVA1)
     D WAVA2           S                   LIKE(F1AVA2)
     D WAVA3           S                   LIKE(F1AVA3)
     D WAVA4           S                   LIKE(F1AVA4)
     D WAVA5           S                   LIKE(F1AVA5)
     D WAVA6           S                   LIKE(F1AVA6)
     D WAVA7           S                   LIKE(F1AVA7)
     D WAVA8           S                   LIKE(F1AVA8)
     D WAVA9           S                   LIKE(F1AVA9)
     D WRERSN          S                   LIKE(X_RERSN1)
 
     D WRTREF          S             50    VARYING
     D WRTASSETAMT     S             23P 8
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read through all records in GLACNTL3 file having negative (DR) balance
 
     C                   EXSR      SrNegBal
 
      ** Any accounts with forward postings
 
     C                   EXSR      SrFwdPost
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNegBal - Read through all records in GLACNTL3 file         *
      *                                                               *
      *****************************************************************
 
     C     SrNegBal      BEGSR
 
     C     *LOVAL        SETLL     GLACNTL3
     C                   READ      GLACNTL3
     C                   DOW       Not %Eof
     C                   IF        F1AVA1 > 0 or F1AVA2 > 0 or
     C                             F1AVA3 > 0 or F1AVA4 > 0 or
     C                             F1AVA5 > 0 or F1AVA6 > 0 or
     C                             F1AVA7 > 0 or F1AVA8 > 0 or
     C                             F1AVA9 > 0
 
      ** Set values for working variables
     C                   EVAL      WCNUM = F1CNUM
     C                   EVAL      WCCY  = F1CCY
     C                   EVAL      WACOD = F1ACOD
     C                   EVAL      WACSQ = F1ACSQ
     C                   EVAL      WBRCA = F1BRCA
 
      ** Check IF CNUM/CCY/ACOD/ACSQ/BRCA is retail account
     C                   EXSR      SrChkRtl
     C                   IF        WRtlFlg = *On
 
      ** Write to extract file
 
     C                   EVAL      X_BRCA   = F1BRCA
     C                   EVAL      X_CNUM   = F1CNUM
     C                   EVAL      X_CCY    = F1CCY
     C                   EVAL      X_ACOD   = F1ACOD
     C                   EVAL      X_ACSQ   = F1ACSQ
     C                   EVAL      X_RERSN1 = 'Negative Balance'
 
      ** Get Account Balance Check Required Indicator
     C**********         EXSR      SrGetChkInd                                              AR753294
     C**********         EVAL      X_REABCR = WABCR                                         AR753294
     C                   EVAL      X_REABCR = 'N'                                           AR753294
     C                   IF        F1IABC = 'Y'                                             AR753294
     C                   EVAL      X_REABCR = 'Y'                                           AR753294
     C                   ENDIF                                                              AR753294
 
     C                   EVAL      X_LDBL   = WLDBL
     C                   EVAL      X_CLBL   = WCLBL
     C                   EVAL      X_ODLN   = WODLN
     C                   EVAL      X_RETOLR = F1TOLR
 
      ** Get Total Reservations
     C                   EXSR      SrTtalResrv
     C                   EVAL      X_RERESV = WRTASSETAMT
 
     C                   EVAL      X_RETOBC = WBCOA
 
      ** Get Total held items amount (Hard/Soft)
     C                   EXSR      SrHeldItems
     C                   EVAL      X_RETOHH = WHHLDA
     C                   EVAL      X_RETOSH = WSHLDA
 
     C                   EVAL      X_REDAT1 = F1DAT1
     C                   EVAL      X_REDAT2 = F1DAT2
     C                   EVAL      X_REDAT3 = F1DAT3
     C                   EVAL      X_REDAT4 = F1DAT4
     C                   EVAL      X_REDAT5 = F1DAT5
     C                   EVAL      X_REDAT6 = F1DAT6
     C                   EVAL      X_REDAT7 = F1DAT7
     C                   EVAL      X_REDAT8 = F1DAT8
     C                   EVAL      X_REDAT9 = F1DAT9
     C                   EVAL      X_REAVA1 = F1AVA1
     C                   EVAL      X_REAVA2 = F1AVA2
     C                   EVAL      X_REAVA3 = F1AVA3
     C                   EVAL      X_REAVA4 = F1AVA4
     C                   EVAL      X_REAVA5 = F1AVA5
     C                   EVAL      X_REAVA6 = F1AVA6
     C                   EVAL      X_REAVA7 = F1AVA7
     C                   EVAL      X_REAVA8 = F1AVA8
     C                   EVAL      X_REAVA9 = F1AVA9
     C                   WRITE     REPINFD0
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      GLACNTL3
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFwdPost - Any accounts with forward postings               *
      *                                                               *
      *****************************************************************
 
     C     SrFwdPost     BEGSR
 
      ** Initialize variables
     C                   EVAL      WCNUM = *Blanks
     C                   EVAL      WCCY  = *Blanks
     C                   EVAL      WACOD = *Zero
     C                   EVAL      WACSQ = *Zero
     C                   EVAL      WBRCA = *Blanks
 
     C     *LOVAL        SETLL     RSACMTL7
     C                   READ      RSACMTL7
     C                   DOW       Not %Eof
 
     C                   IF        WCNUM <> CUSN or WCCY  <> CCYD or
     C                             WACOD <> ACDE or WACSQ <> ASNC or
     C                             WBRCA <> BRCA
 
      ** Check if account falls under Referred/Blocked/Inactive/Bad Debt/Liquidated
     C                   EVAL      WCNUM = CUSN
     C                   EVAL      WCCY  = CCYD
     C                   EVAL      WACOD = ACDE
     C                   EVAL      WACSQ = ASNC
     C                   EVAL      WBRCA = BRCA
 
     C     KRtlAc        CHAIN     ACCNTL0
 
     C                   IF        %Found
     C                   TESTB     '0'           RETB                     10
     C                   TESTB     '1'           RETB                     11
     C                   TESTB     '2'           RETB                     12
     C                   TESTB     '3'           RETB                     13
     C                   TESTB     '4'           RETB                     14
     C                   TESTB     '6'           RETB                     16
     C                   TESTB     '7'           RETB                     17
 
     C                   IF        (*IN10 = *On or *IN11 = *On or *IN12 = *On or
     C                             *IN13 = *On or *IN14 = *On or *IN16 = *On or
     C                             *IN17 = *On) and ACNO > 0
 
      ** Get other information to GLACNTL3
     C                   EXSR      SrGetGlActInf
     C                   IF        WAVA1 <> 0 or WAVA2 <> 0 or
     C                             WAVA3 <> 0 or WAVA4 <> 0 or
     C                             WAVA5 <> 0 or WAVA6 <> 0 or
     C                             WAVA7 <> 0 or WAVA8 <> 0 or
     C                             WAVA9 <> 0
 
      ** Reported reasons
     C                   SELECT
 
      ** Referred
     C                   WHEN      *IN10 = *On or *IN11 = *On
     C                   EVAL      WRERSN = 'Referred'
      ** Blocked
     C                   WHEN      *IN12 = *On or *IN13 = *On
     C                   EVAL      WRERSN = 'Blocked'
      ** Inactive
     C                   WHEN      *IN14 = *On
     C                   EVAL      WRERSN = 'Inactive'
      ** Liquidated
     C                   WHEN      *IN16 = *On
     C                   EVAL      WRERSN = 'Liquidated'
      ** Bad Debt
     C                   WHEN      *IN17 = *On
     C                   EVAL      WRERSN = 'Bad Debt'
      ** *Blanks
     C                   OTHER
     C                   EVAL      WRERSN = *Blanks
 
     C                   ENDSL
 
     C     KAccnt        CHAIN     REPINFL0
     C                   IF        %Found
 
      ** Update extract file
 
     C                   SELECT
     C                   WHEN      X_RERSN1 = *Blanks
     C                   EVAL      X_RERSN1 = WRERSN
     C                   WHEN      X_RERSN2 = *Blanks
     C                   EVAL      X_RERSN2 = WRERSN
     C                   WHEN      X_RERSN3 = *Blanks
     C                   EVAL      X_RERSN3 = WRERSN
     C                   WHEN      X_RERSN4 = *Blanks
     C                   EVAL      X_RERSN4 = WRERSN
     C                   WHEN      X_RERSN5 = *Blanks
     C                   EVAL      X_RERSN5 = WRERSN
     C                   WHEN      X_RERSN6 = *Blanks
     C                   EVAL      X_RERSN6 = WRERSN
     C                   ENDSL
 
     C                   UPDATE    REPINFD0
     C                   ELSE
 
      ** Write to extract file
 
     C                   EVAL      X_BRCA   = BRCA
     C                   EVAL      X_CNUM   = CNUM
     C                   EVAL      X_CCY    = CCY
     C                   EVAL      X_ACOD   = ACOD
     C                   EVAL      X_ACSQ   = ACSQ
 
     C                   EVAL      X_RERSN1 = WRERSN
 
      ***Get*Account*Balance*Check*Required*Indicator**************                         AR753294
     C**********         EXSR      SrGetChkInd                                              AR753294
     C**********         EVAL      X_REABCR = WABCR                                         AR753294
 
     C                   EVAL      X_LDBL   =  LDBL
     C                   EVAL      X_CLBL   =  CLBL
     C                   EVAL      X_ODLN   =  ODLN
 
     C                   EVAL      X_RETOLR = WTOLR
 
      ** Get Total Reservations
     C                   EXSR      SrTtalResrv
     C                   EVAL      X_RERESV = WRTASSETAMT
     C
     C                   EVAL      X_RETOBC = WBCOA
 
      ** Get Total held items amount (Hard/Soft)
     C                   EXSR      SrHeldItems
     C                   EVAL      X_RETOHH = WHHLDA
     C                   EVAL      X_RETOSH = WSHLDA
     C
     C                   EVAL      X_REDAT1 = WDAT1
     C                   EVAL      X_REDAT2 = WDAT2
     C                   EVAL      X_REDAT3 = WDAT3
     C                   EVAL      X_REDAT4 = WDAT4
     C                   EVAL      X_REDAT5 = WDAT5
     C                   EVAL      X_REDAT6 = WDAT6
     C                   EVAL      X_REDAT7 = WDAT7
     C                   EVAL      X_REDAT8 = WDAT8
     C                   EVAL      X_REDAT9 = WDAT9
     C                   EVAL      X_REAVA1 = WAVA1
     C                   EVAL      X_REAVA2 = WAVA2
     C                   EVAL      X_REAVA3 = WAVA3
     C                   EVAL      X_REAVA4 = WAVA4
     C                   EVAL      X_REAVA5 = WAVA5
     C                   EVAL      X_REAVA6 = WAVA6
     C                   EVAL      X_REAVA7 = WAVA7
     C                   EVAL      X_REAVA8 = WAVA8
     C                   EVAL      X_REAVA9 = WAVA9
     C                   EVAL      X_REABCR = WABCR                                         AR753294
     C                   WRITE     REPINFD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      RSACMTL7
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkRtl - Check IF CNUM/CCY/ACOD/ACSQ/BRCA is retail account*
      *                                                               *
      *****************************************************************
 
     C     SrChkRtl      BEGSR
 
      ** Initialise variables
     C                   EVAL      WRtlFlg = *Off
     C                   EVAL      WLDBL = *Zero
     C                   EVAL      WCLBL = *Zero
     C                   EVAL      WODLN = *Zero
     C                   EVAL      WBCOA = *Zero
 
     C     KRtlAc        CHAIN     ACCNTL0
     C                   IF        %Found
 
     C                   IF        ACNO > 0
     C                   EVAL      WRtlFlg = *On
     C                   EVAL      WLDBL = LDBL
     C                   EVAL      WCLBL = CLBL
     C                   EVAL      WODLN = ODLN
     C                   EVAL      WBCOA = BCOA
     C                   ELSE
     C                   EVAL      WRtlFlg = *Off
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                     AR753294
      *****************************************************************                     AR753294
      ***SrGetChkInd*-*Get*Account*Balance*Check*Required*Indicator****                     AR753294
      *****************************************************************                     AR753294
      *****************************************************************                     AR753294
      *****************************************************************                     AR753294
     C*****SrGetChkInd   BEGSR                                                              AR753294
      *****************************************************************                     AR753294
      ** Initialise variables                                                               AR753294
     C**********         EVAL      WABCR = 'N'                                              AR753294
      *****************************************************************                     AR753294
     C*****KAccnt        CHAIN     REDEFDL0                                                 AR753294
     C**********         IF        %Found                                                   AR753294
      *****************************************************************                     AR753294
     C**********         IF        ABCR  = 'Y'                                              AR753294
     C**********         EVAL      WABCR = ABCR                                             AR753294
     C**********         ENDIF                                                              AR753294
      *****************************************************************                     AR753294
     C**********         ENDIF                                                              AR753294
      *****************************************************************                     AR753294
     C**********         ENDSR                                                              AR753294
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTtalResrv - Get Total reservations                         *
      *                                                               *
      *****************************************************************
 
     C     SrTtalResrv   BEGSR
 
     C                   EVAL      WRTREF = %Trim(F1BRCA) + %Trim(F1CNUM) +
     C                                      %Trim(F1CCY)  + %EditC(F1ACOD:'X') +
     C                                      %EditC(F1ACSQ:'X')
     C                   EVAL      WRTASSETAMT = *Zero
 
      ** Access Global Program
     C                   CALL      'GP260000'
     C                   PARM                    WRTREF
     C                   PARM                    WRTASSETAMT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHeldItems - Get Total held items amount (Hard/Soft)        *
      *                                                               *
      *****************************************************************
 
     C     SrHeldItems   BEGSR
 
      ** Initialize variables
     C                   EVAL      WHHLDA = *Zero
     C                   EVAL      WSHLDA = *Zero
 
     C     KHldItm       SETLL     HELDITL1
     C     KHldItm       READE     HELDITL1
     C                   DOW       Not %Eof
 
     C                   IF        H_ACSQ = F1ACSQ and H_BRCA = F1BRCA and
     C                             H_ACOD = F1ACOD
 
     C                   IF        H_HHIT = 'Y'
     C                   EVAL      WHHLDA = WHHLDA + H_HLDA
     C                   ELSE
     C                   EVAL      WSHLDA = WSHLDA + H_HLDA
     C                   ENDIF
 
     C                   ENDIF
 
     C     KHldItm       READE     HELDITL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetGlActInf - Get other information to GLACNTL3            *
      *                                                               *
      *****************************************************************
 
     C     SrGetGlActInf BEGSR
 
      ** Initialise variables
     C                   EVAL      WTOLR =  *Zero
     C                   EVAL      WDAT1 =  *Zero
     C                   EVAL      WDAT2 =  *Zero
     C                   EVAL      WDAT3 =  *Zero
     C                   EVAL      WDAT4 =  *Zero
     C                   EVAL      WDAT5 =  *Zero
     C                   EVAL      WDAT6 =  *Zero
     C                   EVAL      WDAT7 =  *Zero
     C                   EVAL      WDAT8 =  *Zero
     C                   EVAL      WDAT9 =  *Zero
     C                   EVAL      WAVA1 =  *Zero
     C                   EVAL      WAVA2 =  *Zero
     C                   EVAL      WAVA3 =  *Zero
     C                   EVAL      WAVA4 =  *Zero
     C                   EVAL      WAVA5 =  *Zero
     C                   EVAL      WAVA6 =  *Zero
     C                   EVAL      WAVA7 =  *Zero
     C                   EVAL      WAVA8 =  *Zero
     C                   EVAL      WAVA9 =  *Zero
 
     C     KGlAcnt       CHAIN     GLACNTL3
     C                   IF        %Found
     C
     C                   EVAL      WTOLR =  F1TOLR
     C                   EVAL      WDAT1 =  F1DAT1
     C                   EVAL      WDAT2 =  F1DAT2
     C                   EVAL      WDAT3 =  F1DAT3
     C                   EVAL      WDAT4 =  F1DAT4
     C                   EVAL      WDAT5 =  F1DAT5
     C                   EVAL      WDAT6 =  F1DAT6
     C                   EVAL      WDAT7 =  F1DAT7
     C                   EVAL      WDAT8 =  F1DAT8
     C                   EVAL      WDAT9 =  F1DAT9
     C                   EVAL      WAVA1 =  F1AVA1
     C                   EVAL      WAVA2 =  F1AVA2
     C                   EVAL      WAVA3 =  F1AVA3
     C                   EVAL      WAVA4 =  F1AVA4
     C                   EVAL      WAVA5 =  F1AVA5
     C                   EVAL      WAVA6 =  F1AVA6
     C                   EVAL      WAVA7 =  F1AVA7
     C                   EVAL      WAVA8 =  F1AVA8
     C                   EVAL      WAVA9 =  F1AVA9
     C                   EVAL      WABCR = 'N'                                              AR753294
     C                   IF        F1IABC = 'Y'                                             AR753294
     C                   EVAL      WABCR = 'Y'                                              AR753294
     C                   ENDIF                                                              AR753294
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
     C                   EVAL      DBPGM = 'RE004243'
 
      ** Keys for ACCNTL0 file
     C     KRtlAc        KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA
 
      ** Keys for REDEFDL0 and REPINFL0 files
     C     KAccnt        KLIST
     C                   KFLD                    WBRCA
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
 
      ** Keys for HELDITL1 file
     C     KHldItm       KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
 
      ** Keys for GLACNTL3 file
     C     KGlAcnt       KLIST
     C                   KFLD                    WCNUM
     C                   KFLD                    WCCY
     C                   KFLD                    WACOD
     C                   KFLD                    WACSQ
     C                   KFLD                    WBRCA
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically IF a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
