     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate security short name')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVSESH - Valid Security Short Name                          *
      *                                                               *
      *  Function: This Program Validates Security Short Name         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. 240493             Date 27Jun06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204803             Date 17Apr02               *
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE005             Date 20Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1June99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  240493 - Validation of security with coupon date prior to    *
      *           maturity date of the repo deal should be done when  *
      *           coupon due/payment (BVRCPN) field in SE ICD is 'N'. *
      *           No validation is required if setup as 'Y'.          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  204803 - Allow '?' insertion.                                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE005 - Added  3 more Parameters  when calling  ZNCD  module*
      *           which were introduced in it  by this  amendment .   *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
     FINVTP     IF   E           K DISK
     F                                     INFSR(*PSSR)
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
 
      ** Warning message code 1 returned to caller
     D WMsg1           S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
 
     D LoanCcy         S              3A
     ** Currency of Repo
 
     D ValueDate       S              5  0
     ** Value Date of Repo
 
     D MaturDate       S              5  0
     ** Maturity Date of Repo
 
      ** Parameters
      ** Security Details
     D SECTYDT       E DS                  EXTNAME(SECTYD)
     D CDArr                 183    230
     D CRArr                 231    242
 
     D ECD             S              5  0
     ** Event Control Date
 
     D*NCD*********    S              5  0                                                    CSE031
     ** Next Control Date
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D**  Securities Trading ICD Data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   WMsg1
     C                   RESET                   IFSECT
      *
      ** Secturity Shortname cannot be blank
      *
     C
     C                   IF        IKSECT = *BLANKS
     C                   MOVE      'MMA0754'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C
     C                   ELSE
      *                                                                                       204803
     C                   MOVEL     IKSECT        @QMK              1                          204803
     C     @QMK          IFEQ      '?'                                                        204803
     C                   MOVEL     IKSECT        @SESN                                        204803
     C                   CALL      'SE0043'                                                   204803
     C                   PARM                    @ACDE             1                          204803
     C                   PARM                    @SESN            10                          204803
     C     @SESN         IFNE      *BLANKS                                                    204803
     C                   MOVE      @SESN         IKSECT                                       204803
     C                   ELSE                                                                 204803
     C                   MOVE      *BLANKS       IKSECT                                       204803
     C                   ENDIF                                                                204803
     C                   ENDIF                                                                204803
      *
      ** Access Security details for security Ccy
      *
     C     IKSECT        CHAIN     SECTY                              99
     C
      *
      ** Security shoul dexist and be live
      *
     C                   IF        *IN99 = *ON or RECI <> 'D'
     C                   MOVE      'MMA0755'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ELSE
     C
      ** Do not allow input of incomplete securities
     C                   IF        INCS = 'I'
     C                   MOVE      'MMA0740'     MSG5
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
      *
      ** If Security matures before Repo Matures and ICD does not
      ** allow maturing securities then send an error message
      *
     C                   IF        MATY <> 0
     C                   IF        MATY < MaturDate
     C                   IF        BVRMAT = 'N' or BVRMAT = ' '
     C                   MOVE      'MMA0756'     WMSG1
     C                   MOVE      'W'           ErrorFound        1
     C                   ELSE
     C                   MOVE      'MMA0758'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     ** Access Investment Details
     C     INVTPK        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
     C     INVTPK        CHAIN     INVTPDF                            90
     C
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'
     C
     C                   CALLB     'ZNCD'
      ** Security details
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
      *
      ** Event Control Date
      ** Date Format
     C                   PARM      ValueDate     ECD
     C                   PARM                    BJDFIN
      *                                                                                       CSE005
      ** Nominal Currency                                                                     CSE005
      ** Security Investment Type                                                             CSE005
      ** Effect on Holidays on Coupon Dates                                                   CSE005
     C                   PARM                    NMCY              3                          CSE005
     C                   PARM                    SITP              3                          CSE005
     C                   PARM                    BCNV              1                          CSE005
      *                                                                                       CSE031
      ** Last Coupon Date                                                                     CSE031
     C                   PARM                    LCPN                                         CSE031
      ** Effect of Holidays on Dates                                                          CSE071
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
 
      * OUTPUTS
 
      ** Next Coupon Date
     C                   PARM                    NCD
 
     C**********         IF        NCD < MaturDate and BVRCPN = 'Y'                           240493
     C                   IF        NCD < MaturDate and BVRCPN = 'N'                           240493
     C                   MOVE      'MMA0757'     MSG4
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        ErrorFound = 'W'
     C                   EVAL      ReturnCode = 'Warning'
     C                   ENDIF
     C
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
     C                   MOVE      IKSECT        IFSECT
     C                   ENDIF
      *
     C                   RETURN
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSG5
     C                   PARM                    WMSG1
      * Receive Security Shortname
     C                   PARM                    IKSECT           10
      * Receive Loan Currency
     C                   PARM                    LoanCcy
      * Receive Value Date
     C                   PARM                    ValueDate
      * Receive Maturity Date
     C                   PARM                    MaturDate
      * Receive Security Shortname
     C                   PARM                    IFSECT           10
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMVSESH'     DBPGM
     C                   OUT       LDA
      *
      **  Access Bank Details via Access Object
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access securities trading details
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
     C*
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
