     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Int contract retrv & cct/deal validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCRTV - INTERNAL CONTRACTS RETRIEVE                      *
      *              (WITH ACTION CODE VERSUS DEAL NUMBER VALIDATION  *
      *                                                               *
      *  Function:  This module retrieves an internal contract from   *
      *             the database. As it does so, it validates the     *
      *             action code and deal numbers.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CDL098             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD000091           Date 09May13               *
      *                 259924A            Date 28May09               *
      *                 259924             Date 10May09               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13830           Date 09May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8550            Date 16Jun06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7411            Date 01Jun05               *
      *                 CDL028             Date 07Feb05               *
      *                 229544             Date 15Sep04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 198665             Date 12Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL098 - Cancelled Deal Numbers                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  259924A- Amended so that system will validate front office   *
      *           ID that came from Meridian.                         *
      *  259924 - Amended so that program will check front office ID  *
      *           in all deals.                                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG13830 - Reverse failed; error with Deal Number            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7411- CDL028 fields missing from DLGHISPD (Recompile)     *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  229544 - Recompiled due to inserted fields in DLCHISPD.      *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP *
      *           ,MMDELDPP .                                         *
      *  198665 - Newly inserted backdated deal cannot be deleted.    *
      *           Remove checking if value date is less than run date.*
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FABDEALL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ABDEALP0:ABDELFOI)
     FABDEALL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ABDEALP0:ABDELAFO)
     FDLCANCI0  IF   E           K DISK    INFSR(*PSSR)                                       CDL098
      *                                                                                       CDL098
     FABCOMPLL  IF   E           K DISK    INFSR(*PSSR)
     FDEALSALL  IF   E           K DISK    INFSR(*PSSR)
     FFDDLNMLL  IF   E             DISK    INFSR(*PSSR)
     FFRNTOFCL1 IF   E           K DISK    INFSR(*PSSR)                                       259924
     F                                     RENAME(MMDELDP0:MMDELDX0)                          259924
     F                                     RENAME(MMDENBP0:MMDENBX0)                          259924
     F                                     RENAME(MMDENSP0:MMDENSX0)                          259924
     F                                     RENAME(ABDEALP0:ABDEALX0)                          259924
     F                                     RENAME(FXDEALP0:FXDEALX0)                          259924
     F                                     RENAME(DEALSDGF:DEALSGX0)                          259924
 
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
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQAccd1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
      *
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      *                                                                                       CSC011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D DealFilFmt    E DS                  EXTNAME(ABDEALPP)
      ** Deal in File Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
     D CSC011          S              1A                                                      CSC011
      ** Cancelled Deal Numbers                                                               CDL098
     D  CDL098         S              1    INZ('N')                                           CDL098
                                                                                              CDL098
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PSARD           S              6A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Temporary variable to test deal number for numeric                                 BUG13830
     D TMPDLN          S              6A   VARYING                                          BUG13830
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
                                                                                             BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C     ModeofOp      OREQ      ' '                                                       259924A
     C     FOTRID        ANDNE     ' '                                                       259924A
     C     DDACTN        ANDEQ     'I'                                                       259924A
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     ddACTNok      IFEQ      'N'
     C     ddL1DNok      OREQ      'N'
     C     ddL2DNok      OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE & DEAL NUMBERS
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     ddACTNok      IFEQ      'N'
     C     ddL1DNok      OREQ      'N'
     C     ddL2DNok      OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      VALACE
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *  (only if either deal no. is not to be generated.)
      *
     C     DDACTN        IFEQ      'I'
     C     DDL1DN        ANDNE     *BLANKS
     C     DDACTN        OREQ      'I'
     C     DDL2DN        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C                   EXSR      VALACD
     C                   END
      *
      **  Carry out no further validation if errors occurred.
      *
     C     ddACTNok      IFEQ      'N'
     C     ddL1DNok      OREQ      'N'
     C     ddL2DNok      OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ACSSEM
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I' OR 'D
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0130'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS DEAL WITH FRONT OFFICE TRANSACTION ID
      *
     C*****FOTRID        CHAIN     ABDELFOI                           99                      259924
     C     FOTRID        CHAIN     FRNTOFCL1                          99                      259924
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0102'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0103'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE MIDAS FIRST DEAL NUMBER
      *
     C                   MOVEL     JPFD38        DDL1DN
     C                   Z-ADD     JPFD38        ##FD38            6 0
 
     C                   END
     C     ModeofOp      IFEQ      '*FRONT'                                                  259924A
      *
      * FRONT OFFICE ASSOCIATED TRANSACTION ID CANNOT BE BLANK
      *
     C     FOASID        IFEQ      *BLANK
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0105'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS DEAL WITH FRONT OFFICE ASSOCIATED TRANSACTION ID
      *
     C     FOASID        CHAIN     ABDELAFO                           99
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE ASSOCIATED TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0131'     MsgIdArr(Ix)
     C**********         MOVEL     FOASID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE ASSOC. TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0104'     MsgIdArr(Ix)
     C**********         MOVEL     FOASID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOASID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOASID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID AND FRONT OFFICE
      * ASSOCIATED TRANSACTION ID MUST BE PRESENT ON THE SAME DEAL
      *
     C     JPFD38        IFNE      ##FD38
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0132'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * IF NOT INSERT, UPDATE MIDAS SECOND DEAL NUMBER
      *
     C                   MOVEL     JPSD38        DDL2DN
     C                   END
     C                   ENDIF                                                               259924A
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND DEAL NUMBERS
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Check action code is valid.
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           ddACTNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'ABM0214'     MsgIdArr(Ix)
     C                   END
      *
      * First Deal Number can't be 0's or all 9's
      *
     C     DDL1DN        IFEQ      '000000'
     C     DDL1DN        OREQ      '999999'
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0111'     MsgIdArr(Ix)
     C                   END
      *
      * Second Deal Number can't be 0's or all 9's
      *
     C     DDL2DN        IFEQ      '000000'
     C     DDL2DN        OREQ      '999999'
     C                   MOVE      'N'           ddL2DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL2DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0111'     MsgIdArr(Ix)
     C                   END
      *
      ** Check that the first deal number has been entered
      ** (unless action code is insert)
      *
     C     DDACTN        IFNE      'I'
     C     DDL1DN        ANDEQ     *BLANKS
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0111'     MsgIdArr(Ix)
     C                   END
      *
      ** Check that the first deal number is numeric if it is defined
      *
     C                   EVAL      TMPDLN = %TRIM(DDL1DN)                                   BUG13830
     C**********         TESTN                   DDL1DN               9899                  BUG13830
     C                   TESTN                   TMPDLN               9899                  BUG13830
     C     DDL1DN        IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0162'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      **  Set up the first deal number as a numeric field.
      *
     C                   MOVE      DDL1DN        @@DLNO1           6 0
      *
      ** Check that the second deal number is numeric if it is defined
      *
     C                   EVAL      TMPDLN = %TRIM(DDL2DN)                                   BUG13830
     C**********         TESTN                   DDL2DN               9899                  BUG13830
     C                   TESTN                   TMPDLN               9899                  BUG13830
     C     DDL2DN        IFNE      *BLANKS
     C     *IN98         ANDEQ     '0'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           ddL2DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL2DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0162'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      **  Set up the second deal number as a numeric field.
      *
     C                   MOVE      DDL2DN        @@DLNO2           6 0
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      ** Check record exists on LF/ABDEALLL
      *
     C     @@DLNO1       CHAIN     ABDEALP0                           99
     C   99@@DLNO1       CHAIN     ABDEALP1                           99
     C   99@@DLNO2       CHAIN     ABDEALP0                           99
     C   99@@DLNO2       CHAIN     ABDEALP1                           99
     C     *IN99         IFEQ      '1'
     C     JPDLTF        ORNE      ' '
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'ABM0125'     MsgIdArr(Ix)
     C                   END
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** If first deal number is defined
      *
     C     DDL1DN        IFNE      *BLANKS
      *
      ** Check deal does not exist on LF/DEALSALL
      *
     C     @@DLNO1       SETLL     DEALSALL                               99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0163'     MsgIdArr(Ix)
     C                   ELSE
      *                                                                                       CDL098
     C     CDL098        IFeq      'Y'                                                        CDL098
     C     @@DLNO1       Setll     DLCANCI0                               99                  CDL098
      *                                                                                       CDL098
     C     *IN99         IFeq      '1'                                                        CDL098
     C                   Move      'N'           ddL1DNok                                     CDL098
     C                   Add       1             Ix                                           CDL098
     C                   MoveL     'DDL1DN'      FldNameArr(Ix)                               CDL098
     C                   MoveL     'FXM7004'     MsgIdArr(Ix)                                 CDL098
     C                   GOTO      EVALAI                                                     CDL098
     C                   Endif                                                                CDL098
     C                   Endif                                                                CDL098
      *
      ** check deal number is in allowed range
      *
     C     @@DLNO1       IFLT      NORDLN
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0164'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
      ** If second deal number is defined
      *
     C     DDL2DN        IFNE      *BLANKS
      *
      ** Check deal does not exist on LF/DEALSALL
      *
     C     @@DLNO2       SETLL     DEALSALL                               99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           ddL2DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL2DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0163'     MsgIdArr(Ix)
     C                   ELSE
      *                                                                                       CDL098
     C     CDL098        IFeq      'Y'                                                        CDL098
     C     @@DLNO2       Setll     DLCANCI0                               99                  CDL098
      *                                                                                       CDL098
     C     *IN99         IFeq      '1'                                                        CDL098
     C                   Move      'N'           ddL2DNok                                     CDL098
     C                   Add       1             Ix                                           CDL098
     C                   MoveL     'DDL2DN'      FldNameArr(Ix)                               CDL098
     C                   MoveL     'FXM7004'     MsgIdArr(Ix)                                 CDL098
     C                   GOTO      EVALAI                                                     CDL098
     C                   Endif                                                                CDL098
     C                   Endif                                                                CDL098
      *
      ** check deal number is in allowed range
      *
     C     @@DLNO2       IFLT      NORDLN
     C                   MOVE      'N'           ddL2DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL2DN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0164'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Deal must exist
      *
     C     @@DLNO1       CHAIN     ABDEALP0                           99
     C   99@@DLNO1       CHAIN     ABDEALP1                           99          2nd.Leg deals
     C   99@@DLNO2       CHAIN     ABDEALP0                           99
     C   99@@DLNO2       CHAIN     ABDEALP1                           99          2nd.Leg deals
     C     *IN99         IFEQ      '1'
     C     JPDLTF        ORNE      ' '
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'ABM0125'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** The delete indicator must be blank
      *
     C     JPDDLT        IFNE      ' '
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDL1DN'      FldNameArr(Ix)
     C                   MOVEL     'ABM0174'     MsgIdArr(Ix)
     C**********         ELSE                                                                 198665
      *****************************************************************                       198665
      ***The*deal*can't*have*matured.**********************************                       198665
      *****************************************************************                       198665
     C*****JPFDAT        IFLT      BJRDNB                                       Mat.dat<R.dat CSC011
     C*****JPFDAT        IFLT      WRunDay                                             CSC011 198665
     C**********         MOVE      'N'           ddL1DNok                                     198665
     C**********         ADD       1             Ix                                           198665
     C**********         MOVEL     'DDL1DN'      FldNameArr(Ix)                               198665
     C**********         MOVEL     'ABM0201'     MsgIdArr(Ix)                                 198665
     C**********         END                                                                  198665
     C                   END
     C                   END
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      * This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           ddACTNok
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0292'     MsgIdArr(Ix)
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      ** If insertion
      ** Set up the booking branch code field with default value
      *
     C     DDACTN        IFEQ      'I'
      *
     C     DDBRCD        IFEQ      *BLANKS
     C                   MOVE      BRC           ZBR
     C                   MOVE      BRC           DDBRCD
     C                   ELSE
     C                   MOVE      DDBRCD        ZBR
     C                   END
      *
      ** Else, Set up the booking branch code field with value from deal
      *
     C                   ELSE
     C                   MOVE      JPMBCA        ZBR
     C                   END
      *
      ** If insertion
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Check that the branch code exists on SDBRCHPD
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCD        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           ddBRCDok
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCD'      FldNameArr(Ix)
     C                   MOVEL     'FXM0115'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDBRCD
     C                   MOVEL     A8BRCD        ZBR
     C                   END
     C                   END
      *
      ** If valid branch on insert then check user authority to
      ** action/branch, also if not insert.
      *
     C     DDACTN        IFEQ      'I'
     C     @RTCD         ANDEQ     *BLANKS
     C     DDACTN        ORNE      'I'
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    ERR               1 0
      *
      * no valid action codes for user/branch combination
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           ddACTNok
      *
      ** If insert, then branch is in error else deal number
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           ddBRCDok
     C                   ELSE
     C                   MOVE      'N'           ddL1DNok
     C                   END
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0290'     MsgIdArr(Ix)
     C                   END
      *
      * this action code invalid for user/branch combination
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           ddACTNok
      *
      ** If insert, then branch is in error else deal number
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'N'           ddBRCDok
     C                   ELSE
     C                   MOVE      'N'           ddL1DNok
     C                   END
      *
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0291'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ** By now the booking branch must be valid so if originating
      ** branch is blank, default it to the booking branch
      *
     C     DDORBR        IFEQ      *BLANKS
     C                   MOVE      DDBRCD        DDORBR
     C                   END
      *
      ** Originating branch code validation only when
      ** originating branch used flag is YES and originating
      ** branch has been entered (or set to booking branch above)
      *
     C     BKOBRU        IFEQ      'Y'
     C     DDORBR        ANDNE     *BLANKS
      *
      ** Check that originating branch code exists on SDBRCHPD
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDORBR        @BRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           ddORBRok
     C                   ADD       1             Ix
     C                   MOVEL     'DDORBR'      FldNameArr(Ix)
     C                   MOVEL     'FXM0289'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDORBR
     C                   END
     C                   END
      *
      **  If action code not E, do user/originating branch validation
      *
     C     DDACTN        IFNE      'E'
     C     BKOBUV        ANDEQ     'Y'
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      'X'
     C                   MOVE      JPORBR        ZOBRX
     C                   ELSE
     C                   MOVE      DDORBR        ZOBRX
     C                   END
      *
     C                   CALL      'ZVOBU'
     C                   PARM                    ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      * no valid origination branches for this user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           ddACTNok
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0287'     MsgIdArr(Ix)
     C                   END
      *
      * this originating branch invalid for user
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           ddACTNok
     C                   MOVE      'N'           ddL1DNok
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'FXM0288'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   DealFilFmt
     C                   MOVEL     'Y'           ddACTNok
     C                   MOVEL     'Y'           ddL1DNok
     C                   MOVEL     'Y'           ddL2DNok
     C                   MOVEL     'Y'           ddBRCDok
     C                   MOVEL     'Y'           ddORBRok
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) First Deal Number
     C                   PARM                    DDL1DN            6
      *
      * (Midas) Second Deal Number
     C                   PARM                    DDL2DN            6
      *
      * Booking branch
     C                   PARM                    DDBRCD            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      *
      * OK - Action code
     C                   PARM                    ddACTNok          1
      *
      * OK - First Deal Number
     C                   PARM                    ddL1DNok          1
      *
      * OK - Second Deal Number
     C                   PARM                    ddL2DNok          1
      *
      * OK - Booking branch
     C                   PARM                    ddBRCDok          1
      *
      * OK - Originating branch
     C                   PARM                    ddORBRok          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialize program name
      *
     C                   MOVEL     'ABINTCRTV'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS DEAL NUMBER RECORD
      *
     C     1             CHAIN     FDDLNMLL                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C     NODLTF        OREQ      '*'
     C                   MOVEL     '1     '      DBKEY
     C                   MOVEL     'FDDLNMLL'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CDL098
      ** Check if feature CDL098 is installed                                                 CDL098
      *                                                                                       CDL098
     C                   CALLB     'AOSARDR0'                                                 CDL098
     C                   PARM      *BLANKS       PRTCD                                        CDL098
     C                   PARM      '*VERIFY'     POPTN                                        CDL098
     C                   PARM      'CDL098'      PSARD                                        CDL098
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL098
                                                                                              CDL098
     C                   IF        PRTCD = *Blanks                                            CDL098
     C                   EVAL      CDL098 = 'Y'                                               CDL098
     C                   ELSE                                                                 CDL098
     C                   EVAL      CDL098 = 'N'                                               CDL098
     C                   IF        PRTCD <> '*NRF'                                            CDL098
     C                   EVAL      DBKEY = 'CDL098'                                           CDL098
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL098
     C                   EVAL      DBASE = 906                                                CDL098
     C                   EXSR      *PSSR                                                      CDL098
     C                   ENDIF                                                                CDL098
     C                   ENDIF                                                                CDL098
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
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
(c) Misys International Banking Systems Ltd. 2001
