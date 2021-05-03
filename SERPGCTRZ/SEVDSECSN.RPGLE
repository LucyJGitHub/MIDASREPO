     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Security Shortname')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDSECSN - Validate Security Shortname                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 237063             Date 20Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010             Date 21Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP003  *CREATE    Date 06Jul98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  237063 - EU Tax fixes upgrade to MP build 103 (Recompile).   *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B.                           *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax (Recompiled)                 *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CSE010 - SE Transactions Enhancements.                       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
     FINVTP     IF   E           K DISK
 
      *****************************************************************
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
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
      ** Security Details
     D SECTYDts      E DS                  EXTNAME(SECTYD)
 
      ** Investment Type Details
     D INVTPDts      E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
     D NomCcyDts       DS
      ** Nominal Currency Details
     D  NomCcySPRT             1     13  8
     D  NomCcyDec             14     14P 0
     D  NomCcyMDIN            15     15
     D  NomCcyNQDP            16     16  0
     D  NomCcySWCY            17     19
     D  NomCcyCDFN            20     21
     D  NomCcyECDN            22     23
 
      ** Linked Enquiry Details
     D SESDS         E DS
 
      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C                   MOVEL     *BLANK        DPSS
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      SRDPSSV
     C                   END
      *
      ** If security is valid, get other security details
      *
     C     DDDPSSOk      IFNE      'N'
     C                   EXSR      SRODetails
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPSSOk      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRDPSSV - Validation routine for Security ShortName           *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SRBrwDPSS                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDPSSV       BEGSR
      *                                                                                       CSE010
      ** If CSE010 is ON and '?' is entered, call subroutine SRBrwDPSSN.                      CSE010
      *                                                                                       CSE010
     C     CSE010        IFEQ      'Y'                                                        CSE010
     C     DDDPSS        ANDEQ     '?'                                                        CSE010
     C                   EXSR      SRBrwDPSSN                                                 CSE010
     C                   ENDIF                                                                CSE010
      *
      ** If ? processing available and ? entered, browse securities
      *
     C     CSE003        IFEQ      'Y'
     C     DDDPSS        ANDEQ     '?'
      *                                                                                       CSE010
      ** And CSE010 is OFF,                                                                   CSE010
      *                                                                                       CSE010
     C     CSE010        ANDEQ     'N'                                                        CSE010
     C                   EXSR      SRBrwDPSS
     C                   ENDIF
 
     C     DDDPSS        IFEQ      *BLANKS
      *
      ** Error 104
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPSS'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0219'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPSSOK
     C                   GOTO      EDPSSV
 
     C                   END
      *
      ** Security must exist and be live
      *
     C     DDDPSS        CHAIN     SECTYDF                            44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVE      'N'           DDDPSSok
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPSS'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0219'     MsgIdXAr(Idx)
     C                   END
      *
      ** No actions are permitted on a security being Market Migrated
      ** if S01511 (Market Migration) is active
      *
     C     S01511        IFEQ      'Y'
     C     *IN44         ANDEQ     '0'
     C     RECI          ANDEQ     'D'
 
     C     SMAI          IFEQ      'Y'
     C                   MOVE      'N'           DDDPSSok
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPSS'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0220'     MsgIdXAr(Idx)
     C                   GOTO      EDPSSV
     C                   END
 
     C                   END
      *
      *  Only action allowed on a matured or deleted security is enquiry
      *
     C     *IN44         IFEQ      '0'
     C     MATY          ANDNE     *ZEROS
     C     MATY          ANDLT     BJRDNB
     C                   MOVE      'N'           DDDPSSok
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPSS'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0113'     MsgIdXAr(Idx)
     C                   END
 
      * Update trade details
 
     C                   MOVEL     DDDPSS        DPSS
 
     C     EDPSSV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRBrwDPSS - Browse Security Files                             *
      *                                                               *
      * Called by: SRDPSSV                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBrwDPSS     BEGSR
 
     C     *LOCK         IN        SESDS
     C                   MOVE      '6'           RTNC
     C                   MOVE      *BLANKS       RQSESN
     C                   OUT       SESDS
     C                   CALL      'SE0240'
     C                   IN        SESDS
     C     RTNC          IFNE      '0'
     C     RTNC          ANDNE     '1'
     C                   MOVE      RQSESN        DDDPSS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * SRBrwDPSSN - Browse Security Files (Securities Selection Pgm) *                       CSE010
      *                                                               *                       CSE010
      * Called by: SRDPSSV                                            *                       CSE010
      *                                                               *                       CSE010
      * Calls: None                                                   *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     SRBrwDPSSN    BEGSR                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     DDDPSS        @SESN            10                          CSE010
     C                   CALL      'SE0043'                                                   CSE010
     C                   PARM      DDACTN        PACODE            1                          CSE010
     C                   PARM                    @SESN                                        CSE010
      *                                                                                       CSE010
     C     @SESN         IFNE      *BLANKS                                                    CSE010
     C                   MOVEL     @SESN         DDDPSS                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      *BLANKS       DDDPSS                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************
      *                                                               *
      * SRODetails - Get other security details                       *
      *                                                               *
      * Called by: SRDPSSV                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRODetails    BEGSR
 
      * Get investment type details
 
     C     KLINVT        KLIST
     C                   KFLD                    CCYI
     C                   KFLD                    INVT
     C                   MOVEL     NMCY          CCYI
     C                   MOVEL     SITP          INVT
     C     KLINVT        CHAIN     INVTPDF                            99
     C     *IN99         IFEQ      '1'
     C                   CLEAR                   INVTPDts
     C                   END
 
      * Get nominal currency details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      NMCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     A6SPRT        NomCcySPRT
     C                   Z-ADD     A6NBDP        NomCcyDec
     C                   MOVEL     A6MDIN        NomCcyMDIN
     C                   MOVEL     A6NQDP        NomCcyNQDP
     C                   MOVEL     A6SWCY        NomCcySWCY
     C                   MOVEL     A6CDFN        NomCcyCDFN
     C                   MOVEL     A6ECDN        NomCcyECDN
     C                   ELSE
     C                   CLEAR                   NomCcyDts
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Security Shortname
     C                   PARM                    DDDPSS           10
      *
      ** ICD
     C                   PARM                    CSE003            1
     C                   PARM                    S01511            1
     C                   PARM                    BJRDNB            5 0
      *                                                                                       CSE010
      ** SE Transactions Enhancements                                                         CSE010
      *                                                                                       CSE010
     C                   PARM                    CSE010            1                          CSE010
      *                                                                                       CSE010
      ** Action Code                                                                          CSE010
      *                                                                                       CSE010
     C                   PARM                    DDACTN            1                          CSE010
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Shortname - OK
     C                   PARM                    DDDPSSOk          1
      *
      ** Trade Security Shortname
      *
     C                   PARM                    DPSS             10
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTYDts
     C                   PARM                    INVTPDts
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Linked Enquiry Dataarea
      *
     C     *DTAARA       DEFINE                  SESDS
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
