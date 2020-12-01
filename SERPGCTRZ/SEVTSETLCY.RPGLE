     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Settlement Currency')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTSETLCY - Validate Trade settlement currency.             *
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
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG8534            Date 15Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 23Apr02               *
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CAP003  *CREATE    Date 23Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG8534- Allow defaulting value ccy to settlement ccy        *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSTDSED    IF   E           K DISK
 
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
     D SECTY         E DS                  EXTNAME(SECTYD)
 
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CSE028
      ** DS for customer/book standard settlement instruction                                 CSE028
      **  to be passed to SESSIR0                                                             CSE028
      *                                                                                       CSE028
     D PCBSTD        E DS                  EXTNAME(STDSED) OCCURS(2)                          CSE028
     D  STRECI       E                     EXTFLD(RECI)                                       CSE028
     D  STLCD        E                     EXTFLD(LCD)                                        CSE028
     D  STCHTP       E                     EXTFLD(CHTP)                                       CSE028
     D  STTNLU       E                     EXTFLD(TNLU)                                       CSE028
      *                                                                                       CSE028
      ** Data structure for standard additional settlement details                            CSE028
      ** for customer/book to be passed to SESSIR0                                            CSE028
      *                                                                                       CSE028
     D PCBSAD        E DS                  EXTNAME(STDADSED) OCCURS(8)                        CSE028
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
                                                                                              CSE028
     D CSE028          S              1A                                                      CSE028
      *                                                                                       CSE028
      ** Parameter Fields for call to SESSIR0.                                                CSE028
     D POTYP           S              1A   INZ('D')                                           CSE028
     D PBRCH           S              3A                                                      CSE028
     D PCUST           S              6A                                                      CSE028
     D PBOOK           S              2A                                                      CSE028
     D PCURR           S              3A                                                      CSE028
     D PMRKT           S              2A                                                      CSE034
     D PINVT           S              3A                                                      CSE028
     D PPTFR           S              4A                                                      CSE028
     D PRTCD           S              5A                                                      CSE028
 
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
 
     C                   MOVEL     *BLANK        SETC
      *
      ** DEFAULT Settlement currency
      *
     C     Default       IFEQ      'Y'
     C     DDSETC        ANDEQ     *BLANKS
     C                   EXSR      SETCD
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      SETCV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDSetcOK      IFEQ      'N'
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
     C     SETCV         BEGSR
      *
      * Settlement currency must be present
      *
     C     DDSETC        IFEQ      *BLANKS
     C                   MOVE      'N'           DDSetcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSETC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0501'     MsgIdXAr(Idx)
      *
      * If present and it does not equal the nominal currency
      * the security must be multi-currency
      * or the customer must be a portfolio customer.
      *
     C                   ELSE
 
     C                   MOVEL     NomCcyDts     SetCcyDts
 
     C     DDSETC        IFNE      NMCY
 
     C     MLTI          IFNE      'Y'
     C     CustClass     ANDNE     'S'
     C     CustClass     ANDNE     'D'
                                                                                             BUG8534
      * If S01509 is OFF then the defaulting subroutine might have defaulted                 BUG8534
      * The settlement ccy to be the same as the value currency, if so                       BUG8534
      * then we should allow this.                                                           BUG8534
     C     VLCY          IFEQ      DDSETC                                                    BUG8534
     C     S01509        ANDEQ     'N'                                                       BUG8534
     C* must reference an active record on SDCURRPD                                          BUG8534
     C*                                                                                      BUG8534
     C                   EXSR      AOCURR                                                    BUG8534
     C     @RTCD         IFNE      *BLANKS                                                   BUG8534
     C     A6DLCI        OREQ      'N'                                                       BUG8534
     C                   MOVE      'N'           DDSetcOK                                    BUG8534
     C                   ADD       1             Idx                                         BUG8534
     C                   MOVEL     'DDSETC'      FldNamXAr(Idx)                              BUG8534
     C                   MOVEL     'MMA0501'     MsgIdXAr(Idx)                               BUG8534
     C                   ELSE                                                                BUG8534
     C                   MOVEL     A6SPRT        SetCcySPRT                                  BUG8534
     C                   Z-ADD     A6NBDP        SetCcyDec                                   BUG8534
     C                   MOVEL     A6MDIN        SetCcyMDIN                                  BUG8534
     C                   MOVEL     A6NQDP        SetCcyNQDP                                  BUG8534
     C                   MOVEL     A6SWCY        SetCcySWCY                                  BUG8534
     C                   MOVEL     A6CDFN        SetCcyCDFN                                  BUG8534
     C                   MOVEL     A6ECDN        SetCcyECDN                                  BUG8534
     C                   MOVEL     A6INCY        SetCcyINCY                                  BUG8534
     C                   Z-ADD     A6EUER        SetCcyEUER                                  BUG8534
     C                   MOVEL     A6EUMD        SetCcyEUMD                                  BUG8534
     C                   Z-ADD     A6TPSD        SetCcyTPSD                                  BUG8534
     C                   Z-ADD     A6TPED        SetCcyTPED                                  BUG8534
     C                   ENDIF                                                               BUG8534
     C                   ELSE                                                                BUG8534
 
      * Euro settlement of an 'in' currency is allowed if CEU005 is on
 
     C     CEU005        IFEQ      'Y'
     C     DDSETC        IFNE      BKEURO
     C     NomCcyINCY    ORNE      'Y'
     C                   MOVE      'N'           DDSetcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSETC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0677'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           DDSetcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSETC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0502'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                               BUG8534
 
     C                   ELSE
     C*
     C*    .. if entered, must reference an active record on SDCURRPD
     C*
     C                   EXSR      AOCURR
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        OREQ      'N'
     C                   MOVE      'N'           DDSetcOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSETC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0501'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     A6SPRT        SetCcySPRT
     C                   Z-ADD     A6NBDP        SetCcyDec
     C                   MOVEL     A6MDIN        SetCcyMDIN
     C                   MOVEL     A6NQDP        SetCcyNQDP
     C                   MOVEL     A6SWCY        SetCcySWCY
     C                   MOVEL     A6CDFN        SetCcyCDFN
     C                   MOVEL     A6ECDN        SetCcyECDN
     C                   MOVEL     A6INCY        SetCcyINCY
     C                   Z-ADD     A6EUER        SetCcyEUER
     C                   MOVEL     A6EUMD        SetCcyEUMD
     C                   Z-ADD     A6TPSD        SetCcyTPSD
     C                   Z-ADD     A6TPED        SetCcyTPED
     C                   END
     C                   END
     C                   END
     C                   END
      *
      * Update trade
      *
     C                   MOVE      DDSETC        SETC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     SETCD         BEGSR
      *
      * If counterparty classification is portfolio
      *
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
      *
      ** Access Standard Settlement details for value currency
      ** If S01509 is active, instead of the value currency, use the
      ** nominal currency
      *
     C                   MOVEL     DDBRCD        SBRA
     C                   MOVEL     TCNR          CSTM
     C     S01509        IFEQ      'Y'
     C                   MOVEL     NMCY          CYSI
     C                   ELSE
     C                   MOVEL     VLCY          CYSI
     C                   END
      *                                                                                       CSE028
     C                   EVAL      SIBK = *BLANKS                                             CSE028
      *                                                                                       CSE028
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information                       CSE028
      *                                                                                       CSE028
     C                   IF        CSE028 = 'Y'                                               CSE028
     C                   EVAL      *IN99 = *OFF                                               CSE028
     C                   MOVEL     CSTM          PCUST                                        CSE028
     C                   CALL      'SESSIR0'                                                  CSE028
     C                   PARM                    POTYP                                        CSE028
     C                   PARM      SBRA          PBRCH                                        CSE028
     C                   PARM                    PCUST                                        CSE028
     C                   PARM      DDBPBK        PBOOK                                        CSE028
     C                   PARM      CYSI          PCURR                                        CSE028
     C                   PARM      SMCC          PMRKT                                        CSE034
     C                   PARM      SITP          PINVT                                        CSE028
     C                   PARM      *BLANKS       PPTFR                                        CSE028
     C                   PARM                    PCBSTD                                       CSE028
     C                   PARM                    PCBSAD                                       CSE028
     C                   PARM      *BLANKS       PRTCD                                        CSE028
      *                                                                                       CSE028
     C                   SELECT                                                               CSE028
      *                                                                                       CSE028
      ** Retrieve DS for Customer.                                                            CSE028
     C                   WHEN      PRTCD <> '*NRF ' AND PRTCD <> '*NCRF'                      CSE028
     C     2             OCCUR     PCBSTD                                                     CSE028
     C                   EVAL      RECI = STRECI                                              CSE028
      *                                                                                       CSE028
      ** Retrieve DS for Book.                                                                CSE028
     C                   WHEN      PRTCD <> '*NRF ' AND PRTCD <> '*NBRF'                      CSE028
     C     1             OCCUR     PCBSTD                                                     CSE028
     C                   EVAL      RECI = STRECI                                              CSE028
      *                                                                                       CSE028
      ** Set on Record Not Found indicator.                                                   CSE028
     C                   OTHER                                                                CSE028
     C                   EVAL      *IN99 = *ON                                                CSE028
     C                   ENDSL                                                                CSE028
      *                                                                                       CSE028
     C                   ELSE                                                                 CSE028
 
     C     KLSTD1        CHAIN     STDSEDF                            99
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C     *IN99         IFEQ      '0'
     C     RECI          ANDNE     '*'
     C     S01509        IFEQ      'Y'
     C                   MOVEL     NMCY          DDSETC
     C                   ELSE
     C                   MOVEL     VLCY          DDSETC
     C                   END
     C                   ELSE
     C     CustCurr      IFNE      *BLANKS
     C                   MOVEL     CustCurr      DDSETC
     C                   ELSE
     C     VLCY          IFNE      *BLANKS
     C     S01509        ANDEQ     'N'
     C                   MOVEL     VLCY          DDSETC
     C                   ELSE
     C                   MOVEL     NMCY          DDSETC
     C                   END
     C                   END
     C                   END
     C*
     C                   ELSE
 
     C     MLTI          IFEQ      'Y'
     C                   MOVEL     NMCY          DDSETC
     C                   ELSE
     C     VLCY          IFNE      *BLANKS
     C     S01509        ANDEQ     'N'
     C                   MOVEL     VLCY          DDSETC
     C                   ELSE
     C                   MOVEL     NMCY          DDSETC
     C                   END
     C                   END
     C*
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AOCURR - Access Currency Details                              *
      *****************************************************************
     C     AOCURR        BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDSETC        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
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
      ** Trade Screen fields
     C                   PARM                    DDSETC            3
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK            2                          CSE028
      *
      ** Security Details
     C                   PARM                    SECTY
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer Classification
      ** Customer Currency Code
      ** Customer number
      *
     C                   PARM                    CustClass         1
     C                   PARM                    CustCurr          3
     C                   PARM                    TCNR
      *
      ** Euro currency code
      ** S01509 on
      ** CEU005 on
     C                   PARM                    BKEURO            3
     C                   PARM                    S01509            1
     C                   PARM                    CEU005            1
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
      *
      * OUTPUTS
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Settlement Currency - OK
     C                   PARM                    DDSetcOK          1
      *
      ** Trade Settlement Currency
      *
     C                   PARM                    SETC              3
      *
      * Define key list for file STDSED
      *
     C     KLSTD1        KLIST
     C                   KFLD                    SBRA
     C                   KFLD                    CSTM
     C                   KFLD                    SIBK                                         CSE028
     C                   KFLD                    CYSI
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
