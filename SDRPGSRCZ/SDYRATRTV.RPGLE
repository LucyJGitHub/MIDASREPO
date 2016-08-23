     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Retrieve')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  SDYRATRTV - Yield Rates Retrieve                             *
      *              (with Action Code and key fields Validation)     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 228812             Date 20Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG9329            Date 02Dec05               *
      *                 228348             Date 13Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 224743             Date 15Mar04               *
      *                 212406             Date 19Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking                                    *
      *  228812 - Yield Rates Enquiry function does not display any   *
      *           rate/discount factor details. PIACTN should be used *
      *           when validating the user's action code authority.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG9329 - Allow insert of period at the end point of         *
      *            maintenance. Applied fix 230448.                   *
      *  228348 - Error Message for SDYRAT Int. Calc Method not sent  *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  224743 - If CIR004 is installed, system should allow         *
      *           interest calculation method '7'.  Use new module    *
      *           ZAVCALCB instead of ZAVINTCALC so as not to affect  *
      *           dealing module functions.                           *
      *  212406 - Database error occurs when F8 is pressed            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  FUNCTION OF INDICATORS                                       *
      *                                                               *
      *  97  - Look up error/warning fields                           *
      *  99  - Read SDYLDRL1/SDYLDRL3                                 *
      *  LR  - Last record indicator (program termination)            *
      *  U7  - DB error processing indicator                          *
      *  U8  - DB error processing indicator                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      *  SrVALDT       Validate fields                                *
      *  SrUPDATERRS   Update error information with that received    *
      *                  back from each validation module             *
      *  SrRESETERRS   Reset error information that is received back  *
      *                 from each validation module                   *
      *  SrSETOUT      Set up Output File                             *
      *  SrAUTH        Validation of user's action code authority     *
      *  SrCOMFLDS     Setup Common Fields                            *
      *  SrVFRNT       Validation for Front Office Transaction        *
      *                  Interface                                    *
      *  SrINIT        Initialisation Processing                      *
      *  SrKBLNK       Validates Blank Key Field                      *
      *  SrACCSYRAT    Access Yield Rates Record                      *
      *  *INZSR        Program Initialisation routine                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F*SDYLDRL1**IF   E           K DISK    INFSR(*PSSR)                                     BUG9329
     FSDYLDRL2  IF   E           K DISK    INFSR(*PSSR)                                      BUG9329
      ** Yield Rates file by yield curve, currency and int. calc. meth.
 
     FSDYLDRL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDYLDRD0:SDYLDRD1)
      ** Yield Rates file by front office id
 
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
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
     D/COPY ZACPYSRC,ERR_XARR1
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
 
      ** Period Year
     D WAyy            S              2  0 DIM(98)
 
      ** Period Month
     D WAmm            S              2  0 DIM(98)
 
      ** Period Days
     D WAdd            S              2  0 DIM(98)
 
      ** Rate/Discount Factors
     D WArd            S             13  9 DIM(98)
 
      ** Discount Factors
     D WAdf            S             13  9 DIM(98)
 
      ** Maturity date
     D WAmd            S              5  0 DIM(98)
 
      ** Obtain default branch for user
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for switchable features                                                  CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
                                                                                              CAS008
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for yield curve details
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Yield Rates Valid File
     D YRATFilFmt    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(V_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter fields and work variables
     D ModeofOp        S              6
     D RespMode        S              1
     D PIACTN          S              1
     D PIYLDC          S              5
     D PIYCCY          S              3
     D PIYICM          S              1
     D PIYCFQ          S              1
     D PISPDY          S              2                                                       CAS008
     D PFOTRID         S             20
     D OKACTN          S              1
     D OKYLDC          S              1
     D OKYCCY          S              1
     D OKYICM          S              1
     D OKYCFQ          S              1
     D OKSPDY          S              1                                                       CAS008
     D Ix              S              3P 0
     D WIdx            S              3P 0
     D I               S              4  0
     D PKYCFQ          S              1
     D PSard           S              7                                                       CAS008
 
      ** Other work fields/parameter fields
     D PMSGID          S              7
     D PDFICM          S              1
                                                                                              CAS008
      ** Switchable Features                                                                  CAS008
     D CAS008          S              1                                                       CAS008
                                                                                              CAS008
      ** Variables for CAS008                                                                 CAS008
     D SpotNDay        S              2  0                                                    CAS008
     D WRKPDY          S              2  0                                                    CRE026
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** initialisation
 
     C                   EXSR      SrINIT
 
      ** Access user authority
 
     C                   IF        Respmode = 'S'
     C                   EXSR      SrAUTH
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** If the mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ** Do (extra) validation for FRONT OFFICE TRANSACTION INTERFACE
 
     C                   IF        ModeOfOp = '*FRONT'
     C                   EXSR      SrVFRNT
 
      **  Carry out no further validation if errors have occurred.
 
     C                   IF        (OKACTN = 'N') OR  (OKYLDC = 'N') OR
     C                             (OKYCCY = 'N') OR  (OKYICM = 'N')
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Validate field
 
     C                   EXSR      SrVALDT
 
      **  Carry out no further validation if errors have occurred.
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVALDT - Validate fields
      *                                                               *
      * Called By : Main                                              *
      *                                                               *
      * Calls : SrRESETERRS, SrKBLNK, SrUPDATERRS, SrCOMFLDS          *
      *         SrSETOUT, SrACCSYRAT                                  *
      *                                                               *
      *****************************************************************
     C     SrVALDT       BEGSR
 
      ** Action code is blank default to 'A'
 
     C                   IF        PIACTN = *BLANK AND ModeOfOp <> '*RPR  '
     C                   EVAL      PIACTN = 'A'
     C                   ENDIF
 
      ** Validate action code
 
     C                   IF        (PIACTN <> 'A') AND (PIACTN <> 'D') AND
     C                             (PIACTN <> 'E') AND (PIACTN <> 'I')
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9195'
     C                   GOTO      EndSrVALDT
     C                   ENDIF
 
     C                   EXSR      SrRESETERRS
 
      ** Validate Yield Curve
 
     C                   CALLB     'SDVYLDC01'
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeOfOp
     C                   PARM                    PIYLDC
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    SDYLDC
     C                   PARM      'Y'           OKYLDC
 
      ** Update error info with that produced by this subroutine, then reset
 
     C                   EXSR      SrUPDATERRS
 
     C                   EXSR      SrRESETERRS
 
      ** Validate Yield Currency
 
     C                   CALLB     'SDVYCCY01'
     C                   PARM                    RetCodeIn
     C                   PARM                    ModeOfOp
     C                   PARM                    PIYCCY
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    SDCURR
     C                   PARM      'Y'           OKYCCY
 
      ** Update error info with that produced by this subroutine, then reset
 
     C                   EXSR      SrUPDATERRS
 
     C                   EXSR      SrRESETERRS
 
      ** Validate Interest Calculation Method
 
      ** If currency is entered, pass default calculation method to ZAVINTCALC
      ** otherwise blank
 
     C                   IF        PIYCCY = *BLANK
     C                   EVAL      PDFICM = *BLANK
     C                   ELSE
     C                   EVAL      PDFICM = A6DICB
     C                   ENDIF
 
      ***Call*ZAVINTCALC*to*validate*interest*calculation*method**************                224743
 
     C**********         CALLB     'ZAVINTCALC'                                               224743
     C**********         PARM      *BLANKS       RetCodeOut                                   224743
     C**********         PARM                    PMSGID                                       224743
     C**********         PARM                    PIYICM                                       224743
     C**********         PARM                    PDFICM                                       224743
      ** Call ZAVCALCB to validate interest calculation method                                224743
                                                                                              224743
     C                   CALLB     'ZAVCALCB'                                                 224743
     C                   PARM      *BLANKS       RetCodeOut                                   224743
     C                   PARM                    PMSGID                                       224743
     C                   PARM                    PIYICM                                       224743
 
      ** Error found update error fields
 
     C                   IF        RetCodeOut <> *BLANK
     C                   EVAL      OKYICM = 'N'
   70C**********         EVAL      Ix  = Ix  + 1                                              228348
   70C                   EVAL      Ix  = 1                                                    228348
     C                   EVAL      FldNamXAr2(Ix) = '#0YICM    '
     C                   EVAL      MsgIdXAr2(Ix) = PMSGID
     C                   EVAL      MsgDtaXAr2(Ix) = *BLANKS
     C                   ENDIF
 
      ** Update error info with that produced by this subroutine, then reset
 
     C                   EXSR      SrUPDATERRS
 
     C                   EXSR      SrRESETERRS
 
      ** Check if all key fields has been entered
 
     C                   EXSR      SrKBLNK
 
     C                   IF        (OKYLDC = 'N') OR (OKYCCY = 'N') OR
     C                             (OKYICM = 'N')
     C                   GOTO      EndSrVALDT
     C                   ENDIF
     C
     C                   EXSR      SrACCSYRAT
     C                   IF        (OKYLDC = 'N') OR (OKYCCY = 'N') OR
     C                             (OKYICM = 'N')
     C                   GOTO      EndSrVALDT
     C                   ENDIF
 
      ** Validate Frequency Code
 
     C                   CALLB     'SDVCFRQ01'
     C                   PARM                    RetCodeIn
     C                   PARM                    PIYCFQ
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIdXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    SDYLDC
     C                   PARM      'Y'           OKYCFQ
 
      ** Update error info with that produced by this subroutine, then reset
 
     C                   EXSR      SrUPDATERRS
 
     C                   EXSR      SrRESETERRS
 
     C                   IF        (OKYLDC = 'N') OR (OKYCCY = 'N') OR
     C                             (OKYICM = 'N') OR (OKYCFQ = 'N')
     C                   GOTO      EndSrVALDT
     C                   ENDIF
                                                                                              CAS008
      ** Validate Spot Days                                                                   CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y' AND PIACTN = 'I' OR                           CAS008
     C                             CAS008 = 'Y' AND PIACTN = 'A'                              CAS008
                                                                                              CAS008
     C                   CALLB     'SDVSPDY'                                                  CAS008
     C                   PARM                    RetCodeOut                                   CAS008
     C                   PARM                    PISPDY                                       CAS008
     C                   PARM      *ZERO         SpotNDay                                     CAS008
     C                   PARM                    FldNamXAr2                                   CAS008
     C                   PARM                    MsgIdXAr2                                    CAS008
     C                   PARM                    MsgDtaXAr2                                   CAS008
     C                   PARM      'Y'           OKSPDY                                       CAS008
                                                                                              CAS008
      ** Update error info with that produced by this subroutine, then reset                  CAS008
                                                                                              CAS008
     C                   EXSR      SrUPDATERRS                                                CAS008
                                                                                              CAS008
     C                   EXSR      SrRESETERRS                                                CAS008
                                                                                              CAS008
     C                   IF        (OKYLDC = 'N') OR (OKYCCY = 'N') OR                        CAS008
     C                             (OKYICM = 'N') OR (OKYCFQ = 'N') OR                        CAS008
     C                             (OKSPDY = 'N')                                             CAS008
     C                   GOTO      EndSrVALDT                                                 CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   ENDIF                                                                CAS008
 
     C     EndSrVALDT    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrACCSYRAT - Access Yield rate record                         *
      *                                                               *
      * Called By: SrVALDT                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrACCSYRAT    BEGSR
      *
      ** Access SD yield rates records
      *
     C*****KYRAT         SETLL     SDYLDRL1                                                  BUG9329
     C*****KYRAT         READE     SDYLDRL1                               99                 BUG9329
     C     KYRAT         SETLL     SDYLDRL2                                                  BUG9329
     C     KYRAT         READE     SDYLDRL2                               99                 BUG9329
 
     C                   Z-ADD     *ZERO         ##X               3 0
     C                   Z-ADD     *ZERO         WAyy
     C                   Z-ADD     *ZERO         WAmm
     C                   Z-ADD     *ZERO         WAdd
     C                   Z-ADD     *ZERO         WArd
     C                   Z-ADD     *ZERO         WAdf
     C                   Z-ADD     *ZERO         WAmd
 
     C                   SELECT
 
     C                   WHEN      PIACTN  = 'I'
 
      ** Error when record is already existing for action 'I'
 
     C                   IF        *IN99 = *OFF
     C                   IF        FSRECI = 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9197'
     C                   GOTO      EACCS
     C                   ENDIF
     C                   ENDIF
 
      ** Error when record is already deleted for action 'E','A' or 'D' or
      ** does not exist on file
 
     C                   WHEN      (PIACTN = 'E') OR (PIACTN = 'A') OR
     C                             (PIACTN = 'D')
     C                   IF        (*IN99 = TRUE) OR
     C                             (*IN99 = FALSE) AND (FSRECI = '*')
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9198'
     C                   GOTO      EACCS
     C                   ELSE
 
     C                   ENDIF
     C                   ENDSL
 
     C                   DOW       *IN99 = *OFF
 
     C                   IF        FSRECI = 'D'
     C                   ADD       1             ##X
     C                   Z-ADD     FSPDYR        WAyy(##X)
     C                   Z-ADD     FSPDMN        WAmm(##X)
     C                   Z-ADD     FSPDDY        WAdd(##X)
     C                   Z-ADD     FSYRAT        WArd(##X)
     C                   Z-ADD     FSMMDN        WAmd(##X)
     C                   Z-ADD     FSDSCF        WAdf(##X)
 
      ** Setup common fields
 
     C                   EXSR      SrCOMFLDS
     C                   ENDIF
 
     C*****KYRAT         READE     SDYLDRL1                               99                 BUG9329
     C     KYRAT         READE     SDYLDRL2                               99                 BUG9329
     C                   ENDDO
 
     C                   EXSR      SrSETOUT
     C     EACCS         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUPDATERRS - Update error information with that received     *
      *               back from each validation module                *
      *                                                               *
      * Called By: SrVALDT                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrUPDATERRS   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameAr2(I)                          97
 
     C                   IF        *IN97 = *ON
     C                   MOVEA     FldNamXar2    FlDNameAr2(I)
     C                   MOVEA     MsgIdXar2     MsgIdAr2(I)
     C                   MOVEA     MsgDtaXar2    MsgDtaAr2(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameAr2(I)                          97
     C     I             SUB       1             Ix
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamAr2(I)                          97
 
     C                   IF        *IN97 = *ON
     C                   MOVEA     WFldNmXAr2    WFldNamAr2(I)
     C                   MOVEA     WMsgIdXAr2    WMsgIDAr2(I)
     C                   MOVEA     WMsgDtXAr2    WMsgDtaAr2(I)
     C                   ENDIF
 
      **  Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamAr2(I)                          97
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRESETERRS - Reset error information that is received back   *
      *               from each validation module                     *
      *                                                               *
      * Called By: SrVALDT                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRESETERRS   BEGSR
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr2= *BLANKS
     C                   EVAL      MsgIdXAr2 = *BLANKS
     C                   EVAL      MsgDtaXAr2= *BLANKS
     C                   EVAL      WFldNmXAr2 = *BLANKS
     C                   EVAL      WMsgIdXAr2= *BLANKS
     C                   EVAL      WMsgDtXAr2 = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSETOUT - Set up Output File                                 *
      *                                                               *
      * Called By : SrINIT, SrVALDT                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSETOUT      BEGSR
 
      ** Update output period years
 
     C                   Z-ADD     WAyy(1)       V_FSPDYR01
     C                   Z-ADD     WAyy(2)       V_FSPDYR02
     C                   Z-ADD     WAyy(3)       V_FSPDYR03
     C                   Z-ADD     WAyy(4)       V_FSPDYR04
     C                   Z-ADD     WAyy(5)       V_FSPDYR05
     C                   Z-ADD     WAyy(6)       V_FSPDYR06
     C                   Z-ADD     WAyy(7)       V_FSPDYR07
     C                   Z-ADD     WAyy(8)       V_FSPDYR08
     C                   Z-ADD     WAyy(9)       V_FSPDYR09
     C                   Z-ADD     WAyy(10)      V_FSPDYR10
     C                   Z-ADD     WAyy(11)      V_FSPDYR11
     C                   Z-ADD     WAyy(12)      V_FSPDYR12
     C                   Z-ADD     WAyy(13)      V_FSPDYR13
     C                   Z-ADD     WAyy(14)      V_FSPDYR14
     C                   Z-ADD     WAyy(15)      V_FSPDYR15
     C                   Z-ADD     WAyy(16)      V_FSPDYR16
     C                   Z-ADD     WAyy(17)      V_FSPDYR17
     C                   Z-ADD     WAyy(18)      V_FSPDYR18
     C                   Z-ADD     WAyy(19)      V_FSPDYR19
     C                   Z-ADD     WAyy(20)      V_FSPDYR20
     C                   Z-ADD     WAyy(21)      V_FSPDYR21
     C                   Z-ADD     WAyy(22)      V_FSPDYR22
     C                   Z-ADD     WAyy(23)      V_FSPDYR23
     C                   Z-ADD     WAyy(24)      V_FSPDYR24
     C                   Z-ADD     WAyy(25)      V_FSPDYR25
     C                   Z-ADD     WAyy(26)      V_FSPDYR26
     C                   Z-ADD     WAyy(27)      V_FSPDYR27
     C                   Z-ADD     WAyy(28)      V_FSPDYR28
     C                   Z-ADD     WAyy(29)      V_FSPDYR29
     C                   Z-ADD     WAyy(30)      V_FSPDYR30
     C                   Z-ADD     WAyy(31)      V_FSPDYR31
     C                   Z-ADD     WAyy(32)      V_FSPDYR32
     C                   Z-ADD     WAyy(33)      V_FSPDYR33
     C                   Z-ADD     WAyy(34)      V_FSPDYR34
     C                   Z-ADD     WAyy(35)      V_FSPDYR35
     C                   Z-ADD     WAyy(36)      V_FSPDYR36
     C                   Z-ADD     WAyy(37)      V_FSPDYR37
     C                   Z-ADD     WAyy(38)      V_FSPDYR38
     C                   Z-ADD     WAyy(39)      V_FSPDYR39
     C                   Z-ADD     WAyy(40)      V_FSPDYR40
     C                   Z-ADD     WAyy(41)      V_FSPDYR41
     C                   Z-ADD     WAyy(42)      V_FSPDYR42
     C                   Z-ADD     WAyy(43)      V_FSPDYR43
     C                   Z-ADD     WAyy(44)      V_FSPDYR44
     C                   Z-ADD     WAyy(45)      V_FSPDYR45
     C                   Z-ADD     WAyy(46)      V_FSPDYR46
     C                   Z-ADD     WAyy(47)      V_FSPDYR47
     C                   Z-ADD     WAyy(48)      V_FSPDYR48
     C                   Z-ADD     WAyy(49)      V_FSPDYR49
     C                   Z-ADD     WAyy(50)      V_FSPDYR50
     C                   Z-ADD     WAyy(51)      V_FSPDYR51
     C                   Z-ADD     WAyy(52)      V_FSPDYR52
     C                   Z-ADD     WAyy(53)      V_FSPDYR53
     C                   Z-ADD     WAyy(54)      V_FSPDYR54
     C                   Z-ADD     WAyy(55)      V_FSPDYR55
     C                   Z-ADD     WAyy(56)      V_FSPDYR56
     C                   Z-ADD     WAyy(57)      V_FSPDYR57
     C                   Z-ADD     WAyy(58)      V_FSPDYR58
     C                   Z-ADD     WAyy(59)      V_FSPDYR59
     C                   Z-ADD     WAyy(60)      V_FSPDYR60
     C                   Z-ADD     WAyy(61)      V_FSPDYR61
     C                   Z-ADD     WAyy(62)      V_FSPDYR62
     C                   Z-ADD     WAyy(63)      V_FSPDYR63
     C                   Z-ADD     WAyy(64)      V_FSPDYR64
     C                   Z-ADD     WAyy(65)      V_FSPDYR65
     C                   Z-ADD     WAyy(66)      V_FSPDYR66
     C                   Z-ADD     WAyy(67)      V_FSPDYR67
     C                   Z-ADD     WAyy(68)      V_FSPDYR68
     C                   Z-ADD     WAyy(69)      V_FSPDYR69
     C                   Z-ADD     WAyy(70)      V_FSPDYR70
     C                   Z-ADD     WAyy(71)      V_FSPDYR71
     C                   Z-ADD     WAyy(72)      V_FSPDYR72
     C                   Z-ADD     WAyy(73)      V_FSPDYR73
     C                   Z-ADD     WAyy(74)      V_FSPDYR74
     C                   Z-ADD     WAyy(75)      V_FSPDYR75
     C                   Z-ADD     WAyy(76)      V_FSPDYR76
     C                   Z-ADD     WAyy(77)      V_FSPDYR77
     C                   Z-ADD     WAyy(78)      V_FSPDYR78
     C                   Z-ADD     WAyy(79)      V_FSPDYR79
     C                   Z-ADD     WAyy(80)      V_FSPDYR80
     C                   Z-ADD     WAyy(81)      V_FSPDYR81
     C                   Z-ADD     WAyy(82)      V_FSPDYR82
     C                   Z-ADD     WAyy(83)      V_FSPDYR83
     C                   Z-ADD     WAyy(84)      V_FSPDYR84
     C                   Z-ADD     WAyy(85)      V_FSPDYR85
     C                   Z-ADD     WAyy(86)      V_FSPDYR86
     C                   Z-ADD     WAyy(87)      V_FSPDYR87
     C                   Z-ADD     WAyy(88)      V_FSPDYR88
     C                   Z-ADD     WAyy(89)      V_FSPDYR89
     C                   Z-ADD     WAyy(90)      V_FSPDYR90
     C                   Z-ADD     WAyy(91)      V_FSPDYR91
     C                   Z-ADD     WAyy(92)      V_FSPDYR92
     C                   Z-ADD     WAyy(93)      V_FSPDYR93
     C                   Z-ADD     WAyy(94)      V_FSPDYR94
     C                   Z-ADD     WAyy(95)      V_FSPDYR95
     C                   Z-ADD     WAyy(96)      V_FSPDYR96
     C                   Z-ADD     WAyy(97)      V_FSPDYR97
     C                   Z-ADD     WAyy(98)      V_FSPDYR98
      *
      * Update output period months
      *
     C                   Z-ADD     WAmm(1)       V_FSPDMN01
     C                   Z-ADD     WAmm(2)       V_FSPDMN02
     C                   Z-ADD     WAmm(3)       V_FSPDMN03
     C                   Z-ADD     WAmm(4)       V_FSPDMN04
     C                   Z-ADD     WAmm(5)       V_FSPDMN05
     C                   Z-ADD     WAmm(6)       V_FSPDMN06
     C                   Z-ADD     WAmm(7)       V_FSPDMN07
     C                   Z-ADD     WAmm(8)       V_FSPDMN08
     C                   Z-ADD     WAmm(9)       V_FSPDMN09
     C                   Z-ADD     WAmm(10)      V_FSPDMN10
     C                   Z-ADD     WAmm(11)      V_FSPDMN11
     C                   Z-ADD     WAmm(12)      V_FSPDMN12
     C                   Z-ADD     WAmm(13)      V_FSPDMN13
     C                   Z-ADD     WAmm(14)      V_FSPDMN14
     C                   Z-ADD     WAmm(15)      V_FSPDMN15
     C                   Z-ADD     WAmm(16)      V_FSPDMN16
     C                   Z-ADD     WAmm(17)      V_FSPDMN17
     C                   Z-ADD     WAmm(18)      V_FSPDMN18
     C                   Z-ADD     WAmm(19)      V_FSPDMN19
     C                   Z-ADD     WAmm(20)      V_FSPDMN20
     C                   Z-ADD     WAmm(21)      V_FSPDMN21
     C                   Z-ADD     WAmm(22)      V_FSPDMN22
     C                   Z-ADD     WAmm(23)      V_FSPDMN23
     C                   Z-ADD     WAmm(24)      V_FSPDMN24
     C                   Z-ADD     WAmm(25)      V_FSPDMN25
     C                   Z-ADD     WAmm(26)      V_FSPDMN26
     C                   Z-ADD     WAmm(27)      V_FSPDMN27
     C                   Z-ADD     WAmm(28)      V_FSPDMN28
     C                   Z-ADD     WAmm(29)      V_FSPDMN29
     C                   Z-ADD     WAmm(30)      V_FSPDMN30
     C                   Z-ADD     WAmm(31)      V_FSPDMN31
     C                   Z-ADD     WAmm(32)      V_FSPDMN32
     C                   Z-ADD     WAmm(33)      V_FSPDMN33
     C                   Z-ADD     WAmm(34)      V_FSPDMN34
     C                   Z-ADD     WAmm(35)      V_FSPDMN35
     C                   Z-ADD     WAmm(36)      V_FSPDMN36
     C                   Z-ADD     WAmm(37)      V_FSPDMN37
     C                   Z-ADD     WAmm(38)      V_FSPDMN38
     C                   Z-ADD     WAmm(39)      V_FSPDMN39
     C                   Z-ADD     WAmm(40)      V_FSPDMN40
     C                   Z-ADD     WAmm(41)      V_FSPDMN41
     C                   Z-ADD     WAmm(42)      V_FSPDMN42
     C                   Z-ADD     WAmm(43)      V_FSPDMN43
     C                   Z-ADD     WAmm(44)      V_FSPDMN44
     C                   Z-ADD     WAmm(45)      V_FSPDMN45
     C                   Z-ADD     WAmm(46)      V_FSPDMN46
     C                   Z-ADD     WAmm(47)      V_FSPDMN47
     C                   Z-ADD     WAmm(48)      V_FSPDMN48
     C                   Z-ADD     WAmm(49)      V_FSPDMN49
     C                   Z-ADD     WAmm(50)      V_FSPDMN50
     C                   Z-ADD     WAmm(51)      V_FSPDMN51
     C                   Z-ADD     WAmm(52)      V_FSPDMN52
     C                   Z-ADD     WAmm(53)      V_FSPDMN53
     C                   Z-ADD     WAmm(54)      V_FSPDMN54
     C                   Z-ADD     WAmm(55)      V_FSPDMN55
     C                   Z-ADD     WAmm(56)      V_FSPDMN56
     C                   Z-ADD     WAmm(57)      V_FSPDMN57
     C                   Z-ADD     WAmm(58)      V_FSPDMN58
     C                   Z-ADD     WAmm(59)      V_FSPDMN59
     C                   Z-ADD     WAmm(60)      V_FSPDMN60
     C                   Z-ADD     WAmm(61)      V_FSPDMN61
     C                   Z-ADD     WAmm(62)      V_FSPDMN62
     C                   Z-ADD     WAmm(63)      V_FSPDMN63
     C                   Z-ADD     WAmm(64)      V_FSPDMN64
     C                   Z-ADD     WAmm(65)      V_FSPDMN65
     C                   Z-ADD     WAmm(66)      V_FSPDMN66
     C                   Z-ADD     WAmm(67)      V_FSPDMN67
     C                   Z-ADD     WAmm(68)      V_FSPDMN68
     C                   Z-ADD     WAmm(69)      V_FSPDMN69
     C                   Z-ADD     WAmm(70)      V_FSPDMN70
     C                   Z-ADD     WAmm(71)      V_FSPDMN71
     C                   Z-ADD     WAmm(72)      V_FSPDMN72
     C                   Z-ADD     WAmm(73)      V_FSPDMN73
     C                   Z-ADD     WAmm(74)      V_FSPDMN74
     C                   Z-ADD     WAmm(75)      V_FSPDMN75
     C                   Z-ADD     WAmm(76)      V_FSPDMN76
     C                   Z-ADD     WAmm(77)      V_FSPDMN77
     C                   Z-ADD     WAmm(78)      V_FSPDMN78
     C                   Z-ADD     WAmm(79)      V_FSPDMN79
     C                   Z-ADD     WAmm(80)      V_FSPDMN80
     C                   Z-ADD     WAmm(81)      V_FSPDMN81
     C                   Z-ADD     WAmm(82)      V_FSPDMN82
     C                   Z-ADD     WAmm(83)      V_FSPDMN83
     C                   Z-ADD     WAmm(84)      V_FSPDMN84
     C                   Z-ADD     WAmm(85)      V_FSPDMN85
     C                   Z-ADD     WAmm(86)      V_FSPDMN86
     C                   Z-ADD     WAmm(87)      V_FSPDMN87
     C                   Z-ADD     WAmm(88)      V_FSPDMN88
     C                   Z-ADD     WAmm(89)      V_FSPDMN89
     C                   Z-ADD     WAmm(90)      V_FSPDMN90
     C                   Z-ADD     WAmm(91)      V_FSPDMN91
     C                   Z-ADD     WAmm(92)      V_FSPDMN92
     C                   Z-ADD     WAmm(93)      V_FSPDMN93
     C                   Z-ADD     WAmm(94)      V_FSPDMN94
     C                   Z-ADD     WAmm(95)      V_FSPDMN95
     C                   Z-ADD     WAmm(96)      V_FSPDMN96
     C                   Z-ADD     WAmm(97)      V_FSPDMN97
     C                   Z-ADD     WAmm(98)      V_FSPDMN98
      *
      * Update output period days
      *
     C                   Z-ADD     WAdd(1)       V_FSPDDY01
     C                   Z-ADD     WAdd(2)       V_FSPDDY02
     C                   Z-ADD     WAdd(3)       V_FSPDDY03
     C                   Z-ADD     WAdd(4)       V_FSPDDY04
     C                   Z-ADD     WAdd(5)       V_FSPDDY05
     C                   Z-ADD     WAdd(6)       V_FSPDDY06
     C                   Z-ADD     WAdd(7)       V_FSPDDY07
     C                   Z-ADD     WAdd(8)       V_FSPDDY08
     C                   Z-ADD     WAdd(9)       V_FSPDDY09
     C                   Z-ADD     WAdd(10)      V_FSPDDY10
     C                   Z-ADD     WAdd(11)      V_FSPDDY11
     C                   Z-ADD     WAdd(12)      V_FSPDDY12
     C                   Z-ADD     WAdd(13)      V_FSPDDY13
     C                   Z-ADD     WAdd(14)      V_FSPDDY14
     C                   Z-ADD     WAdd(15)      V_FSPDDY15
     C                   Z-ADD     WAdd(16)      V_FSPDDY16
     C                   Z-ADD     WAdd(17)      V_FSPDDY17
     C                   Z-ADD     WAdd(18)      V_FSPDDY18
     C                   Z-ADD     WAdd(19)      V_FSPDDY19
     C                   Z-ADD     WAdd(20)      V_FSPDDY20
     C                   Z-ADD     WAdd(21)      V_FSPDDY21
     C                   Z-ADD     WAdd(22)      V_FSPDDY22
     C                   Z-ADD     WAdd(23)      V_FSPDDY23
     C                   Z-ADD     WAdd(24)      V_FSPDDY24
     C                   Z-ADD     WAdd(25)      V_FSPDDY25
     C                   Z-ADD     WAdd(26)      V_FSPDDY26
     C                   Z-ADD     WAdd(27)      V_FSPDDY27
     C                   Z-ADD     WAdd(28)      V_FSPDDY28
     C                   Z-ADD     WAdd(29)      V_FSPDDY29
     C                   Z-ADD     WAdd(30)      V_FSPDDY30
     C                   Z-ADD     WAdd(31)      V_FSPDDY31
     C                   Z-ADD     WAdd(32)      V_FSPDDY32
     C                   Z-ADD     WAdd(33)      V_FSPDDY33
     C                   Z-ADD     WAdd(34)      V_FSPDDY34
     C                   Z-ADD     WAdd(35)      V_FSPDDY35
     C                   Z-ADD     WAdd(36)      V_FSPDDY36
     C                   Z-ADD     WAdd(37)      V_FSPDDY37
     C                   Z-ADD     WAdd(38)      V_FSPDDY38
     C                   Z-ADD     WAdd(39)      V_FSPDDY39
     C                   Z-ADD     WAdd(40)      V_FSPDDY40
     C                   Z-ADD     WAdd(41)      V_FSPDDY41
     C                   Z-ADD     WAdd(42)      V_FSPDDY42
     C                   Z-ADD     WAdd(43)      V_FSPDDY43
     C                   Z-ADD     WAdd(44)      V_FSPDDY44
     C                   Z-ADD     WAdd(45)      V_FSPDDY45
     C                   Z-ADD     WAdd(46)      V_FSPDDY46
     C                   Z-ADD     WAdd(47)      V_FSPDDY47
     C                   Z-ADD     WAdd(48)      V_FSPDDY48
     C                   Z-ADD     WAdd(49)      V_FSPDDY49
     C                   Z-ADD     WAdd(50)      V_FSPDDY50
     C                   Z-ADD     WAdd(51)      V_FSPDDY51
     C                   Z-ADD     WAdd(52)      V_FSPDDY52
     C                   Z-ADD     WAdd(53)      V_FSPDDY53
     C                   Z-ADD     WAdd(54)      V_FSPDDY54
     C                   Z-ADD     WAdd(55)      V_FSPDDY55
     C                   Z-ADD     WAdd(56)      V_FSPDDY56
     C                   Z-ADD     WAdd(57)      V_FSPDDY57
     C                   Z-ADD     WAdd(58)      V_FSPDDY58
     C                   Z-ADD     WAdd(59)      V_FSPDDY59
     C                   Z-ADD     WAdd(60)      V_FSPDDY60
     C                   Z-ADD     WAdd(61)      V_FSPDDY61
     C                   Z-ADD     WAdd(62)      V_FSPDDY62
     C                   Z-ADD     WAdd(63)      V_FSPDDY63
     C                   Z-ADD     WAdd(64)      V_FSPDDY64
     C                   Z-ADD     WAdd(65)      V_FSPDDY65
     C                   Z-ADD     WAdd(66)      V_FSPDDY66
     C                   Z-ADD     WAdd(67)      V_FSPDDY67
     C                   Z-ADD     WAdd(68)      V_FSPDDY68
     C                   Z-ADD     WAdd(69)      V_FSPDDY69
     C                   Z-ADD     WAdd(70)      V_FSPDDY70
     C                   Z-ADD     WAdd(71)      V_FSPDDY71
     C                   Z-ADD     WAdd(72)      V_FSPDDY72
     C                   Z-ADD     WAdd(73)      V_FSPDDY73
     C                   Z-ADD     WAdd(74)      V_FSPDDY74
     C                   Z-ADD     WAdd(75)      V_FSPDDY75
     C                   Z-ADD     WAdd(76)      V_FSPDDY76
     C                   Z-ADD     WAdd(77)      V_FSPDDY77
     C                   Z-ADD     WAdd(78)      V_FSPDDY78
     C                   Z-ADD     WAdd(79)      V_FSPDDY79
     C                   Z-ADD     WAdd(80)      V_FSPDDY80
     C                   Z-ADD     WAdd(81)      V_FSPDDY81
     C                   Z-ADD     WAdd(82)      V_FSPDDY82
     C                   Z-ADD     WAdd(83)      V_FSPDDY83
     C                   Z-ADD     WAdd(84)      V_FSPDDY84
     C                   Z-ADD     WAdd(85)      V_FSPDDY85
     C                   Z-ADD     WAdd(86)      V_FSPDDY86
     C                   Z-ADD     WAdd(87)      V_FSPDDY87
     C                   Z-ADD     WAdd(88)      V_FSPDDY88
     C                   Z-ADD     WAdd(89)      V_FSPDDY89
     C                   Z-ADD     WAdd(90)      V_FSPDDY90
     C                   Z-ADD     WAdd(91)      V_FSPDDY91
     C                   Z-ADD     WAdd(92)      V_FSPDDY92
     C                   Z-ADD     WAdd(93)      V_FSPDDY93
     C                   Z-ADD     WAdd(94)      V_FSPDDY94
     C                   Z-ADD     WAdd(95)      V_FSPDDY95
     C                   Z-ADD     WAdd(96)      V_FSPDDY96
     C                   Z-ADD     WAdd(97)      V_FSPDDY97
     C                   Z-ADD     WAdd(98)      V_FSPDDY98
      *
      * Update output rates
      *
     C                   Z-ADD     WArd(1)       V_FSYRAT01
     C                   Z-ADD     WArd(2)       V_FSYRAT02
     C                   Z-ADD     WArd(3)       V_FSYRAT03
     C                   Z-ADD     WArd(4)       V_FSYRAT04
     C                   Z-ADD     WArd(5)       V_FSYRAT05
     C                   Z-ADD     WArd(6)       V_FSYRAT06
     C                   Z-ADD     WArd(7)       V_FSYRAT07
     C                   Z-ADD     WArd(8)       V_FSYRAT08
     C                   Z-ADD     WArd(9)       V_FSYRAT09
     C                   Z-ADD     WArd(10)      V_FSYRAT10
     C                   Z-ADD     WArd(11)      V_FSYRAT11
     C                   Z-ADD     WArd(12)      V_FSYRAT12
     C                   Z-ADD     WArd(13)      V_FSYRAT13
     C                   Z-ADD     WArd(14)      V_FSYRAT14
     C                   Z-ADD     WArd(15)      V_FSYRAT15
     C                   Z-ADD     WArd(16)      V_FSYRAT16
     C                   Z-ADD     WArd(17)      V_FSYRAT17
     C                   Z-ADD     WArd(18)      V_FSYRAT18
     C                   Z-ADD     WArd(19)      V_FSYRAT19
     C                   Z-ADD     WArd(20)      V_FSYRAT20
     C                   Z-ADD     WArd(21)      V_FSYRAT21
     C                   Z-ADD     WArd(22)      V_FSYRAT22
     C                   Z-ADD     WArd(23)      V_FSYRAT23
     C                   Z-ADD     WArd(24)      V_FSYRAT24
     C                   Z-ADD     WArd(25)      V_FSYRAT25
     C                   Z-ADD     WArd(26)      V_FSYRAT26
     C                   Z-ADD     WArd(27)      V_FSYRAT27
     C                   Z-ADD     WArd(28)      V_FSYRAT28
     C                   Z-ADD     WArd(29)      V_FSYRAT29
     C                   Z-ADD     WArd(30)      V_FSYRAT30
     C                   Z-ADD     WArd(31)      V_FSYRAT31
     C                   Z-ADD     WArd(32)      V_FSYRAT32
     C                   Z-ADD     WArd(33)      V_FSYRAT33
     C                   Z-ADD     WArd(34)      V_FSYRAT34
     C                   Z-ADD     WArd(35)      V_FSYRAT35
     C                   Z-ADD     WArd(36)      V_FSYRAT36
     C                   Z-ADD     WArd(37)      V_FSYRAT37
     C                   Z-ADD     WArd(38)      V_FSYRAT38
     C                   Z-ADD     WArd(39)      V_FSYRAT39
     C                   Z-ADD     WArd(40)      V_FSYRAT40
     C                   Z-ADD     WArd(41)      V_FSYRAT41
     C                   Z-ADD     WArd(42)      V_FSYRAT42
     C                   Z-ADD     WArd(43)      V_FSYRAT43
     C                   Z-ADD     WArd(44)      V_FSYRAT44
     C                   Z-ADD     WArd(45)      V_FSYRAT45
     C                   Z-ADD     WArd(46)      V_FSYRAT46
     C                   Z-ADD     WArd(47)      V_FSYRAT47
     C                   Z-ADD     WArd(48)      V_FSYRAT48
     C                   Z-ADD     WArd(49)      V_FSYRAT49
     C                   Z-ADD     WArd(50)      V_FSYRAT50
     C                   Z-ADD     WArd(51)      V_FSYRAT51
     C                   Z-ADD     WArd(52)      V_FSYRAT52
     C                   Z-ADD     WArd(53)      V_FSYRAT53
     C                   Z-ADD     WArd(54)      V_FSYRAT54
     C                   Z-ADD     WArd(55)      V_FSYRAT55
     C                   Z-ADD     WArd(56)      V_FSYRAT56
     C                   Z-ADD     WArd(57)      V_FSYRAT57
     C                   Z-ADD     WArd(58)      V_FSYRAT58
     C                   Z-ADD     WArd(59)      V_FSYRAT59
     C                   Z-ADD     WArd(60)      V_FSYRAT60
     C                   Z-ADD     WArd(61)      V_FSYRAT61
     C                   Z-ADD     WArd(62)      V_FSYRAT62
     C                   Z-ADD     WArd(63)      V_FSYRAT63
     C                   Z-ADD     WArd(64)      V_FSYRAT64
     C                   Z-ADD     WArd(65)      V_FSYRAT65
     C                   Z-ADD     WArd(66)      V_FSYRAT66
     C                   Z-ADD     WArd(67)      V_FSYRAT67
     C                   Z-ADD     WArd(68)      V_FSYRAT68
     C                   Z-ADD     WArd(69)      V_FSYRAT69
     C                   Z-ADD     WArd(70)      V_FSYRAT70
     C                   Z-ADD     WArd(71)      V_FSYRAT71
     C                   Z-ADD     WArd(72)      V_FSYRAT72
     C                   Z-ADD     WArd(73)      V_FSYRAT73
     C                   Z-ADD     WArd(74)      V_FSYRAT74
     C                   Z-ADD     WArd(75)      V_FSYRAT75
     C                   Z-ADD     WArd(76)      V_FSYRAT76
     C                   Z-ADD     WArd(77)      V_FSYRAT77
     C                   Z-ADD     WArd(78)      V_FSYRAT78
     C                   Z-ADD     WArd(79)      V_FSYRAT79
     C                   Z-ADD     WArd(80)      V_FSYRAT80
     C                   Z-ADD     WArd(81)      V_FSYRAT81
     C                   Z-ADD     WArd(82)      V_FSYRAT82
     C                   Z-ADD     WArd(83)      V_FSYRAT83
     C                   Z-ADD     WArd(84)      V_FSYRAT84
     C                   Z-ADD     WArd(85)      V_FSYRAT85
     C                   Z-ADD     WArd(86)      V_FSYRAT86
     C                   Z-ADD     WArd(87)      V_FSYRAT87
     C                   Z-ADD     WArd(88)      V_FSYRAT88
     C                   Z-ADD     WArd(89)      V_FSYRAT89
     C                   Z-ADD     WArd(90)      V_FSYRAT90
     C                   Z-ADD     WArd(91)      V_FSYRAT91
     C                   Z-ADD     WArd(92)      V_FSYRAT92
     C                   Z-ADD     WArd(93)      V_FSYRAT93
     C                   Z-ADD     WArd(94)      V_FSYRAT94
     C                   Z-ADD     WArd(95)      V_FSYRAT95
     C                   Z-ADD     WArd(96)      V_FSYRAT96
     C                   Z-ADD     WArd(97)      V_FSYRAT97
     C                   Z-ADD     WArd(98)      V_FSYRAT98
      *
      * Update maturity date
      *
     C                   Z-ADD     WAmd(1)       V_FSMMDN01
     C                   Z-ADD     WAmd(2)       V_FSMMDN02
     C                   Z-ADD     WAmd(3)       V_FSMMDN03
     C                   Z-ADD     WAmd(4)       V_FSMMDN04
     C                   Z-ADD     WAmd(5)       V_FSMMDN05
     C                   Z-ADD     WAmd(6)       V_FSMMDN06
     C                   Z-ADD     WAmd(7)       V_FSMMDN07
     C                   Z-ADD     WAmd(8)       V_FSMMDN08
     C                   Z-ADD     WAmd(9)       V_FSMMDN09
     C                   Z-ADD     WAmd(10)      V_FSMMDN10
     C                   Z-ADD     WAmd(11)      V_FSMMDN11
     C                   Z-ADD     WAmd(12)      V_FSMMDN12
     C                   Z-ADD     WAmd(13)      V_FSMMDN13
     C                   Z-ADD     WAmd(14)      V_FSMMDN14
     C                   Z-ADD     WAmd(15)      V_FSMMDN15
     C                   Z-ADD     WAmd(16)      V_FSMMDN16
     C                   Z-ADD     WAmd(17)      V_FSMMDN17
     C                   Z-ADD     WAmd(18)      V_FSMMDN18
     C                   Z-ADD     WAmd(19)      V_FSMMDN19
     C                   Z-ADD     WAmd(20)      V_FSMMDN20
     C                   Z-ADD     WAmd(21)      V_FSMMDN21
     C                   Z-ADD     WAmd(22)      V_FSMMDN22
     C                   Z-ADD     WAmd(23)      V_FSMMDN23
     C                   Z-ADD     WAmd(24)      V_FSMMDN24
     C                   Z-ADD     WAmd(25)      V_FSMMDN25
     C                   Z-ADD     WAmd(26)      V_FSMMDN26
     C                   Z-ADD     WAmd(27)      V_FSMMDN27
     C                   Z-ADD     WAmd(28)      V_FSMMDN28
     C                   Z-ADD     WAmd(29)      V_FSMMDN29
     C                   Z-ADD     WAmd(30)      V_FSMMDN30
     C                   Z-ADD     WAmd(31)      V_FSMMDN31
     C                   Z-ADD     WAmd(32)      V_FSMMDN32
     C                   Z-ADD     WAmd(33)      V_FSMMDN33
     C                   Z-ADD     WAmd(34)      V_FSMMDN34
     C                   Z-ADD     WAmd(35)      V_FSMMDN35
     C                   Z-ADD     WAmd(36)      V_FSMMDN36
     C                   Z-ADD     WAmd(37)      V_FSMMDN37
     C                   Z-ADD     WAmd(38)      V_FSMMDN38
     C                   Z-ADD     WAmd(39)      V_FSMMDN39
     C                   Z-ADD     WAmd(40)      V_FSMMDN40
     C                   Z-ADD     WAmd(41)      V_FSMMDN41
     C                   Z-ADD     WAmd(42)      V_FSMMDN42
     C                   Z-ADD     WAmd(43)      V_FSMMDN43
     C                   Z-ADD     WAmd(44)      V_FSMMDN44
     C                   Z-ADD     WAmd(45)      V_FSMMDN45
     C                   Z-ADD     WAmd(46)      V_FSMMDN46
     C                   Z-ADD     WAmd(47)      V_FSMMDN47
     C                   Z-ADD     WAmd(48)      V_FSMMDN48
     C                   Z-ADD     WAmd(49)      V_FSMMDN49
     C                   Z-ADD     WAmd(50)      V_FSMMDN50
     C                   Z-ADD     WAmd(51)      V_FSMMDN51
     C                   Z-ADD     WAmd(52)      V_FSMMDN52
     C                   Z-ADD     WAmd(53)      V_FSMMDN53
     C                   Z-ADD     WAmd(54)      V_FSMMDN54
     C                   Z-ADD     WAmd(55)      V_FSMMDN55
     C                   Z-ADD     WAmd(56)      V_FSMMDN56
     C                   Z-ADD     WAmd(57)      V_FSMMDN57
     C                   Z-ADD     WAmd(58)      V_FSMMDN58
     C                   Z-ADD     WAmd(59)      V_FSMMDN59
     C                   Z-ADD     WAmd(60)      V_FSMMDN60
     C                   Z-ADD     WAmd(61)      V_FSMMDN61
     C                   Z-ADD     WAmd(62)      V_FSMMDN62
     C                   Z-ADD     WAmd(63)      V_FSMMDN63
     C                   Z-ADD     WAmd(64)      V_FSMMDN64
     C                   Z-ADD     WAmd(65)      V_FSMMDN65
     C                   Z-ADD     WAmd(66)      V_FSMMDN66
     C                   Z-ADD     WAmd(67)      V_FSMMDN67
     C                   Z-ADD     WAmd(68)      V_FSMMDN68
     C                   Z-ADD     WAmd(69)      V_FSMMDN69
     C                   Z-ADD     WAmd(70)      V_FSMMDN70
     C                   Z-ADD     WAmd(71)      V_FSMMDN71
     C                   Z-ADD     WAmd(72)      V_FSMMDN72
     C                   Z-ADD     WAmd(73)      V_FSMMDN73
     C                   Z-ADD     WAmd(74)      V_FSMMDN74
     C                   Z-ADD     WAmd(75)      V_FSMMDN75
     C                   Z-ADD     WAmd(76)      V_FSMMDN76
     C                   Z-ADD     WAmd(77)      V_FSMMDN77
     C                   Z-ADD     WAmd(78)      V_FSMMDN78
     C                   Z-ADD     WAmd(79)      V_FSMMDN79
     C                   Z-ADD     WAmd(80)      V_FSMMDN80
     C                   Z-ADD     WAmd(81)      V_FSMMDN81
     C                   Z-ADD     WAmd(82)      V_FSMMDN82
     C                   Z-ADD     WAmd(83)      V_FSMMDN83
     C                   Z-ADD     WAmd(84)      V_FSMMDN84
     C                   Z-ADD     WAmd(85)      V_FSMMDN85
     C                   Z-ADD     WAmd(86)      V_FSMMDN86
     C                   Z-ADD     WAmd(87)      V_FSMMDN87
     C                   Z-ADD     WAmd(88)      V_FSMMDN88
     C                   Z-ADD     WAmd(89)      V_FSMMDN89
     C                   Z-ADD     WAmd(90)      V_FSMMDN90
     C                   Z-ADD     WAmd(91)      V_FSMMDN91
     C                   Z-ADD     WAmd(92)      V_FSMMDN92
     C                   Z-ADD     WAmd(93)      V_FSMMDN93
     C                   Z-ADD     WAmd(94)      V_FSMMDN94
     C                   Z-ADD     WAmd(95)      V_FSMMDN95
     C                   Z-ADD     WAmd(96)      V_FSMMDN96
     C                   Z-ADD     WAmd(97)      V_FSMMDN97
     C                   Z-ADD     WAmd(98)      V_FSMMDN98
      *
      * Update discount factor
      *
     C                   Z-ADD     WAdf(1)       V_FSDSCF01
     C                   Z-ADD     WAdf(2)       V_FSDSCF02
     C                   Z-ADD     WAdf(3)       V_FSDSCF03
     C                   Z-ADD     WAdf(4)       V_FSDSCF04
     C                   Z-ADD     WAdf(5)       V_FSDSCF05
     C                   Z-ADD     WAdf(6)       V_FSDSCF06
     C                   Z-ADD     WAdf(7)       V_FSDSCF07
     C                   Z-ADD     WAdf(8)       V_FSDSCF08
     C                   Z-ADD     WAdf(9)       V_FSDSCF09
     C                   Z-ADD     WAdf(10)      V_FSDSCF10
     C                   Z-ADD     WAdf(11)      V_FSDSCF11
     C                   Z-ADD     WAdf(12)      V_FSDSCF12
     C                   Z-ADD     WAdf(13)      V_FSDSCF13
     C                   Z-ADD     WAdf(14)      V_FSDSCF14
     C                   Z-ADD     WAdf(15)      V_FSDSCF15
     C                   Z-ADD     WAdf(16)      V_FSDSCF16
     C                   Z-ADD     WAdf(17)      V_FSDSCF17
     C                   Z-ADD     WAdf(18)      V_FSDSCF18
     C                   Z-ADD     WAdf(19)      V_FSDSCF19
     C                   Z-ADD     WAdf(20)      V_FSDSCF20
     C                   Z-ADD     WAdf(21)      V_FSDSCF21
     C                   Z-ADD     WAdf(22)      V_FSDSCF22
     C                   Z-ADD     WAdf(23)      V_FSDSCF23
     C                   Z-ADD     WAdf(24)      V_FSDSCF24
     C                   Z-ADD     WAdf(25)      V_FSDSCF25
     C                   Z-ADD     WAdf(26)      V_FSDSCF26
     C                   Z-ADD     WAdf(27)      V_FSDSCF27
     C                   Z-ADD     WAdf(28)      V_FSDSCF28
     C                   Z-ADD     WAdf(29)      V_FSDSCF29
     C                   Z-ADD     WAdf(30)      V_FSDSCF30
     C                   Z-ADD     WAdf(31)      V_FSDSCF31
     C                   Z-ADD     WAdf(32)      V_FSDSCF32
     C                   Z-ADD     WAdf(33)      V_FSDSCF33
     C                   Z-ADD     WAdf(34)      V_FSDSCF34
     C                   Z-ADD     WAdf(35)      V_FSDSCF35
     C                   Z-ADD     WAdf(36)      V_FSDSCF36
     C                   Z-ADD     WAdf(37)      V_FSDSCF37
     C                   Z-ADD     WAdf(38)      V_FSDSCF38
     C                   Z-ADD     WAdf(39)      V_FSDSCF39
     C                   Z-ADD     WAdf(40)      V_FSDSCF40
     C                   Z-ADD     WAdf(41)      V_FSDSCF41
     C                   Z-ADD     WAdf(42)      V_FSDSCF42
     C                   Z-ADD     WAdf(43)      V_FSDSCF43
     C                   Z-ADD     WAdf(44)      V_FSDSCF44
     C                   Z-ADD     WAdf(45)      V_FSDSCF45
     C                   Z-ADD     WAdf(46)      V_FSDSCF46
     C                   Z-ADD     WAdf(47)      V_FSDSCF47
     C                   Z-ADD     WAdf(48)      V_FSDSCF48
     C                   Z-ADD     WAdf(49)      V_FSDSCF49
     C                   Z-ADD     WAdf(50)      V_FSDSCF50
     C                   Z-ADD     WAdf(51)      V_FSDSCF51
     C                   Z-ADD     WAdf(52)      V_FSDSCF52
     C                   Z-ADD     WAdf(53)      V_FSDSCF53
     C                   Z-ADD     WAdf(54)      V_FSDSCF54
     C                   Z-ADD     WAdf(55)      V_FSDSCF55
     C                   Z-ADD     WAdf(56)      V_FSDSCF56
     C                   Z-ADD     WAdf(57)      V_FSDSCF57
     C                   Z-ADD     WAdf(58)      V_FSDSCF58
     C                   Z-ADD     WAdf(59)      V_FSDSCF59
     C                   Z-ADD     WAdf(60)      V_FSDSCF60
     C                   Z-ADD     WAdf(61)      V_FSDSCF61
     C                   Z-ADD     WAdf(62)      V_FSDSCF62
     C                   Z-ADD     WAdf(63)      V_FSDSCF63
     C                   Z-ADD     WAdf(64)      V_FSDSCF64
     C                   Z-ADD     WAdf(65)      V_FSDSCF65
     C                   Z-ADD     WAdf(66)      V_FSDSCF66
     C                   Z-ADD     WAdf(67)      V_FSDSCF67
     C                   Z-ADD     WAdf(68)      V_FSDSCF68
     C                   Z-ADD     WAdf(69)      V_FSDSCF69
     C                   Z-ADD     WAdf(70)      V_FSDSCF70
     C                   Z-ADD     WAdf(71)      V_FSDSCF71
     C                   Z-ADD     WAdf(72)      V_FSDSCF72
     C                   Z-ADD     WAdf(73)      V_FSDSCF73
     C                   Z-ADD     WAdf(74)      V_FSDSCF74
     C                   Z-ADD     WAdf(75)      V_FSDSCF75
     C                   Z-ADD     WAdf(76)      V_FSDSCF76
     C                   Z-ADD     WAdf(77)      V_FSDSCF77
     C                   Z-ADD     WAdf(78)      V_FSDSCF78
     C                   Z-ADD     WAdf(79)      V_FSDSCF79
     C                   Z-ADD     WAdf(80)      V_FSDSCF80
     C                   Z-ADD     WAdf(81)      V_FSDSCF81
     C                   Z-ADD     WAdf(82)      V_FSDSCF82
     C                   Z-ADD     WAdf(83)      V_FSDSCF83
     C                   Z-ADD     WAdf(84)      V_FSDSCF84
     C                   Z-ADD     WAdf(85)      V_FSDSCF85
     C                   Z-ADD     WAdf(86)      V_FSDSCF86
     C                   Z-ADD     WAdf(87)      V_FSDSCF87
     C                   Z-ADD     WAdf(88)      V_FSDSCF88
     C                   Z-ADD     WAdf(89)      V_FSDSCF89
     C                   Z-ADD     WAdf(90)      V_FSDSCF90
     C                   Z-ADD     WAdf(91)      V_FSDSCF91
     C                   Z-ADD     WAdf(92)      V_FSDSCF92
     C                   Z-ADD     WAdf(93)      V_FSDSCF93
     C                   Z-ADD     WAdf(94)      V_FSDSCF94
     C                   Z-ADD     WAdf(95)      V_FSDSCF95
     C                   Z-ADD     WAdf(96)      V_FSDSCF96
     C                   Z-ADD     WAdf(97)      V_FSDSCF97
     C                   Z-ADD     WAdf(98)      V_FSDSCF98
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAUTH - Validation of user's action code authority           *
      *                                                               *
      * Called By : Main                                              *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrAUTH        BEGSR
 
      ** Single branching.
 
     C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C**********         PARM      'I'           ACTN              1                          228812
     C                   PARM      PIACTN        ACTN              1                          228812
     C                   PARM                    PERR              1 0
 
      ** Multibranching.
 
     C                   ELSE
 
      ** Access default branch.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
     C                   CALL      'ZVACTBU'
     C**********         PARM      'I'           ACTN                                         228812
     C                   PARM      PIACTN        ACTN                                         228812
     C                   PARM      DBRN          ZDFB              3
     C                   PARM                    PERR              1 0
     C                   ENDIF
      *
      * This action code invalid for user.
      *
     C                   IF        PERR = 1
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9194'
     C                   ENDIF
      *
     C     ESrAuth       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCOMFLDS - Setup Common Fields                               *
      *                                                               *
      * Called By : SrVALDT                                           *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCOMFLDS     BEGSR
 
     C                   EVAL      V_FSRECI = FSRECI
     C                   EVAL      V_FSYLDC = FSYLDC
     C                   EVAL      V_FSYCCY = FSYCCY
     C                   EVAL      V_FSYICM = FSYICM
     C                   EVAL      V_FSYCFQ = FSYCFQ
     C                   IF        CAS008 ='Y'                                                CAS008
     C                   EVAL      V_FSSPDY = FSSPDY                                          CAS008
     C                   ENDIF                                                                CAS008
 
      ** If PKYCFQ is 'Y' default screen value of frequency with the value
      ** from the retrieved record of the file
 
     C                   IF        PKYCFQ = 'Y'
     C                   EVAL      PIYCFQ   = FSYCFQ
     C                   IF        CAS008 ='Y'                                                CAS008
     C**********         MOVE      FSSPDY        PISPDY                                CAS008 CRE026
     C                   Z-ADD     FSSPDY        WRKPDY                                       CRE026
     C                   MOVE      WRKPDY        PISPDY                                       CRE026
     C                   ELSE                                                                 CRE026
     C                   MOVE      *BLANKS       PISPDY                                       CRE026
     C                   ENDIF                                                                CAS008
     C                   ENDIF
 
     C                   EVAL      V_FSCHTP = FSCHTP
     C                   EVAL      V_FSLUSI = FSLUSI
     C                   EVAL      V_FSLCD = FSLCD
     C                   EVAL      V_FSTLUP = FSTLUP
     C                   EVAL      V_FSDLUP = FSDLUP
     C                   EVAL      V_FSMLUP = FSMLUP
     C                   EVAL      V_FSYLUP = FSYLUP
     C                   EVAL      V_FSFOTR = FSFRNT
     C                   EVAL      V_FSTMES = FSTMST
     C                   EVAL      V_FSRPRL = FSREPA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVFRNT - Validation for Front Office Transaction Interface   *
      *                                                               *
      * Called By : Main                                              *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrVFRNT       BEGSR
 
      ** Error if action code is not 'I','A','E' OR 'D'
 
     C                   IF        PIACTN <> 'I' AND
     C                             PIACTN <> 'A' AND
     C                             PIACTN <> 'E' AND
     C                             PIACTN <> 'D'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'APM0200'
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is Blank
 
     C                   IF        PFOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'APM0201'
     C                   GOTO      ENDVFRNT
     C                   ENDIF
 
      ** Access Transaction with Front Office Transaction ID
 
     C     PFOTRID       CHAIN     SDYLDRL3                           99
 
      ** If Insert
 
     C                   IF        PIACTN = 'I'
 
      ** Front Office Transaction ID can't be Present already
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'APM0202'
     C                   EVAL      MsgDtaAr2(Ix) = PFOTRID
     C                   GOTO      ENDVFRNT
     C                   ENDIF
 
     C                   ELSE
 
      ** If not insert, Front Office Transaction ID Must be Present
 
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0ACTN'
     C                   EVAL      MsgIdAr2(Ix) = 'APM0203'
     C                   EVAL      MsgDtaAr2(Ix) = PFOTRID
     C                   GOTO      ENDVFRNT
     C                   ENDIF
 
      ** If no error encountered, move accessed record fields to parameter fields to
      ** be validated as in back office mode
 
     C                   EVAL      PIYLDC = FSYLDC
     C                   EVAL      PIYCCY = FSYCCY
     C                   EVAL      PIYICM = FSYICM
 
     C                   ENDIF
 
     C     ENDVFRNT      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrINIT  - Initialisation Processing                           *
      *                                                               *
      * Called By : Main                                              *
      *                                                               *
      * Calls : SrSETOUT                                              *
      *                                                               *
      *****************************************************************
     C     SrINIT        BEGSR
 
      ** Define key to SDYLDRL1
 
     C     KYRAT         KLIST
     C                   KFLD                    PIYLDC
     C                   KFLD                    PIYCCY
     C                   KFLD                    PIYICM
 
      ** Clear/Initialise outputs
 
     C                   CLEAR                   YRATFilFmt
     C
     C                   Z-ADD     *ZERO         Wayy
     C                   Z-ADD     *ZERO         Wamm
     C                   Z-ADD     *ZERO         Wadd
     C                   Z-ADD     *ZERO         Wadf
     C                   Z-ADD     *ZERO         Ward
     C                   Z-ADD     *ZERO         Wamd
     C                   EXSR      SrSETOUT
 
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKYLDC = 'Y'
     C                   EVAL      OKYCCY = 'Y'
     C                   EVAL      OKYICM = 'Y'
     C                   EVAL      OKYCFQ = 'Y'
     C                   EVAL      OKSPDY = 'Y'                                               CAS008
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrKBLNK- Validates Blank Key Field                            *
      *                                                               *
      * Called By: SRValdt                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrKBLNK       BEGSR
 
      ** If yield curve or interest calculation method is blank, send error
      ** messages for the 3 key fields(curve/ccy/icm)
 
     C                   IF        (PIYCCY = *BLANKS AND PIYICM = *BLANKS)
     C                             OR (PIYLDC = *BLANKS)
 
     C                   EVAL      OKYLDC = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0YLDC'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9199'
     C                   EVAL      MsgDtaAr2(Ix) = *BLANKS
      *
     C                   EVAL      OKYCCY = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0YCCY'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9199'
     C                   EVAL      MsgDtaAr2(Ix) = *BLANKS
      *
     C                   EVAL      OKYICM = 'N'
     C                   ADD       1             Ix
     C                   EVAL      FldNameAr2(Ix) = '#0YICM'
     C                   EVAL      MsgIdAr2(Ix) = 'USR9199'
     C                   EVAL      MsgDtaAr2(Ix) = *BLANKS
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By: Called automatically upon module execution         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
 
      ** Return code
 
     C                   PARM                    RetCodeIn
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    ModeofOp
 
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Action Code
 
     C                   PARM                    PIACTN
 
      ** Yield Curve Name
 
     C                   PARM                    PIYLDC
 
      ** Currency
 
     C                   PARM                    PIYCCY
 
      ** Interest Calculation Method
 
     C                   PARM                    PIYICM
 
      ** Frequency
 
     C                   PARM                    PIYCFQ
 
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
     C                   PARM                    PISPDY                                       CAS008
                                                                                              CAS008
      ** Front Office Id
 
     C                   PARM                    PFOTRID
 
      ** OUTPUTS
      ** (Current) MM interest rates in file format
 
     C                   PARM                    YRATFilFmt
 
      ** OK - Action code
 
     C                   PARM                    OKACTN
 
      ** OK - Yield Curve Name
 
     C                   PARM                    OKYLDC
 
      ** OK - Yield Curve Currency
 
     C                   PARM                    OKYCCY
 
      ** OK - Interest Calculation Method
 
     C                   PARM                    OKYICM
 
      ** OK - Frequency
 
     C                   PARM                    OKYCFQ
 
      ** OK - Spot Days                                                                       CAS008
                                                                                              CAS008
     C                   PARM                    OKSPDY                                       CAS008
                                                                                              CAS008
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIdAr2
     C                   PARM                    MsgDtaAr2
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Ix
 
      ** Previous value of frequency
 
     C                   PARM                    PKYCFQ
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
      *                                                                                       CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY '    POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   IF        PRtCd <> *BLANKS AND                                       CAS008
     C                             PRtCd <> '*NRF'                                            CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ELSE                                                                 CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
 
      ** Access API ICD via access program
 
     C**********         CALLB     'AOAPIR0'                                                  212406
     C**********         PARM      '*DBERR '     PRTCD                                        212406
     C**********         PARM      '*FIRST '     POPTN                                        212406
     C*****SDAPI         PARM      SDAPI         DSFDY                                        212406
 
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
