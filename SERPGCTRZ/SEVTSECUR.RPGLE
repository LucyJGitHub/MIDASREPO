     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Security Shortname')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTSECUR - Validate Trade Security Shortname                *
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
      *                 CGL035             Date 01Mar05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211553             Date 27Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 186566             Date 31Apr01               *
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
      *                 CAP003  *CREATE    Date 20Mar98               *
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
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE065 - Constant Yield Amortisation on Mortgage Backed      *
      *           Assets (Recompile)                                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B.                           *
      *  211553 - For action codes other than "E"nquiry and "D"elete  *
      *           check first if the security name is live and        *
      *           existing.                                           *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CAP067 - Repurchase Agreements API.                          *
      *  186566 - Validation not done when action is not Insert/      *
      *           Enquire.  Amended program to ensure that validation *
      *           is done.  Added conditions to check action code to  *
      *           determine the correct error message to display.     *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax. (Recompile)                 *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CSE010 - SE Transactions Enhancements.                       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Security Details
     D SECTYDts      E DS                  EXTNAME(SECTYD)
 
      ** Investment Type Details
     D INVTPDts      E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
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
 
     C                   MOVEL     *BLANK        TDSS
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      SESNV
     C                   END
      *
      * If security is valid, get other security details
      *
     C     DDSESNOK      IFNE      'N'
     C                   EXSR      GETOTHSECD
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDSESNOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     SESNV         BEGSR
      *                                                                                       CSE010
      ** If CSE010 is ON and '?' is entered, call subroutine BRWNEW.                          CSE010
      *                                                                                       CSE010
     C     CSE010        IFEQ      'Y'                                                        CSE010
     C     DDSESN        ANDEQ     '?'                                                        CSE010
     C                   EXSR      BRWNEW                                                     CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       186566
     C     DDACTN        IFNE      'I'                                                        186566
     C     DDSESN        CHAIN     SECTYDF                            44                      186566
     C                   END                                                                  186566
      *                                                                                       186566
     C*****DDACTN        IFEQ      'I'                                                        186566
     C     DDACTN        IFNE      'E'                                                        211553
     C     DDACTN        ANDNE     'D'                                                        211553
      *
      ** If ? processing available and ? entered, browse securities
      *
     C     CSE003        IFEQ      'Y'
     C     DDSESN        ANDEQ     '?'
      *                                                                                       CSE010
      ** And CSE010 is OFF,                                                                   CSE010
      *                                                                                       CSE010
     C     CSE010        ANDEQ     'N'                                                        CSE010
     C                   EXSR      BRWSESN
     C                   ENDIF
      *
      ** Security must exist and be live
      *
     C     DDSESN        CHAIN     SECTYDF                            44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVE      'N'           ddSESNok
     C                   ADD       1             Idx
     C                   MOVEL     'DDSESN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0112'     MsgIdXAr(Idx)
     C                   END
     C                   END                                                                  186566
      *
      ** No actions are permitted on a security being Market Migrated
      ** if S01511 (Market Migration) is active
      *
     C     S01511        IFEQ      'Y'
     C     *IN44         ANDEQ     '0'
     C     RECI          ANDEQ     'D'
     C     SMAI          IFEQ      'Y'
     C                   MOVE      'N'           ddSESNok
     C                   ADD       1             Idx
     C                   MOVEL     'DDSESN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0114'     MsgIdXAr(Idx)
     C                   GOTO      ESESNV
     C                   END
     C                   END
      *
      *  Only action allowed on a matured or deleted security is enquiry
      *
     C     *IN44         IFEQ      '0'
     C     DDACTN        ANDNE     'E'                                                        186566
     C     MATY          ANDNE     *ZEROS
     C     MATY          ANDLT     BJRDNB
     C                   MOVE      'N'           ddSESNok
     C                   ADD       1             Idx
     C                   MOVEL     'DDSESN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0113'     MsgIdXAr(Idx)
     C                   END
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the first leg,                    CAP067
      ** store trade customer                                                                 CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'Y'                                                        CAP067
     C                   MOVE      DDSESN        PFSESN                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the second leg,                   CAP067
      ** it must be the same as the its first leg's security shortname, else error            CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'N'                                                        CAP067
     C     DDSESN        IFNE      PFSESN                                                     CAP067
     C                   MOVEL     'N'           ddSESNok                                     CAP067
     C                   ADD       1             Idx                                          CAP067
     C                   MOVEL     'DDSESN'      FldNamXAr(Idx)                               CAP067
     C                   MOVEL     'MMA1218'     MsgIdXAr(Idx)                                CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
 
      * Update trade details
 
     C                   MOVEL     DDSESN        TDSS
 
     C     ESESNV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** BROWSE SECURITIES
      *****************************************************************
     C     BRWSESN       BEGSR
 
     C     *LOCK         IN        SESDS
     C                   MOVE      '6'           RTNC
     C                   MOVE      *BLANKS       RQSESN
     C                   OUT       SESDS
     C                   CALL      'SE0240'
     C                   IN        SESDS
     C     RTNC          IFNE      '0'
     C     RTNC          ANDNE     '1'
     C                   MOVE      RQSESN        DDSESN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSE010
      *                                                               *                       CSE010
      * BRWNEW - Browse Security Files (Securities Selection Pgm)     *                       CSE010
      *                                                               *                       CSE010
      * Called by: SESNV                                              *                       CSE010
      *                                                               *                       CSE010
      * Calls: None                                                   *                       CSE010
      *                                                               *                       CSE010
      *****************************************************************                       CSE010
     C     BRWNEW        BEGSR                                                                CSE010
      *                                                                                       CSE010
     C                   MOVEL     DDSESN        @SESN            10                          CSE010
      *                                                                                       CSE010
     C                   CALL      'SE0043'                                                   CSE010
     C                   PARM      DDACTN        PACODE            1                          CSE010
     C                   PARM                    @SESN            10                          CSE010
      *                                                                                       CSE010
     C     @SESN         IFNE      *BLANKS                                                    CSE010
     C                   MOVEL     @SESN         DDSESN                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      *BLANKS       DDSESN                                       CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C                   ENDSR                                                                CSE010
      *****************************************************************                       CSE010
      /EJECT                                                                                  CSE010
      *****************************************************************
      * GETOTHSECD - Get other security details
      *****************************************************************
     C     GETOTHSECD    BEGSR
 
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
     C                   MOVEL     A6INCY        NomCcyINCY
     C                   Z-ADD     A6EUER        NomCcyEUER
     C                   MOVEL     A6EUMD        NomCcyEUMD
     C                   Z-ADD     A6TPSD        NomCcyTPSD
     C                   Z-ADD     A6TPED        NomCcyTPED
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
     C                   PARM                    DDSESN           10
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
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell security shortname                                                    CAP067
     C                   PARM                    PFSESN           10                          CAP067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Shortname - OK
     C                   PARM                    DDSESNOK          1
      *
      ** Trade Security Shortname
      *
     C                   PARM                    TDSS             10
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
