     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compound API ext.file Initialisation Pgm')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UP000100 - Initialisation Program for :                      *
      *             Facility Extension Details Initialisation,        *
      *             Accounts Extension Details Initialisation,        *
      *             Deals Extension Details Initialisation            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CRE095             Date 25Apr14               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CLE147             Date 30Sep11               *
      *                 CER042             Date 11May11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CPK025  *CREATE    Date 03Oct06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CPK025 - Packaging changes                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** LE Facilities Extension File
     FLEFCLTLG  UF A E           K DISK    INFSR(*PSSR)
 
      ** Accounts Master Extension file
     FGLACNTL3  UF A E           K DISK    PREFIX(AX_)
     F                                     INFSR(*PSSR)
 
      ** FX/MM/FRA/IRS Extension files
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)
     F                                     INFSR(*PSSR)
 
      ** LE Customer Loans
     FCLOANM    IF   E           K DISK    INFSR(*PSSR)
 
      ** Facility Details Retrieval Index
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F1)
 
      ** SD Customer Details File
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Accounts Master File
     FACCNTAB   IF   E             DISK    PREFIX(AC_)
     F                                     INFSR(*PSSR)
 
      ** Foreign Exchange Deals File
     FFXDEALPP  IF   E             DISK    INFSR(*PSSR)
     F
 
      ** Money Market and Loans Deals File
     FMMDELDPP  IF   E             DISK    INFSR(*PSSR)
 
      ** FRA/IRS Deals File
     FDEALSDG   IF   E             DISK    PREFIX(DG_)
     F                                     INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7A
     D POptn           S              7A
 
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise the Facility Extension File
 
     C                   EXSR      SRInitFCEx
 
      ** Initialise the Accounts Extension File
 
     C                   EXSR      SRInitACEX
 
      ** Initialise the FX/MM/FRA/IRS Extension Files
 
     C                   EXSR      SRInitDLEX
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInitFCEx - Subroutine that Initialises PF/LEFCLTQD          *
      *****************************************************************
     C     SRInitFCEx    BEGSR
 
     C     *LOVAL        SETLL     FCLTYL1
 
     C                   READ      FCLTYL1                                60
 
     C                   DOW       *IN60 = *OFF
     C                   EVAL      FCXBRC = F1BRCA
     C                   MOVE      F1CNUM        FCXFCU
     C                   MOVE      F1FACT        FCXFTP
     C                   MOVE      F1FCNO        FCXFNO
 
      ** Only write if no record present
     C     FCKEY         Chain     LEFCLTD0                           99
     C                   If        *In99 = '1'
     C                   WRITE     LEFCLTD0
     C                   EndIf
     C                   READ      FCLTYL1                                60
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInitAMEX - Initialise the Account Master Extension File    *
      *****************************************************************
     C     SrInitACEX    BEGSR
 
      ** Read records then update the Accounts extension file
 
     C                   READ      ACCNTAB                                81
 
     C                   DOW       *IN81 = *OFF
 
     C                   EVAL      AX_F1CNUM = AC_CNUM
     C                   EVAL      AX_F1CCY  = AC_CCY
     C                   EVAL      AX_F1ACOD = AC_ACOD
     C                   EVAL      AX_F1ACSQ = AC_ACSQ
     C                   EVAL      AX_F1BRCA = AC_BRCA
     C                   EVAL      AX_F1FCHD = *ZERO
     C                   EVAL      AX_F1LFCD = *ZERO
     C                   EVAL      AX_F1ACBL = *ZERO
     C                   EVAL      AX_F1TEXO = *ZERO
     C                   EVAL      AX_F1TEOF = *ZERO
     C                   EVAL      AX_F1TEOC = *ZERO
 
 
      ** Only write if no record present
     C     ACKEY         Chain     GLACNTD0                           99
     C                   If        *In99 = '1'
     C                   WRITE     GLACNTD0
     C                   EndIf
     C                   READ      ACCNTAB                                81
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInitDLEX - Initialise the FX/MM/FRA/IRS Extension Files    *
      *****************************************************************
     C     SrInitDLEX    BEGSR
 
      ** Read records then update the FX Deals Extension File
 
     C                   READ      FXDEALPP                               82
 
     C                   DOW       *IN82 = *OFF
     C                   MOVE      FHDN38        DX_F1DLNO
     C                   MOVE      FHDBRC        DX_F1BRCA
 
      ** Only write if no record present
     C     DLKEY         Chain     DLDLDBD0                           99
     C                   If        *In99 = '1'
     C                   WRITE     DLDLDBD0
     C                   EndIf
     C                   READ      FXDEALPP                               82
     C                   ENDDO
 
      ** Read records then update the MM and Loans Deals Extension File
 
     C                   READ      MMDELDPP                               83
 
     C                   DOW       *IN83 = *OFF
     C                   MOVE      HKDN38        DX_F1DLNO
     C                   MOVE      HKBRCA        DX_F1BRCA
 
      ** Only write if no record present
     C     DLKEY         Chain     DLDLDCD0                           99
     C                   If        *In99 = '1'
     C                   WRITE     DLDLDCD0
     C                   EndIf
     C                   READ      MMDELDPP                               83
     C                   ENDDO
 
      ** Read records then update the FRA/IRS Deals Extension File
 
     C                   READ      DEALSDG                                84
 
     C                   DOW       *IN84 = *OFF
     C                   MOVE      DG_DLNO       DX_F1DLNO
     C                   MOVE      DG_BRCA       DX_F1BRCA
 
      ** Only write if no record present
     C     DLKEY         Chain     DLDLDGD0                           99
     C                   If        *In99 = '1'
     C                   WRITE     DLDLDGD0
     C                   EndIf
     C                   READ      DEALSDG                                84
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     ACKEY         KLIST
     C                   KFLD                    AC_CNUM
     C                   KFLD                    AC_CCY
     C                   KFLD                    AC_ACOD
     C                   KFLD                    AC_ACSQ
     C                   KFLD                    AC_BRCA
 
     C     DLKEY         KLIST
     C                   KFLD                    DX_F1DLNO
 
     C     FCKEY         KLIST
     C                   KFLD                    FCXBRC
     C                   KFLD                    FCXFCU
     C                   KFLD                    FCXFTP
     C                   KFLD                    FCXFNO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *blanks
     C                   MOVE      'Y'           WRun
     C                   DUMP
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
