     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Act/Ccy Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDFWRTRTV - FD Forward Rates Retrieve                        *
      *              (with Action Code versus Currency Validation)    *
      *                                                               *
      *  Function:  This module validates the implied action code of  *
      *             'I' against currency code.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD000091           Date 09May13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 27Oct00               *
      *                 CAP059             Date 27Oct00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD006 - Market Data Feed                                    *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFWDRT     IF   E           K DISK    INFSR(*PSSR)
                                                                                              CAP059
      * Forward Rates Details by Front Office Id                                              CAP059
     FFWDRTL1   IF   E           K DISK    INFSR(*PSSR)                                       CAP059
     F                                     RENAME(FWDRTFEF:FWDRTL1F)                          CAP059
     FSDCURRL9  IF   E           K DISK    INFSR(*PSSR)                                       CAP059
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
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
                                                                                              CAP059
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP059
     D                                     PREFIX(S_)                                         CAP059
      ** EXTERNAL DS FOR SAR DETAILS                                                          CAP059
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D FWRTFilFmt    E DS                  EXTNAME(FWDRTFE)
      ** Forward Rates record in File Format
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
      ** Obtain default branch for user
                                                                                            MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
                                                                                CAP059
      * Validate the Front Office Id if CAP059 is on                            CAP059
     C                   IF        CAP059 = 'Y'                                 CAP059
                                                                                CAP059
     C                   IF        ModeOfOp = '*FRONT'                          CAP059
     C                   EXSR      VFRNT                                        CAP059
                                                                                CAP059
      * Carry out no further validation if errors have occurred.                CAP059
                                                                                CAP059
     C                   IF        OKACTN = 'N'                                 CAP059
     C                   RETURN                                                 CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
      *
      * VALIDATE CURRENCY CODE
      *
     C                   EXSR      VAL
      *
      **  Do not carry out any further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCCY         OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
B01  C     RespMode      IFEQ      'S'                                          CAP059
B02  C     CAP059        IFEQ      'N'                                          CAP059
     C                   EXSR      SecChk                                       CAP059
X02  C                   ELSE                                                   CAP059
     C                   EVAL      ZACTN=DDACTN                                 CAP059
      *                                                                         CAP059
      ** If single branching                                                    CAP059
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING                            CAP059
      *                                                                         CAP059
B03  C     BJSBRC        IFNE      *BLANK                                       CAP059
     C     RESPMODE      ANDEQ     'S'                                          CAP059
     C                   EXSR      ACSSES                                       CAP059
E03  C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      ** If multibranching                                                      CAP059
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING                             CAP059
      *                                                                         CAP059
B03  C     BJSBRC        IFEQ      *BLANK                                       CAP059
     C     DDACTN        ANDNE     'I'                                          CAP059
     C     RESPMODE      ANDEQ     'S'                                          CAP059
     C                   EXSR      ACSSEM                                       CAP059
E03  C                   ENDIF                                                  CAP059
E02  C                   ENDIF                                                  CAP059
      *                                                                         CAP059
E01  C                   ENDIF
      *                                                                         CAP059
      **  Carry out no further validation if errors have occurred.              CAP059
      *                                                                         CAP059
     C     OKACTN        IFEQ      'N'                                          CAP059
     C                   RETURN                                                 CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      **  Carry out extra validation if CAP059 is on                            CAP059
      *                                                                         CAP059
     C                   IF        CAP059 = 'Y'                                 CAP059
      *                                                                         CAP059
      *  *--------------------------------*                                     CAP059
      *  * Validation for Action Code 'I' *                                     CAP059
      *  *--------------------------------*                                     CAP059
      *                                                                         CAP059
     C     DDACTN        IFEQ      'I'                                          CAP059
     C                   EXSR      VALACI                                       CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      *  *--------------------------------*                                     CAP059
      *  * Validation for Action Code 'E' *                                     CAP059
      *  *--------------------------------*                                     CAP059
      *                                                                         CAP059
     C     DDACTN        IFEQ      'E'                                          CAP059
     C                   EXSR      RTVFwrt                                      CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      *  *--------------------------------*                                     CAP059
      *  * Validation for Action Code 'A' *                                     CAP059
      *  *--------------------------------*                                     CAP059
      *                                                                         CAP059
     C     DDACTN        IFEQ      'A'                                          CAP059
     C                   EXSR      RTVFwrt                                      CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      *  *--------------------------------*                                     CAP059
      *  * Validation for Action Code 'D' *                                     CAP059
      *  *--------------------------------*                                     CAP059
      *                                                                         CAP059
     C     DDACTN        IFEQ      'D'                                          CAP059
     C                   EXSR      RTVFwrt                                      CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      **  Carry out no further validation if errors occurred.                   CAP059
     C     OKACTN        IFEQ      'N'                                          CAP059
     C     OKCCY         OREQ      'N'                                          CAP059
     C                   RETURN                                                 CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   ENDIF                                                  CAP059
      *
      * Return
      *
     C                   RETURN
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING                    CAP059
      *****************************************************************         CAP059
     C     ACSSES        BEGSR                                                  CAP059
      *                                                                         CAP059
      **  Check user's authority for the action.                                CAP059
      *                                                                         CAP059
     C                   CALL      'ZVACTU'                                     CAP059
     C                   PARM                    ZACTN             1            CAP059
     C                   PARM                    ERR               1 0          CAP059
      *                                                                         CAP059
      **  If action invalid for user                                            CAP059
      *                                                                         CAP059
     C     ERR           IFEQ      1                                            CAP059
     C                   MOVEL     'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   SELECT                                                 CAP059
     C                   WHEN      DDACTN='E'                                   CAP059
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)                   CAP059
     C                   WHEN      DDACTN='I'                                   CAP059
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)                   CAP059
     C                   WHEN      DDACTN='A'                                   CAP059
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)                   CAP059
     C                   WHEN      DDACTN='D'                                   CAP059
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)                   CAP059
     C                   ENDSL                                                  CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   ENDSR                                                  CAP059
      *****************************************************************         CAP059
     C/EJECT                                                                    CAP059
      *****************************************************************         CAP059
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING                     CAP059
      *****************************************************************         CAP059
     C     ACSSEM        BEGSR                                                  CAP059
      *                                                                         CAP059
      * Access default branch.                                                  CAP059
      *                                                                         CAP059
     C                   IN        ZMUSER                                       CAP059
     C                   UNLOCK    ZMUSER                                       CAP059
      *                                                                         CAP059
      **  Check user's authority for the action & Booking Branch.               CAP059
      *                                                                         CAP059
     C                   CALL      'ZVACTBU'                                    CAP059
     C                   PARM                    ZACTN             1            CAP059
     C                   PARM      DBRN          ZBR               3            CAP059
     C                   PARM                    ERR               1 0          CAP059
      *                                                                         CAP059
      **   If action invalid for user                                           CAP059
      *                                                                         CAP059
     C     ERR           IFEQ      1                                            CAP059
     C                   MOVEL     'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)                   CAP059
     C                   ELSE                                                   CAP059
     C     ERR           IFEQ      2                                            CAP059
     C                   MOVEL     'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   SELECT                                                 CAP059
     C                   WHEN      DDACTN='E'                                   CAP059
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)                   CAP059
     C                   WHEN      DDACTN='I'                                   CAP059
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)                   CAP059
     C                   WHEN      DDACTN='A'                                   CAP059
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)                   CAP059
     C                   WHEN      DDACTN='D'                                   CAP059
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)                   CAP059
     C                   OTHER                                                  CAP059
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)                   CAP059
     C                   ENDSL                                                  CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   ENDSR                                                  CAP059
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
      **********************************************************************    CAP059
      * RTVFwrt - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E' OR 'D'   CAP059
      **********************************************************************    CAP059
     C     RTVFwrt       BEGSR                                                  CAP059
                                                                                CAP059
      * Access Transaction Details from Transaction file                        CAP059
     C     DDCCY         CHAIN     FWDRT                              99        CAP059
                                                                                CAP059
      * Transaction details not found                                           CAP059
     C                   IF        *IN99 = '1' OR                               CAP059
     C                             *IN99 = '0' AND                              CAP059
     C                             RECI <> 'D'                                  CAP059
     C                   MOVEL     'N'           OKCCY                          CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDCCY '      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'FDM0900'     MsgIdArr(Ix)                   CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
     C     EndRTV        ENDSR                                                  CAP059
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE               CAP059
      *****************************************************************         CAP059
     C     VFRNT         BEGSR                                                  CAP059
      *                                                                         CAP059
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'                          CAP059
      *                                                                         CAP059
     C     DDACTN        IFNE      'I'                                          CAP059
     C     DDACTN        ANDNE     'A'                                          CAP059
     C     DDACTN        ANDNE     'E'                                          CAP059
     C     DDACTN        ANDNE     'D'                                          CAP059
     C                   MOVEL     'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)                   CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK                           CAP059
      *                                                                         CAP059
     C     FOTRID        IFEQ      *BLANK                                       CAP059
     C                   MOVE      'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)                   CAP059
     C                   GOTO      EVFRNT                                       CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
     C* If CAP059 is on, access Currencies master file                          CAP059
     C* with Forward Rate MDF ID, a.k.a the front office ID, to get the currencyCAP059
     C                   IF        CAP059 = 'Y'                                 CAP059
     C     FOTRID        CHAIN     SDCURRL9                                     CAP059
                                                                                CAP059
     C* Front Office Id must be present on currencies file, whether this is an insert or amend
     C                   IF         NOT %FOUND(SDCURRL9)                        CAP059
     C                   MOVE      'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'MMA1155'     MsgIdArr(Ix)                   CAP059
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                       CAP059 MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT                                       CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
     C                   IF         %FOUND(SDCURRL9)                            CAP059
     C                   EVAL      DDCCY  = A6CYCD                              CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   IF        CAP059 = 'N'                                 CAP059
      * ACCESS TRANSACTION WITH FRONT OFFICE TRANSACTION ID                     CAP059
      *                                                                         CAP059
     C     FOTRID        CHAIN     FWDRTL1                            99        CAP059
      *                                                                         CAP059
      * IF INSERT                                                               CAP059
      *                                                                         CAP059
     C     DDACTN        IFEQ      'I'                                          CAP059
      *                                                                         CAP059
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY                    CAP059
      *                                                                         CAP059
     C     *IN99         IFEQ      '0'                                          CAP059
     C                   MOVE      'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)                   CAP059
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                       CAP059 MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT                                       CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   ELSE                                                   CAP059
      *                                                                         CAP059
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT              CAP059
      *                                                                         CAP059
     C     *IN99         IFEQ      '1'                                          CAP059
     C                   MOVE      'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)                   CAP059
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                       CAP059 MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT                                       CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C                   ENDIF                                                  CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
     C     EVFRNT        ENDSR                                                  CAP059
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATE CURRENCY CODE
      *****************************************************************
     C     VAL           BEGSR
      *                                                                         CAP059
      * ERROR IF ACTION CODE IS NOT 'I','A','E' OR 'D'                          CAP059
      *                                                                         CAP059
     C     DDACTN        IFNE      'I'                                          CAP059
     C     DDACTN        ANDNE     'A'                                          CAP059
     C     DDACTN        ANDNE     'E'                                          CAP059
     C     DDACTN        ANDNE     'D'                                          CAP059
     C                   MOVEL     'N'           OKACTN                         CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP059
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)                   CAP059
     C                   ENDIF                                                  CAP059
      *
      ** Check that the currency code has been entered
      *
     C     DDCCY         IFEQ      *BLANKS
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)
     C                   MOVEL     'MMA0705'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      ** Check that currency code exists
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DDCCY         @KEY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)
     C                   MOVEL     'ABM0009'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      ** Check that currency code is a valid dealing currency
      *
     C     A6DLCI        IFEQ      'N'
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)
     C                   MOVEL     'MMA0706'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ** Access forward rates record
      *
     C     DDCCY         CHAIN     FWDRTFEF                           99
     C     *IN99         IFEQ      '0'
     C     RECI          ANDNE     'D'
     C                   CLEAR                   FWRTFilFmt
     C                   ENDIF
      *
     C     EVAL          ENDSR
      *****************************************************************         CAP059
      /EJECT                                                                    CAP059
      *****************************************************************         CAP059
      * VALACI - VALIDATION OF ACTION CODE 'I'                                  CAP059
      *****************************************************************         CAP059
     C     VALACI        BEGSR                                                  CAP059
                                                                                CAP059
      *                                                                         CAP059
      * Access Transaction from the Transactions file                           CAP059
      *                                                                         CAP059
     C     DDCCY         CHAIN     FWDRT                              44        CAP059
      *                                                                         CAP059
      * Error if present already                                                CAP059
      *                                                                         CAP059
     C     *IN44         IFEQ      '0'                                          CAP059
     C     RECI          ANDEQ     'D'                                          CAP059
     C                   MOVEL     'N'           OKCCY                          CAP059
     C                   ADD       1             Ix                             CAP059
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)                 CAP059
     C                   MOVEL     'USR0542'     MsgIdArr(Ix)                   CAP059
     C                   ENDIF                                                  CAP059
      *                                                                         CAP059
      *                                                                         CAP059
     C     EVALAI        ENDSR                                                  CAP059
      *****************************************************************         CAP059
      /EJECT
      *****************************************************************
      * SecChk - Validation of user's action code security.
      *****************************************************************
     C     SecChk        BEGSR
      *
      * Single branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      'I'           ACTN              1
     C                   PARM                    @ERR              1 0
      *
      * Multibranching.
      *
     C                   ELSE
      *
      * Access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      'I'           ACTN
     C                   PARM      DBRN          ZDFB              3
     C                   PARM                    @ERR              1 0
     C                   ENDIF
      *
      * This action code invalid for user.
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0704'     MsgIdArr(Ix)
     C                   END
      *
     C     ESecChk       ENDSR
      *
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   FWRTFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKCCY
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
      * Currency
     C                   PARM                    DDCCY             3
      *                                                                                       CAP059
      * Front Office Transaction Id                                                           CAP059
     C                   PARM                    FOTRID           20                          CAP059
 
      * OUTPUTS
      *
      * (Current) forward rates in file format
     C                   PARM                    FWRTFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Currency code
     C                   PARM                    OKCCY             1
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
     C                   MOVEL     'FDFWRTRTV'   DBPGM
      *
      * Key Lists
      *
      ** ACCESS BANK DETAILS
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CAP059
      ** Access SAR details file to see if CAP059 is installed.                 CAP059
                                                                                CAP059
     C                   CALLB     'AOSARDR0'                                   CAP059
     C                   PARM      *BLANKS       @RTCD                          CAP059
     C                   PARM      '*VERIFY'     @OPTN                          CAP059
     C                   PARM      'CAP059'      @SARD                          CAP059
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP059
                                                                                CAP059
     C                   IF        @RTCD <> *Blanks AND                         CAP059
     C                             @RTCD <> '*NRF   '                           CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP059
     C                   Z-ADD     7             DBASE                          CAP059
     C                   MOVEL     'CAP059'      DBKEY                          CAP059
     C                   EXSR      *PSSR                                        CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
     C                   IF        @RTCD = *Blanks                              CAP059
     C                   MOVEL     'Y'           CAP059            1            CAP059
     C                   ELSE                                                   CAP059
     C                   MOVEL     'N'           CAP059                         CAP059
     C                   ENDIF                                                  CAP059
                                                                                CAP059
      *
 
      ** Access SAR details file to see if CSD006 is installed.                               CSD006
                                                                                              CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD                                        CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks AND                                       CSD006
     C                             @RTCD <> '*NRF   '                                         CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD006
     C                   Z-ADD     7             DBASE                                        CSD006
     C                   MOVEL     'CSD006'      DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   IF        @RTCD = *Blanks                                            CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
